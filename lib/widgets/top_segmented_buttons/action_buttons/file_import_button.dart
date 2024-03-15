import 'package:flutter/material.dart';

class FileImportButton extends StatelessWidget {
  const FileImportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Icon(Icons.upload_file_outlined),
      ),
    );
  }
}
