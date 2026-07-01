import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/app/app_cubit.dart';
import '../theme/app_theme.dart';
import 'permission_screen.dart';
import 'scanning_screen.dart';
import 'shell_screen.dart';
import 'splash_screen.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Zingle Play',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
          home: switch (state.status) {
            AppStatus.splash => const SplashScreen(),
            AppStatus.permission => const PermissionScreen(),
            AppStatus.scanning => const ScanningScreen(),
            AppStatus.ready => const ShellScreen(),
          },
        );
      },
    );
  }
}
