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

  // Control sections & program linking
  CSECT,
  EXDEF,
  EXREF,
  LTORG
}

class LlbAssemblerContext {
  final String text;
  Map<String, int> symtab = {};
  List<ObjectProgramRecord> records = [];

  /// all parsed object will store here
  List<LineParserContext> parserContexts = [];

  /// The starting location
  int startingLoc = 0;
  int programLenth = 0;
  int locctr = 0;

  LlbAssemblerContext({required this.text});

  /// reset all data structure into initial state.
  init() {
    parserContexts = [];
    records = [];
    symtab = {};
    startingLoc = 0;
    programLenth = 0;
    locctr = 0;
  }

  addParserContext(LineParserContext context) {
    parserContexts.add(context);
  }
}

//TODO: messy implementation, integrate into LineParserBuilder after implement.
class LiteralsContext {
  final LlbAssemblerContext assemblerContext;
  Map<String, int> literals = {};
  Map<String, int> locLiteral = {};

  /// the location of LTORG directive
  int ltorgLoc = -1;

  LiteralsContext({required this.assemblerContext});

  /// Make padding for LTORG, will relocate all parserContext below LTORG
  locctrRelocation() {
    if (ltorgLoc < 0) {
      ltorgLoc = assemblerContext.locctr;
    }

    for (var parserContext in assemblerContext.parserContexts) {
      if (parserContext.locctr <= ltorgLoc) continue;

      print("lit: ${parserContext.line}, padding by ltorg");
      parserContext.locctr += _totalLocLength;
    }

    assemblerContext.locctr += _totalLocLength;
  }

  /// Generate symtab location for all literals
  generateLiteral() {
    print("lit: pass1Ending");
    int loc = ltorgLoc;
    for (var symbolName in literals.keys) {
      print("generating symbol for $symbolName");

      if (symbolName[1] == "*") {
        final literalName = symbolName.substring(1);
        if (!locLiteral.containsKey(literalName))
          throw "location literal not found: $symbolName";
        assemblerContext.symtab[symbolName] = locLiteral[literalName] ?? -1;
        continue;
      }

      final length = _calculateLength(symbolName);
      assemblerContext.symtab[symbolName] = loc;
      print("literal loc: $loc");
      loc += length;
    }
  }

  scanLiteral(LineParserContext parserContext) {
    if (parserContext.directiveType == LlbAssemblerDirectiveType.LTORG) {
      ltorgLoc = parserContext.locctr;
      return;
    }
    final literalParser = LineParserLiterals(context: parserContext);
    final operand = LineParserOperand(context: parserContext);

    if (literalParser.isLocLiteralDefine) {
      print("is location literal: ${parserContext.line}");
      locLiteral[operand.toSymbol()] = parserContext.locctr;
      return;
    }

    if (!literalParser.isLiteral) return;
    literals[operand.toSymbol()] = -1;
    print("found literal: ${operand.toSymbol()}");
  }

  int _calculateLength(String stringLiteral) {
    if (stringLiteral[0] == "*") return 0;

    final segments = stringLiteral.substring(1).split("'");
    if (segments[0] == 'C') return segments[1].length;
    if (segments[0] == 'X') return 1;

    return 0;
  }

  int get _totalLocLength {
    int length = 0;

    //TODO: calculate the escape char
    for (final stringLiteral in literals.keys) {
      length += _calculateLength(stringLiteral);
    }

    return length;
  }
}

/// The job of LlbAssembler is just to glue everything together.
///
/// LlbAssembler is a assembler designed by Leland L. Beck
/// in Book "System Software - An Introduction to Systme Programming"
/// which written in the style of OOP
class LlbAssembler {
  LlbAssemblerContext context;

  late LiteralsContext literalsContext;

  LlbAssembler({
    required this.context,
  }) {
    setContext(context);
  }

  setContext(LlbAssemblerContext context) {
    literalsContext = LiteralsContext(assemblerContext: context);
  }

  /// pass1 will parse each line, and store it for forward referenced.
  pass1() {
    context.init();

    List<String> lines = context.text.split("\n");

    for (final (index, line) in lines.indexed) {
      if (line.trim().isEmpty || line[0] == ".") continue;

      final parserContext = LineParser(
        context: LineParserContext(line: line, locctr: context.locctr),
      ).context;

      final operand = LineParserOperand(context: parserContext);

      // detect startingLoc
      if (context.locctr == 0 &&
          parserContext.directiveType == LlbAssemblerDirectiveType.START) {
        context.locctr = operand.toInt();
        context.startingLoc = context.locctr;
      }

      // symbol scannign
      if (parserContext.colLabel.isNotEmpty) {
        if (context.symtab.containsKey(parserContext.colLabel)) {
          throw "duplicate symbol: ${parserContext.colLabel}";
        }

        context.symtab[parserContext.colLabel] = context.locctr;
      }

      // locctr calculation
      context.locctr += LineParserCodeLength(context: parserContext).objLength;
      context.addParserContext(parserContext);

      // scan for exists literal and LTORG directive
      literalsContext.scanLiteral(parserContext);
    }

    // literialContext will relocate all locctr to parsedLine from LTORG directive
    literalsContext.locctrRelocation();

    // store the program length and reset locctr for object program generate
    context.programLenth = context.locctr - context.startingLoc;

    // generate symbol location in symtab.
    // not the same implementation in book, but less code changes
    literalsContext.generateLiteral();
  }

  pass2() {
    int baseLoc = 0;

    final buildContext = ObjectCodeBuilderContext(
      symtab: context.symtab,
      programLenth: context.programLenth,
      literals: literalsContext,
    );

    for (var parserContext in context.parserContexts) {
      final operand = LineParserOperand(context: parserContext);

      // scan for BASE and set baseLoc
      if (parserContext.directiveType == LlbAssemblerDirectiveType.BASE) {
        baseLoc = context.symtab[operand.toSymbol()] ?? 0;
      }

      parserContext.baseLoc = baseLoc;

      final builder = ObjectCodeBuilder.resolve(parserContext);
      if (builder == null) continue;
      builder.build(buildContext);
    }

    /// necessary process for pass2
    if (literalsContext.ltorgLoc < 0) {
      ObjectCodeBuilderLiteral(
        parserContext: context.parserContexts.last,
      ).build(buildContext);
    }

    /// end record
    buildContext.ending(context.startingLoc);
    context.records = buildContext.records;
  }
}
