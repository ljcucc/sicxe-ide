import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/widgets/document_display/document_display_model.dart';

class DocumentDisplayProvider extends StatefulWidget {
  final Widget child;

  const DocumentDisplayProvider({
    super.key,
    required this.child,
  });

  @override
  State<DocumentDisplayProvider> createState() =>
      _DocumentDisplayProviderState();
}

class _DocumentDisplayProviderState extends State<DocumentDisplayProvider> {
  late DocumentDisplayModel ddm;

  @override
  void initState() {
    super.initState();

    ddm = DocumentDisplayModel();

    ddm.changeMarkdown("README.md");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DocumentDisplayModel>(
      create: (_) => ddm,
      child: widget.child,
    );
  }
}
