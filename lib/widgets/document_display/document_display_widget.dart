import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/widgets/document_display/document_display_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentDisplayWidget extends StatelessWidget {
  final EdgeInsets? padding;
  final Color? backgroundColor;

  const DocumentDisplayWidget({
    super.key,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentDisplayProvider>(builder: (context, ddm, child) {
      return SafeArea(
        minimum: EdgeInsets.only(top: 0, bottom: 16, right: 8),
        child: Card(
          shadowColor: Colors.transparent,
          color: backgroundColor,
          elevation: 0,
          child: Column(
            children: [
              Expanded(
                child: Markdown(
                  selectable: true,
                  data: ddm.markdown,
                  onTapLink: (text, href, title) async {
                    Uri url = Uri.tryParse(href!)!;
                    launchUrl(url);
                  },
                  padding: padding ?? EdgeInsets.all(24).copyWith(top: 0),
                  styleSheet: MarkdownStyleSheet(
                    pPadding: EdgeInsets.only(top: 8, bottom: 8),
                    a: TextStyle(color: Theme.of(context).colorScheme.primary),
                    code: GoogleFonts.robotoMono(),
                    h3Padding: EdgeInsets.only(top: 48, bottom: 16),
                    h2Padding: EdgeInsets.only(top: 48, bottom: 16),
                    // h2: GoogleFonts.bizUDPMincho(fontSize: 24),
                    h2: GoogleFonts.inter(fontSize: 24),
                    h1Padding: EdgeInsets.only(top: 0, bottom: 16),
                    h1: GoogleFonts.playfairDisplay(fontSize: 48),
                    // h1: GoogleFonts.inter(fontSize: 48),
                    blockquotePadding: EdgeInsets.all(16),
                    blockquoteDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context)
                          .colorScheme
                          .tertiaryContainer
                          .withOpacity(.35),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
