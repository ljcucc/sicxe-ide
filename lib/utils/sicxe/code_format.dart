import 'package:sicxe/utils/sicxe/assembler/parser.dart';

String codeFormat(String code) {
  // final beforeWhitespace = code.split("'");
  // for (final (index, item) in beforeWhitespace.indexed) {
  //   if (index % 2 == 0) continue;

  //   beforeWhitespace[index] =
  //       item.replaceAll(" ", "!!!SUPER_META_WHITESPACE_FOR_FORMATTING!!!");
  // }

  List<String> lines = code.split("\n");

  for (var (index, line) in lines.indexed) {
    if (line.startsWith(".") || line.trim().isEmpty) continue;
    final lineParsed =
        LineParser(context: LineParserContext(line: line, locctr: 0)).context;
    lines[index] = lineParsed.colLabel.trim().padRight(10) +
        lineParsed.colOpcode.trim().padRight(10) +
        lineParsed.colOperand.trim();
  }

  return lines.join("\n");
}
