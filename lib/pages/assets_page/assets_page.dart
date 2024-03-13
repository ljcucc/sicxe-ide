import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final key in editor.contents.keys)
                    Material(
                      borderRadius: BorderRadius.circular(12),
                      shadowColor: Colors.transparent,
                      surfaceTintColor:
                          Theme.of(context).colorScheme.surfaceTint,
                      elevation: 2,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {},
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
              ),
            ],
          ),
        ),
      );
    });
  }
}
