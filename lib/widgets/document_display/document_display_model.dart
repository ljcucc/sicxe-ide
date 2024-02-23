import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DocumentDisplayModel extends ChangeNotifier {
  String _markdown = "";

  String get markdown {
    return _markdown;
  }

  /// update document display model of document_display_widget by document_Display_provider
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
