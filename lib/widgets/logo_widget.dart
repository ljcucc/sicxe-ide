import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoWidget extends StatelessWidget {
  final bool compact;
  const LogoWidget({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final SICXE = [
      TextSpan(
        text: "SIC",
        style: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w600,
          fontSize: compact ? 24 : 32,
        ),
      ),
      TextSpan(
        text: "/XE",
        style: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
          fontSize: compact ? 24 : 32,
        ),
      ),
    ];

    final playground = TextSpan(
      text: "Playground",
      style: GoogleFonts.inter(fontSize: compact ? 8 : 12),
    );

    if (compact) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text.rich(TextSpan(children: SICXE)),
          Text.rich(playground),
        ],
      );
    }

    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          ...SICXE,
          TextSpan(
            text: "  ",
            style: GoogleFonts.inter(fontSize: 12),
          ),
          playground
        ],
      ),
    );
  }
}
