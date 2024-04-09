import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final Color? backgroundColor;

  const SettingsPage({
    super.key,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundColor ?? Colors.transparent,
      body: Center(
        child: Text("hello"),
      ),
    );
  }
}
