import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sicxe/widgets/document_display/document_display_widget.dart';

class HomePageCompact extends StatelessWidget {
  const HomePageCompact({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
        ),
        Expanded(
          child: DocumentDisplayWidget(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.all(24),
          ),
        ),
      ],
    );
  }
}
