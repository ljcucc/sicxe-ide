import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sicxe/vm/vm.dart';

import 'package:google_fonts/google_fonts.dart';

class MemoryInspector extends StatefulWidget {
  final Memory mem;

  const MemoryInspector({
    super.key,
    required this.mem,
  });

  @override
  State<MemoryInspector> createState() => _MemoryInspectorState();
}

class _MemoryInspectorState extends State<MemoryInspector> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      child: Column(
        children: [
          const ListTile(
            title: Text("Memory overview"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0).copyWith(top: 0),
              child: Card(
                elevation: 8,
                shadowColor: Colors.transparent,
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  addAutomaticKeepAlives: true,
                  itemCount: 0xFF + 1,
                  itemBuilder: (context, index) {
                    return Text(
                      "${(index * 8).toRadixString(16).padLeft(5, "0").toUpperCase()}  ${widget.mem.getRange(index * 8, index * 8 + 8).map((e) => e.toRadixString(16).padLeft(2, '0')).join(" ")}",
                      style: GoogleFonts.spaceMono(),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
