import 'package:flutter/material.dart';
import 'package:sicxe/pages/settings_page/settings_page.dart';

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
    final iconsRail = Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          iconsRail,
          IconButton(
            padding: EdgeInsets.all(16),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ),
            ),
            icon: Icon(Icons.settings),
            iconSize: 24,
          ),
        ],
      ),
    );
  }
}
