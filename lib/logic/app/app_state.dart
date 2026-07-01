part of 'app_cubit.dart';

enum AppStatus { splash, permission, scanning, ready }

class AppState extends Equatable {
  const AppState({
    this.status = AppStatus.splash,
    this.plan = AppPlan.free,
    this.darkMode = false,
    this.songs = const [],
    this.favorites = const {},
    this.recentIds = const [],
    this.playlists = const [],
    this.currentSong,
    this.currentIndex = 0,
    this.playing = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.navIndex = 0,
    this.scanProgress = 0,
    this.query = '',
  });

  final AppStatus status;
  final AppPlan plan;
  final bool darkMode;
  final List<LocalSong> songs;
  final Set<int> favorites;
  final List<int> recentIds;
  final List<Playlist> playlists;
  final LocalSong? currentSong;
  final int currentIndex;
  final bool playing;
  final Duration position;
  final Duration duration;
  final int navIndex;
  final double scanProgress;
  final String query;

  bool get isPaid => plan.isPaid;
  bool get isPremium => plan.isPremium;

  List<LocalSong> get filteredSongs {
    final value = query.trim().toLowerCase();
    if (value.isEmpty) return songs;
    return songs
        .where((song) =>
            song.title.toLowerCase().contains(value) ||
            song.artist.toLowerCase().contains(value) ||
            song.album.toLowerCase().contains(value))
        .toList();
  }

  List<LocalSong> get recentSongs {
    final byId = {for (final song in songs) song.id: song};
    return recentIds.map((id) => byId[id]).whereType<LocalSong>().toList();
  }

  Map<String, List<LocalSong>> get albums {
    final result = <String, List<LocalSong>>{};
    for (final song in songs) {
      result.putIfAbsent(song.album, () => []).add(song);
    }
    return result;
  }

  Map<String, List<LocalSong>> get artists {
    final result = <String, List<LocalSong>>{};
    for (final song in songs) {
      result.putIfAbsent(song.artist, () => []).add(song);
    }
    return result;
  }

  AppState copyWith({
    AppStatus? status,
    AppPlan? plan,
    bool? darkMode,
    List<LocalSong>? songs,
    Set<int>? favorites,
    List<int>? recentIds,
    List<Playlist>? playlists,
    LocalSong? currentSong,
    int? currentIndex,
    bool? playing,
    Duration? position,
    Duration? duration,
    int? navIndex,
    double? scanProgress,
    String? query,
  }) {
    return AppState(
      status: status ?? this.status,
      plan: plan ?? this.plan,
      darkMode: darkMode ?? this.darkMode,
      songs: songs ?? this.songs,
      favorites: favorites ?? this.favorites,
      recentIds: recentIds ?? this.recentIds,
      playlists: playlists ?? this.playlists,
      currentSong: currentSong ?? this.currentSong,
      currentIndex: currentIndex ?? this.currentIndex,
      playing: playing ?? this.playing,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      navIndex: navIndex ?? this.navIndex,
      scanProgress: scanProgress ?? this.scanProgress,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [
        status,
        plan,
        darkMode,
        songs,
        favorites,
        recentIds,
        playlists,
        currentSong,
        currentIndex,
        playing,
        position,
        duration,
        navIndex,
        scanProgress,
        query,
      ];
}
