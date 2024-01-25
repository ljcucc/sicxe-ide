import 'package:flutter/material.dart';
import 'package:sicxe/document_page/documents.dart';

class DocumentPage extends StatelessWidget {
  const DocumentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Documents"),
      ),
      body: ListView(children: [
        for (final title in documents.keys)
          ListTile(
            title: Text(title),
            onTap: () {},
          ),
      ]),
    );
  }
}
