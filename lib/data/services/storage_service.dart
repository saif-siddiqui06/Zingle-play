import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_plan.dart';
import '../models/local_song.dart';
import '../models/playlist.dart';

class StorageService {
  static const userBox = 'user_box';
  static const songsBox = 'songs_box';
  static const favoritesBox = 'favorites_box';
  static const playlistsBox = 'playlists_box';
  static const recentBox = 'recent_box';
  static const settingsBox = 'settings_box';

  late final SharedPreferences _prefs;
  late final Box _user;
  late final Box _songs;
  late final Box _favorites;
  late final Box _playlists;
  late final Box _recent;
  late final Box _settings;

  Future<void> open() async {
    _prefs = await SharedPreferences.getInstance();
    _user = await Hive.openBox(userBox);
    _songs = await Hive.openBox(songsBox);
    _favorites = await Hive.openBox(favoritesBox);
    _playlists = await Hive.openBox(playlistsBox);
    _recent = await Hive.openBox(recentBox);
    _settings = await Hive.openBox(settingsBox);
  }

  AppPlan get plan => AppPlan.fromName(_user.get('plan') as String?);
  Future<void> savePlan(AppPlan plan) => _user.put('plan', plan.name);

  bool get darkMode => _prefs.getBool('darkMode') ?? (_settings.get('darkMode') as bool? ?? false);
  Future<void> saveDarkMode(bool enabled) async {
    await _prefs.setBool('darkMode', enabled);
    await _settings.put('darkMode', enabled);
  }

  List<LocalSong> loadSongs() {
    return _songs.values
        .whereType<Map>()
        .map(LocalSong.fromMap)
        .toList()
      ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
  }

  Future<void> cacheSongs(List<LocalSong> songs) async {
    await _songs.clear();
    await _songs.putAll({for (final song in songs) song.id: song.toMap()});
  }

  Set<int> loadFavorites() => _favorites.keys.whereType<int>().toSet();
  Future<void> setFavorite(int songId, bool favorite) {
    return favorite ? _favorites.put(songId, true) : _favorites.delete(songId);
  }

  List<int> loadRecentIds() => _recent.values.whereType<int>().toList();
  Future<void> addRecent(int songId) async {
    final next = [songId, ...loadRecentIds().where((id) => id != songId)].take(30).toList();
    await _recent.clear();
    await _recent.addAll(next);
  }

  List<Playlist> loadPlaylists() {
    return _playlists.values.whereType<Map>().map(Playlist.fromMap).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> savePlaylist(Playlist playlist) => _playlists.put(playlist.id, playlist.toMap());
  Future<void> deletePlaylist(String id) => _playlists.delete(id);
}
