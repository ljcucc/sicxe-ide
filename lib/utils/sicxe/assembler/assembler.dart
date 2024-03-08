import 'package:sicxe/utils/sicxe/assembler/object_code/object_code_builder.dart';
import 'package:sicxe/utils/sicxe/assembler/object_program_record.dart';
import 'package:sicxe/utils/sicxe/assembler/parser.dart';

typedef AssembleFunction = String Function(int operand);

// Map<OpCodes, AssembleFunction>

/// The directive type of a line or statement.
enum LlbAssemblerDirectiveType {
  START,
  END,
  RESB,
  RESW,
  WORD,
  BYTE,
  BASE,
  NOBASE,
  IS_NOT_DIRECTIVE,
}

/// The job of LlbAssembler is just to glue everything together.
///
/// LlbAssembler is a assembler designed by Leland L. Beck
/// in Book "System Software - An Introduction to Systme Programming"
/// which written in the style of OOP
class LlbAssembler {
  final String text;
  Map<String, int> symtab = {};
  List<ObjectProgramRecord> records = [];

  /// all parsed object will store here
  List<LineParserContext> parserContexts = [];

  /// The starting location
  int startingLoc = 0;

  int programLenth = 0;

  LlbAssembler({required this.text});

  /// reset all data structure into initial state.
  init() {
    parserContexts = [];
    records = [];
    symtab = {};
    startingLoc = 0;
    programLenth = 0;
  }

  /// pass1 will parse each line, and store it for forward referenced.
  pass1() {
    init();

    // current location
    int locctr = 0;

    List<String> lines = text.split("\n");

    for (final (index, line) in lines.indexed) {
      if (line.trim().isEmpty || line[0] == ".") continue;

      final context = LineParser(
        context: LineParserContext(line: line, locctr: locctr),
      ).context;

      final operand = LineParserOperand(context: context);

      if (index == 0 &&
          context.directiveType == LlbAssemblerDirectiveType.START) {
        locctr = operand.toInt();
        startingLoc = locctr;
      }

      // symbol detection
      if (context.colLabel.isNotEmpty) {
        if (symtab.containsKey(context.colLabel)) {
          throw "duplicate symbol: ${context.colLabel}";
        }

        symtab[context.colLabel] = locctr;
      }

      locctr += LineParserCodeLength(context: context).objLength;
      parserContexts.add(context);
    }

    // store the program length and reset locctr for object program generate
    programLenth = locctr - startingLoc;
  }

  pass2() {
    int baseLoc = 0;

    final buildContext = ObjectCodeBuilderContext(
      symtab: symtab,
      programLenth: programLenth,
    );

    for (var parserContext in parserContexts) {
      final operand = LineParserOperand(context: parserContext);
      if (parserContext.directiveType == LlbAssemblerDirectiveType.BASE) {
        baseLoc = symtab[operand.toSymbol()] ?? 0;
      }

      parserContext.baseLoc = baseLoc;
      final builder = ObjectCodeBuilder.resolve(parserContext);
      if (builder == null) continue;
      builder.build(buildContext);
    }

    buildContext.ending(startingLoc);
    records = buildContext.records;
  }
}
