import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/app/app_cubit.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_scaffold.dart';

class ScanningScreen extends StatelessWidget {
  const ScanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final percent = (state.scanProgress * 100).round();
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Scanning Your Music', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 42),
                  SizedBox.square(
                    dimension: 150,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(value: state.scanProgress, strokeWidth: 8, color: AppTheme.purple),
                        Center(child: Text('$percent%', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  const Text('Please wait while Zingle Play finds songs on your device.', textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
