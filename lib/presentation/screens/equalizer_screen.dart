import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({super.key});

  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {
  final values = <double>[0, 0, 2, -1, 1];
  final bands = const ['60Hz', '230Hz', '910Hz', '3.6kHz', '14kHz'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Equalizer')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Wrap(
            spacing: 8,
            children: const [
              Chip(label: Text('Normal'), backgroundColor: AppTheme.purple, labelStyle: TextStyle(color: Colors.white)),
              Chip(label: Text('Rock')),
              Chip(label: Text('Pop')),
              Chip(label: Text('Bass Boost')),
              Chip(label: Text('Classical')),
              Chip(label: Text('Jazz')),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 280,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(values.length, (index) {
                return Column(children: [
                  Text(bands[index], style: Theme.of(context).textTheme.labelSmall),
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Slider(
                        min: -6,
                        max: 6,
                        divisions: 12,
                        value: values[index],
                        onChanged: (value) => setState(() => values[index] = value),
                      ),
                    ),
                  ),
                ]);
              }),
            ),
          ),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: _Knob(label: 'Bass Boost')),
            const SizedBox(width: 16),
            Expanded(child: _Knob(label: 'Visualizer')),
          ]),
        ],
      ),
    );
  }
}

class _Knob extends StatelessWidget {
  const _Knob({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox.square(
        dimension: 84,
        child: CircularProgressIndicator(value: .68, strokeWidth: 7, color: AppTheme.purple, backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest),
      ),
      const SizedBox(height: 10),
      Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    ]);
  }
}
