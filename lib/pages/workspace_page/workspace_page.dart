import 'package:flutter/material.dart';
import 'package:sicxe/pages/workspace_page/compact_layout.dart';
import 'package:sicxe/pages/workspace_page/large_layout.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final compactLayout =
        MediaQuery.of(context).orientation == Orientation.portrait &&
            MediaQuery.of(context).size.width < 700;

    Widget body = (compactLayout) ? CompactLayout() : LargeLayout();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
            stops: const [0.6, 1],
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
            ],
          ),
        ),
        child: body,
      ),
    );
  }
}
