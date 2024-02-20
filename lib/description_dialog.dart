import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DescriptionDialog extends StatelessWidget {
  final String? title;
  final String markdown;

  const DescriptionDialog({super.key, this.title, required this.markdown});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: textTheme.headlineLarge,
          ),
          const SizedBox(height: 32),
        ],
        Expanded(
          child: Markdown(
            selectable: true,
            data: markdown,
            onTapLink: (text, href, title) async {
              Uri url = Uri.tryParse(href!)!;
              launchUrl(url);
            },
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
