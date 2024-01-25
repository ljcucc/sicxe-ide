import 'package:flutter/material.dart';
import 'package:sicxe/description_dialog.dart';
import 'package:sicxe/documents.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(48.0),
        child: FutureBuilder(
          future: getDocument("README.md"),
          builder: (context, snapshot) {
            return DescriptionDialog(
              title: "Playground",
              markdown: snapshot.data ?? "",
            );
          },
        ),
      ),
    );
  }
}
