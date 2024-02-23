import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/widgets/document_display/document_display_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentDisplayWidget extends StatelessWidget {
  const DocumentDisplayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Consumer<DocumentDisplayModel>(builder: (context, ddm, child) {
      return Column(
        children: [
          Expanded(
            child: Markdown(
              selectable: true,
              data: ddm.markdown,
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
    });
  }
}
