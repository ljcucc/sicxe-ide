import 'package:flutter/material.dart';

class LogsTab extends StatefulWidget {
  const LogsTab({super.key});

  @override
  State<LogsTab> createState() => _VmLogsTabState();
}

class _VmLogsTabState extends State<LogsTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}
