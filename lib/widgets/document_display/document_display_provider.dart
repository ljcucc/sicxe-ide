import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/widgets/document_display/document_display_widget.dart';

class DocumentDisplayProvider extends ChangeNotifier {
  String _markdown = "README.md";

  String get markdown {
    return _markdown;
  }

  /// update document display model of document_display_widget by document_Display_provider
  static openPopup(context, String filename) {
    final ddm = Provider.of<DocumentDisplayProvider>(context);
    ddm.changeMarkdown(filename);

    showBottomSheet(
      context: context,
      builder: (context) {
        return DocumentDisplayWidget();
      },
    );
  }

  /// internal change markdown logic
  Future<void> changeMarkdown(String filename) async {
    _markdown = await _getDocument(filename);
    notifyListeners();
  }

  Future<String> _getDocument(String filename) async {
    String filepath = "docs/$filename";
    if (filename == "README.md") {
      filepath = filename;
    }
    return rootBundle.loadString(filepath);
  }
}
