import 'package:flutter/services.dart';

Future<String> getDocument(String filename) async {
  return rootBundle.loadString("docs/$filename");
}
