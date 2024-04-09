import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/navigation_page_provider.dart';
import 'package:sicxe/pages/assets_page/readme_widget.dart';
import 'package:sicxe/pages/editor_page/editor_tab_controller.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';

class AssetsPage extends StatelessWidget {
  const AssetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorWorkflow>(builder: (context, editor, _) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: editor.contents.getFileList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Container();
                  }

                  final fileList = snapshot.data ?? [];
                  final haveReadme = fileList.contains("README.md");

                  if (!haveReadme) {
                    return Container();
                  }

                  return ReadmeWidget();
                },
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  "Assets",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              FutureBuilder(
                  future: editor.contents.getFileList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final fileList = snapshot.data ?? [];
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final key in fileList)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () async {
                                final etc = Provider.of<EditorTabController>(
                                    context,
                                    listen: false);
                                final navigationPageProvider =
                                    Provider.of<NavigationPageProvider>(context,
                                        listen: false);
                                navigationPageProvider.id =
                                    NavigationPageId.Editor;
                                etc.openTab(key);
                              },
                              child: Container(
                                width: 170,
                                padding: EdgeInsets.zero,
                                child: ListTile(
                                  leading: Icon(
                                    switch (key.split(".").last) {
                                      "vobj" => Icons.view_in_ar_outlined,
                                      "asm" => Icons.description_outlined,
                                      String() => Icons.description_outlined,
                                    },
                                  ),
                                  title: Text(
                                    key,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      );
    });
  }
}
