import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/app_plan.dart';
import '../../data/models/local_song.dart';
import '../../data/models/playlist.dart';
import '../../data/repositories/music_repository.dart';
import '../../data/services/audio_player_service.dart';
import '../../data/services/purchase_service.dart';
import '../../data/services/storage_service.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required MusicRepository musicRepository,
    required AudioPlayerService audioService,
    required PurchaseService purchaseService,
    required StorageService storageService,
  })  :
        // Public constructor names keep dependency injection readable across libraries.
        // ignore: prefer_initializing_formals
        _musicRepository = musicRepository,
        // ignore: prefer_initializing_formals
        _audioService = audioService,
        // ignore: prefer_initializing_formals
        _purchaseService = purchaseService,
        // ignore: prefer_initializing_formals
        _storageService = storageService,
        super(const AppState()) {
    _subscriptions = [
      _audioService.playingStream.listen((playing) => emit(state.copyWith(playing: playing))),
      _audioService.positionStream.listen((position) => emit(state.copyWith(position: position))),
      _audioService.durationStream.listen((duration) {
        emit(state.copyWith(duration: duration ?? state.currentSong?.duration ?? Duration.zero));
      }),
    ];
  }

  final MusicRepository _musicRepository;
  final AudioPlayerService _audioService;
  final PurchaseService _purchaseService;
  final StorageService _storageService;
  late final List<StreamSubscription<dynamic>> _subscriptions;

  Future<void> restore() async {
    final songs = _musicRepository.cachedSongs();
    await Future<void>.delayed(const Duration(seconds: 2));
    emit(state.copyWith(
      status: songs.isEmpty ? AppStatus.permission : AppStatus.ready,
      plan: _storageService.plan,
      darkMode: _storageService.darkMode,
      songs: songs,
      favorites: _storageService.loadFavorites(),
      recentIds: _storageService.loadRecentIds(),
      playlists: _storageService.loadPlaylists(),
    ));
  }

  Future<void> requestAndScan() async {
    emit(state.copyWith(status: AppStatus.scanning, scanProgress: 0.12));
    final allowed = await _musicRepository.requestAccess();
    if (!allowed) {
      emit(state.copyWith(status: AppStatus.permission));
      return;
    }
    emit(state.copyWith(scanProgress: 0.62));
    final songs = await _musicRepository.scan();
    emit(state.copyWith(
      status: AppStatus.ready,
      scanProgress: 1,
      songs: songs,
      currentSong: songs.isEmpty ? null : songs.first,
      currentIndex: 0,
    ));
  }

  void setNavIndex(int index) => emit(state.copyWith(navIndex: index));
  void setQuery(String query) => emit(state.copyWith(query: query));

  Future<void> play(LocalSong song) async {
    final index = state.songs.indexWhere((item) => item.id == song.id);
    emit(state.copyWith(
      currentSong: song,
      currentIndex: index < 0 ? state.currentIndex : index,
      duration: song.duration,
      position: Duration.zero,
    ));
    await _storageService.addRecent(song.id);
    emit(state.copyWith(recentIds: _storageService.loadRecentIds()));
    await _audioService.playSong(song);
  }

  Future<void> togglePlay() => _audioService.toggle();
  Future<void> seek(Duration position) => _audioService.seek(position);

  Future<bool> next() async {
    if (!state.plan.canUseTransport) return false;
    if (state.songs.isEmpty) return true;
    final index = (state.currentIndex + 1) % state.songs.length;
    await play(state.songs[index]);
    return true;
  }

  Future<bool> previous() async {
    if (!state.plan.canUseTransport) return false;
    if (state.songs.isEmpty) return true;
    final index = state.currentIndex == 0 ? state.songs.length - 1 : state.currentIndex - 1;
    await play(state.songs[index]);
    return true;
  }

  Future<bool> toggleFavorite(LocalSong song) async {
    if (!state.plan.canUseLibraryPowerTools) return false;
    final next = {...state.favorites};
    final favorite = !next.contains(song.id);
    favorite ? next.add(song.id) : next.remove(song.id);
    await _storageService.setFavorite(song.id, favorite);
    emit(state.copyWith(favorites: next));
    return true;
  }

  Future<void> toggleTheme(bool dark) async {
    if (!state.plan.canUseLibraryPowerTools) return;
    await _storageService.saveDarkMode(dark);
    emit(state.copyWith(darkMode: dark));
  }

  Future<void> upgrade(AppPlan plan) async {
    await _purchaseService.buy(plan);
    await _storageService.savePlan(plan);
    emit(state.copyWith(plan: plan));
  }

  Future<void> restorePurchases() async {
    await _purchaseService.restore();
    emit(state.copyWith(plan: _storageService.plan));
  }

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await _audioService.dispose();
    await _purchaseService.dispose();
    return super.close();
  }
}
