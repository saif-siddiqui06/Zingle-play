import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: dark
                ? const [Color(0xFF070912), Color(0xFF151027), Color(0xFF070912)]
                : const [Color(0xFFFFFFFF), Color(0xFFF4ECFF), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}
