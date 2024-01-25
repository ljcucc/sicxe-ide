import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionDialog extends StatelessWidget {
  final String title;
  final String markdown;

  const DescriptionDialog(
      {super.key, required this.title, required this.markdown});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          title,
          style: textTheme.headlineLarge,
        ),
        SizedBox(height: 32),
        Expanded(
          child: Markdown(
            data: markdown,
            styleSheet: MarkdownStyleSheet(
              code: GoogleFonts.robotoMono(),
              h3Padding: EdgeInsets.only(top: 48, bottom: 16),
              h2Padding: EdgeInsets.only(top: 48, bottom: 16),
              h1Padding: EdgeInsets.only(top: 48, bottom: 16),
            ),
          ),
        ),
      ],
    );
  }
}
