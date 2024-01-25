import 'package:flutter/material.dart';
import 'package:sicxe/overview_card.dart';

class AssemblerBlocklyTab extends StatefulWidget {
  const AssemblerBlocklyTab({super.key});

  @override
  State<AssemblerBlocklyTab> createState() => _AssemblerBlocklyTabState();
}

class _AssemblerBlocklyTabState extends State<AssemblerBlocklyTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(8.0),
      child: OverviewCard(
        title: Text("Blockly Editor"),
        expanded: true,
        child: Card(
          elevation: 0,
          shadowColor: Colors.transparent,
          child: ReorderableListView(
            children: [],
            onReorder: (oldIndex, newIndex) {},
          ),
        ),
      ),
    );
  }
}
