import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BinaryBarView extends StatelessWidget {
  final String binary;

  const BinaryBarView({super.key, required this.binary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            int.tryParse(binary, radix: 2)
                    ?.toRadixString(16)
                    .padLeft((binary.length / 4).round(), "0") ??
                "0",
            style: GoogleFonts.robotoMono(),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < binary.length; i++) ...[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: binary[i] == '0'
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ),
                SizedBox(width: i % 4 == 3 ? 8 : 2),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
