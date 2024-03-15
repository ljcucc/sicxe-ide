import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberDisplay extends StatelessWidget {
  final String title;
  final String value;

  const NumberDisplay({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(
        children: [
          Center(
            child: Text(
              value,
              style: GoogleFonts.robotoMono(),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 8),
          ),
        ],
      ),
    );
  }
}
