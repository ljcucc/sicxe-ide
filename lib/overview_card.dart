import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  final Widget title;
  final Widget? child;

  const OverviewCard({
    super.key,
    required this.title,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: ListTile(
          title: title,
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: child,
          ),
        ),
      ),
    );
  }
}
