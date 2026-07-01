import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../data/models/local_song.dart';
import '../theme/app_theme.dart';

class SongArt extends StatelessWidget {
  const SongArt({super.key, required this.song, this.size = 56, this.radius = 8});

  final LocalSong song;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: QueryArtworkWidget(
        id: song.id,
        type: ArtworkType.AUDIO,
        artworkHeight: size,
        artworkWidth: size,
        artworkFit: BoxFit.cover,
        nullArtworkWidget: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.purple, Color(0xFFFF9F1C)]),
          ),
          child: const Icon(Icons.music_note, color: Colors.white),
        ),
      ),
    );
  }
}
