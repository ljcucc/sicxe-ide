import 'package:flutter/material.dart';

class LargeScreenNavigationRail extends StatelessWidget {
  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const LargeScreenNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final (index, destination) in destinations.indexed) ...[
            ...[
              if (index == selectedIndex)
                IconButton.filledTonal(
                  padding: EdgeInsets.all(16),
                  onPressed: () => onDestinationSelected(index),
                  icon: destination.icon,
                  iconSize: 24,
                ),
              if (index != selectedIndex)
                IconButton(
                  padding: EdgeInsets.all(16),
                  onPressed: () => onDestinationSelected(index),
                  icon: destination.icon,
                  iconSize: 24,
                ),
            ],
            if (index != destinations.length) SizedBox(height: 12)
          ],
        ],
      ),
    );
  }
}
