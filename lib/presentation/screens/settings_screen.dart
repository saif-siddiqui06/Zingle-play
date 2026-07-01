import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/app/app_cubit.dart';
import '../theme/app_theme.dart';
import '../widgets/upgrade_sheet.dart';
import 'equalizer_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                leading: const Icon(Icons.verified, color: AppTheme.purple),
                title: Text('Current Plan: ${state.plan.label}'),
                subtitle: const Text('Lifetime Access. No Ads Forever.'),
                trailing: TextButton(onPressed: () => showUpgradeSheet(context), child: const Text('Upgrade')),
              ),
              const SizedBox(height: 14),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode_outlined),
                title: const Text('Appearance'),
                subtitle: const Text('Dark theme is included in Basic and Premium.'),
                value: state.darkMode,
                onChanged: state.isPaid ? context.read<AppCubit>().toggleTheme : (_) => showUpgradeSheet(context, feature: 'Dark Theme'),
              ),
              _SettingsTile(icon: Icons.play_arrow, title: 'Playback', onTap: () {}),
              _SettingsTile(icon: Icons.equalizer, title: 'Equalizer', onTap: () => state.isPremium ? Navigator.push(context, MaterialPageRoute(builder: (_) => const EqualizerScreen())) : showUpgradeSheet(context, feature: 'Equalizer')),
              _SettingsTile(icon: Icons.bedtime_outlined, title: 'Sleep Timer', onTap: () => state.isPremium ? _showSleepTimer(context) : showUpgradeSheet(context, feature: 'Sleep Timer')),
              _SettingsTile(icon: Icons.storage, title: 'Storage', subtitle: '${state.songs.length} songs cached locally', onTap: () {}),
              _SettingsTile(icon: Icons.restore, title: 'Restore Purchases', onTap: context.read<AppCubit>().restorePurchases),
              _SettingsTile(icon: Icons.privacy_tip_outlined, title: 'Privacy Policy', subtitle: 'Offline-first. Your local library stays on device.', onTap: () {}),
              _SettingsTile(icon: Icons.info_outline, title: 'About', subtitle: 'Zingle Play by Pixel Pi', onTap: () {}),
            ],
          ),
        );
      },
    );
  }

  void _showSleepTimer(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: const [
          ListTile(title: Text('15 Minutes')),
          ListTile(title: Text('30 Minutes')),
          ListTile(title: Text('45 Minutes')),
          ListTile(title: Text('60 Minutes')),
          ListTile(title: Text('90 Minutes')),
          ListTile(title: Text('Stop Playback')),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.title, this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
