import 'package:flutter/material.dart';

class ControlBarView extends StatelessWidget {
  const ControlBarView({
    super.key,
    required this.onStepThru,
    required this.onPlay,
    required this.onSpeedup,
  });

  final Future<void> Function() onStepThru;
  final Future<void> Function() onPlay;
  final Future<void> Function() onSpeedup;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Theme.of(context).colorScheme.inverseSurface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              color: Theme.of(context).colorScheme.onInverseSurface,
              onPressed: onStepThru,
              tooltip: 'Step',
              icon: const Icon(Icons.airline_stops_rounded),
            ),
            SizedBox(width: 16),
            IconButton(
              color: Theme.of(context).colorScheme.onInverseSurface,
              onPressed: onPlay,
              tooltip: 'Continious',
              icon: const Icon(Icons.play_arrow_rounded),
            ),
            SizedBox(width: 16),
            IconButton(
              color: Theme.of(context).colorScheme.onInverseSurface,
              onPressed: onSpeedup,
              tooltip: 'Speed up',
              icon: const Icon(Icons.fast_forward_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
