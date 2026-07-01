import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/local_song.dart';
import '../services/storage_service.dart';

enum SongSort { name, artist, dateAdded }

class MusicRepository {
  MusicRepository(this._storage);

  final StorageService _storage;
  final OnAudioQuery _query = OnAudioQuery();

  Future<bool> requestAccess() async {
    final libraryGranted = await _query.permissionsStatus();
    if (libraryGranted) return true;
    if (await _query.permissionsRequest()) return true;

    final audioStatus = await Permission.audio.request();
    if (audioStatus.isGranted) return true;

    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  Future<List<LocalSong>> scan({SongSort sort = SongSort.name}) async {
    final rawSongs = await _query.querySongs(
      sortType: switch (sort) {
        SongSort.name => SongSort.TITLE,
        SongSort.artist => SongSort.ARTIST,
        SongSort.dateAdded => SongSort.DATE_ADDED,
      },
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    final songs = rawSongs
        .where((song) => (song.duration ?? 0) > 15000)
        .map(LocalSong.fromQuery)
        .toList();
    await _storage.cacheSongs(songs);
    return songs;
  }

  List<LocalSong> cachedSongs() => _storage.loadSongs();
}
