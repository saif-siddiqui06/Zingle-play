import 'package:equatable/equatable.dart';

class Playlist extends Equatable {
  const Playlist({
    required this.id,
    required this.name,
    required this.songIds,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final List<int> songIds;
  final DateTime updatedAt;

  factory Playlist.fromMap(Map<dynamic, dynamic> map) {
    return Playlist(
      id: map['id'] as String,
      name: map['name'] as String,
      songIds: List<int>.from(map['songIds'] as List),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, Object> toMap() => {
        'id': id,
        'name': name,
        'songIds': songIds,
        'updatedAt': updatedAt.toIso8601String(),
      };

  Playlist copyWith({String? name, List<int>? songIds}) {
    return Playlist(
      id: id,
      name: name ?? this.name,
      songIds: songIds ?? this.songIds,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, name, songIds, updatedAt];
}
