import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/app_plan.dart';
import '../../logic/app/app_cubit.dart';
import '../theme/app_theme.dart';
import '../widgets/song_art.dart';
import '../widgets/upgrade_sheet.dart';
import 'player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final recent = state.recentSongs.isEmpty ? state.songs.take(6).toList() : state.recentSongs.take(6).toList();
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Evening', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                  Text('Pixel Pi presents Zingle Play', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Premium',
                  onPressed: () => showUpgradeSheet(context),
                  icon: const Icon(Icons.workspace_premium, color: AppTheme.gold),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.list(children: [
                _UpgradeBanner(plan: state.plan),
                const SizedBox(height: 22),
                _SectionHeader(title: 'Recently Played', onTap: () => context.read<AppCubit>().setNavIndex(1)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 142,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recent.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final song = recent[index];
                      return SizedBox(
                        width: 112,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(song: song))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SongArt(song: song, size: 96),
                              const SizedBox(height: 6),
                              Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                              Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Text('Quick Access', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _QuickTile(icon: Icons.music_note, label: 'Songs', onTap: () => context.read<AppCubit>().setNavIndex(1)),
                    _QuickTile(icon: Icons.album, label: 'Albums', onTap: () => context.read<AppCubit>().setNavIndex(1)),
                    _QuickTile(icon: Icons.person, label: 'Artists', onTap: () => context.read<AppCubit>().setNavIndex(1)),
                    _QuickTile(icon: Icons.smart_toy_outlined, label: 'AI', onTap: () => showUpgradeSheet(context, feature: 'AI Music')),
                  ],
                ),
                const SizedBox(height: 18),
                _NowPlayingBar(),
              ]),
            ),
          ],
        );
      },
    );
  }
}

class _UpgradeBanner extends StatelessWidget {
  const _UpgradeBanner({required this.plan});
  final AppPlan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(colors: [Color(0xFF3B167D), AppTheme.purple]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('No Ads Forever', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(plan.isPaid ? 'Lifetime Access Active' : 'Pay Once. Listen Forever.', style: TextStyle(color: Colors.white.withValues(alpha: .84))),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: FilledButton.tonal(onPressed: () => context.read<AppCubit>().upgrade(AppPlan.basic), child: const Text('Basic Rs49'))),
            const SizedBox(width: 10),
            Expanded(child: FilledButton(onPressed: () => context.read<AppCubit>().upgrade(AppPlan.premium), child: const Text('Premium Rs99'))),
          ]),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900))),
      TextButton(onPressed: onTap, child: const Text('See All')),
    ]);
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: AppTheme.purple),
          const SizedBox(height: 6),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ]),
      ),
    );
  }
}

class _NowPlayingBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      final song = state.currentSong;
      if (song == null) return const SizedBox.shrink();
      return ListTile(
        contentPadding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        leading: SongArt(song: song),
        title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: IconButton(onPressed: context.read<AppCubit>().togglePlay, icon: Icon(state.playing ? Icons.pause_circle : Icons.play_circle)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(song: song))),
      );
    });
  }
}
