import 'package:flutter/material.dart';

class TopSegmentedButtonsGroup extends StatelessWidget {
  final List<Widget> children;

  const TopSegmentedButtonsGroup({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (index, widget) in children.indexed) ...[
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            child: widget,
          ),
          if (index < children.length - 1) const SizedBox(width: 16),
        ]
      ],
    );
  }
}
