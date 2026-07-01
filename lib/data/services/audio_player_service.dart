import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

import '../models/local_song.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  Stream<bool> get playingStream => _player.playingStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  Future<void> configure() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  Future<void> playSong(LocalSong song) async {
    await _player.setFilePath(song.data);
    await _player.play();
  }

  Future<void> toggle() => _player.playing ? _player.pause() : _player.play();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> stop() => _player.stop();
  Future<void> dispose() => _player.dispose();
}
