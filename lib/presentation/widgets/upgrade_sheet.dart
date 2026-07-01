import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/app_plan.dart';
import '../../logic/app/app_cubit.dart';
import '../theme/app_theme.dart';

Future<void> showUpgradeSheet(BuildContext context, {String feature = 'more features'}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.workspace_premium, color: AppTheme.gold, size: 42),
          const SizedBox(height: 8),
          Text('Unlock ${feature == 'more features' ? 'More Features' : feature}', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 18),
          _PlanButton(plan: AppPlan.basic, title: 'Basic Rs49 Lifetime', subtitle: 'Next, previous, background controls, favorites, playlists, dark theme'),
          const SizedBox(height: 10),
          _PlanButton(plan: AppPlan.premium, title: 'Premium Rs99 Lifetime', subtitle: 'Everything in Basic plus equalizer, sleep timer, themes, icons, visualizer'),
          const SizedBox(height: 10),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Later')),
        ],
      ),
    ),
  );
}

class _PlanButton extends StatelessWidget {
  const _PlanButton({required this.plan, required this.title, required this.subtitle});

  final AppPlan plan;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        context.read<AppCubit>().upgrade(plan);
        Navigator.pop(context);
      },
      style: FilledButton.styleFrom(alignment: Alignment.centerLeft, padding: const EdgeInsets.all(16), backgroundColor: AppTheme.purple),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: .84))),
        ],
      ),
    );
  }
}
