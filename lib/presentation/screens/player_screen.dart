import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/local_song.dart';
import '../../logic/app/app_cubit.dart';
import '../theme/app_theme.dart';
import '../widgets/song_art.dart';
import '../widgets/upgrade_sheet.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, required this.song});
  final LocalSong song;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<AppCubit>().play(widget.song));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      final song = state.currentSong ?? widget.song;
      final maxSeconds = state.duration.inSeconds <= 0 ? song.duration.inSeconds.toDouble().clamp(1, double.infinity).toDouble() : state.duration.inSeconds.toDouble();
      final currentSeconds = state.position.inSeconds.toDouble().clamp(0, maxSeconds).toDouble();
      return Scaffold(
        appBar: AppBar(
          title: const Text('Playing From Top Hits'),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Hero(
                tag: 'art-${song.id}',
                child: SongArt(song: song, size: MediaQuery.sizeOf(context).width * .78, radius: 16),
              ),
              const SizedBox(height: 28),
              Text(song.title, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text(song.artist, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 24),
              Slider(
                value: currentSeconds,
                max: maxSeconds,
                onChanged: (value) => context.read<AppCubit>().seek(Duration(seconds: value.round())),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(_format(state.position)),
                Text(_format(state.duration == Duration.zero ? song.duration : state.duration)),
              ]),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.shuffle)),
                  IconButton(
                    iconSize: 36,
                    onPressed: () async {
                      if (!await context.read<AppCubit>().previous() && context.mounted) {
                        showUpgradeSheet(context, feature: 'Previous');
                      }
                    },
                    icon: Icon(state.isPaid ? Icons.skip_previous : Icons.lock_outline),
                  ),
                  FilledButton(
                    onPressed: context.read<AppCubit>().togglePlay,
                    style: FilledButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(22), backgroundColor: AppTheme.purple),
                    child: Icon(state.playing ? Icons.pause : Icons.play_arrow, size: 34),
                  ),
                  IconButton(
                    iconSize: 36,
                    onPressed: () async {
                      if (!await context.read<AppCubit>().next() && context.mounted) {
                        showUpgradeSheet(context, feature: 'Next');
                      }
                    },
                    icon: Icon(state.isPaid ? Icons.skip_next : Icons.lock_outline),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.repeat)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Action(icon: state.favorites.contains(song.id) ? Icons.favorite : Icons.favorite_border, label: 'Favorite', onTap: () async {
                    if (!await context.read<AppCubit>().toggleFavorite(song) && context.mounted) showUpgradeSheet(context, feature: 'Favorites');
                  }),
                  _Action(icon: state.isPaid ? Icons.queue_music : Icons.lock_outline, label: 'Queue', onTap: () {
                    if (!state.isPaid) showUpgradeSheet(context, feature: 'Queue');
                  }),
                  _Action(icon: Icons.lyrics_outlined, label: 'Lyrics', onTap: () {}),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    });
  }

  String _format(Duration value) {
    final minutes = value.inMinutes;
    final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(onPressed: onTap, icon: Icon(icon), label: Text(label));
  }
}
