import 'package:flutter/material.dart';

class FileNewButton extends StatelessWidget {
  const FileNewButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Icon(Icons.insert_drive_file_outlined),
      ),
    );
  }
}
