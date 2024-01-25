import 'package:flutter/material.dart';
import 'package:sicxe/documents.dart';

class OverviewCard extends StatelessWidget {
  final Widget title;
  final Widget? description;
  final Widget? child;

  final bool expanded;

  const OverviewCard({
    super.key,
    required this.title,
    this.child,
    this.expanded = false,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 8),
      child: child,
    );
    return Card(
      shadowColor: Colors.transparent,
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
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          padding: const EdgeInsets.all(24.0),
                          constraints: BoxConstraints(maxWidth: 700),
                          child: description,
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.info_outline_rounded),
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
    );
  }
}
