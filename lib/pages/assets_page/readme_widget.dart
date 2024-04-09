import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/widgets/document_display/document_display_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadmeWidget extends StatelessWidget {
  const ReadmeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorWorkflow>(
      builder: (context, editor, _) {
        return FutureBuilder(
          future: editor.contents.getFileString("README.md"),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final sourceString = snapshot.data ?? "hello";
            final markdown = Markdown(
              selectable: true,
              data: sourceString,
              onTapLink: (text, href, title) async {
                Uri url = Uri.tryParse(href!)!;
                launchUrl(url);
              },
              padding: EdgeInsets.all(24).copyWith(top: 0),
              styleSheet: MarkdownStyleSheet(
                pPadding: EdgeInsets.only(top: 8, bottom: 8),
                a: TextStyle(color: Theme.of(context).colorScheme.primary),
                code: GoogleFonts.robotoMono(),
                h3Padding: EdgeInsets.only(top: 48, bottom: 16),
                h2Padding: EdgeInsets.only(top: 48, bottom: 16),
                // h2: GoogleFonts.bizUDPMincho(fontSize: 24),
                h2: GoogleFonts.inter(fontSize: 24),
                h1Padding: EdgeInsets.only(top: 16, bottom: 16),
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
            );

            return Card(
              elevation: 4,
              shadowColor: Colors.transparent,
              margin: EdgeInsets.only(bottom: 48),
              child: Container(
                height: 200,
                width: double.infinity,
                child: markdown,
              ),
            );
          },
        );
      },
    );
  }
}
