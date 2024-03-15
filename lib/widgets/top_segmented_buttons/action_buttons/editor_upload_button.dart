import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/utils/workflow/emulator_workflow.dart';

class EditorUploadButton extends StatelessWidget {
  const EditorUploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorWorkflow>(builder: (context, editor, _) {
      return Consumer<EmulatorWorkflow>(builder: (context, emulator, _) {
        return InkWell(
          onTap: () {
            editor.upload(emulator);
          },
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Icon(
              Icons.file_upload_outlined,
            ),
          ),
        );
      });
    });
  }
}
