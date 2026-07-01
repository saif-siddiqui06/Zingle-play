import 'package:equatable/equatable.dart';
import 'package:on_audio_query/on_audio_query.dart' as query;

class LocalSong extends Equatable {
  const LocalSong({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.durationMs,
    required this.data,
    required this.dateAdded,
  });

  final int id;
  final String title;
  final String artist;
  final String album;
  final int durationMs;
  final String data;
  final int dateAdded;

  Duration get duration => Duration(milliseconds: durationMs);

  factory LocalSong.fromQuery(query.SongModel song) {
    return LocalSong(
      id: song.id,
      title: song.title,
      artist: song.artist?.trim().isNotEmpty == true ? song.artist! : 'Unknown Artist',
      album: song.album?.trim().isNotEmpty == true ? song.album! : 'Unknown Album',
      durationMs: song.duration ?? 0,
      data: song.data,
      dateAdded: song.dateAdded ?? 0,
    );
  }

  factory LocalSong.fromMap(Map<dynamic, dynamic> map) {
    return LocalSong(
      id: map['id'] as int,
      title: map['title'] as String,
      artist: map['artist'] as String,
      album: map['album'] as String,
      durationMs: map['durationMs'] as int,
      data: map['data'] as String,
      dateAdded: map['dateAdded'] as int,
    );
  }

  Map<String, Object> toMap() => {
        'id': id,
        'title': title,
        'artist': artist,
        'album': album,
        'durationMs': durationMs,
        'data': data,
        'dateAdded': dateAdded,
      };

  @override
  List<Object?> get props => [id, title, artist, album, durationMs, data, dateAdded];
}
