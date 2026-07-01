import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/app_bootstrap.dart';
import 'logic/app/app_cubit.dart';
import 'presentation/screens/app_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final bootstrap = await AppBootstrap.create();
  runApp(ZinglePlayApp(bootstrap: bootstrap));
}

class ZinglePlayApp extends StatelessWidget {
  const ZinglePlayApp({super.key, required this.bootstrap});

  final AppBootstrap bootstrap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppCubit(
        musicRepository: bootstrap.musicRepository,
        audioService: bootstrap.audioService,
        purchaseService: bootstrap.purchaseService,
        storageService: bootstrap.storageService,
      )..restore(),
      child: const AppView(),
    );
  }
}
