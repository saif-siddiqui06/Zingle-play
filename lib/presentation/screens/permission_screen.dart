import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/app/app_cubit.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/zingle_logo.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            const Spacer(),
            const ZingleLogo(size: 118),
            const SizedBox(height: 28),
            Text('Music Access', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            Text(
              'Music access permission is required to scan songs stored on your device.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 34),
            FilledButton(
              onPressed: () => context.read<AppCubit>().requestAndScan(),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52), backgroundColor: AppTheme.purple),
              child: const Text('Allow Access'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.read<AppCubit>().requestAndScan(),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              child: const Text('Retry'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
