import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/zingle_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: .86, end: 1),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) => Opacity(
            opacity: scale.clamp(.0, 1.0),
            child: Transform.scale(scale: scale, child: child),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('PIXEL PI', style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 4, color: AppTheme.purple)),
              const SizedBox(height: 28),
              const ZingleLogo(size: 132),
              const SizedBox(height: 28),
              Text('Zingle Play', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Text('Pay Once. Listen Forever.', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.purple)),
              const SizedBox(height: 8),
              Text('Ad-Free Offline Music Player', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
