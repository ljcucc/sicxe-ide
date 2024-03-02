import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  final Widget title;
  final Widget? child;
  final VoidCallback? onInfoOpen;

  final bool expanded;

  const OverviewCard({
    super.key,
    required this.title,
    this.child,
    this.expanded = false,
    this.onInfoOpen,
  });

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 8),
      child: child,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          border:
              Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8)
              .copyWith(top: 0, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: title,
                contentPadding: EdgeInsets.only(left: 16),
                trailing: onInfoOpen == null
                    ? null
                    : IconButton(
                        onPressed: onInfoOpen,
                        icon: Icon(Icons.help_outline_rounded),
                      ),
              ),
              if (!expanded) SizedBox(height: 8),
              if (expanded)
                Expanded(
                  child: body,
                ),
              if (!expanded) body
            ],
          ),
        ),
      ),
    );
  }
}
