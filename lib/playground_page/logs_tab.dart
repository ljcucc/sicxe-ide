import 'package:flutter/material.dart';
import 'package:sicxe/overview_card.dart';

class LogsTab extends StatefulWidget {
  const LogsTab({super.key});

  @override
  State<LogsTab> createState() => _VmLogsTabState();
}

class _VmLogsTabState extends State<LogsTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(8.0),
      child: OverviewCard(
        title: Text("VM Running Logs"),
        expanded: true,
        child: Card(
          elevation: 0,
          shadowColor: Colors.transparent,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text("program counter")),
                DataColumn(label: Text("instruction")),
                DataColumn(label: Text("regA")),
                DataColumn(label: Text("regX")),
                DataColumn(label: Text("regL")),
                DataColumn(label: Text("regSw")),
                DataColumn(label: Text("regB")),
                DataColumn(label: Text("regS")),
                DataColumn(label: Text("regT")),
              ],
              rows: [],
            ),
          ),
        ),
      ),
    );
  }
}
