import 'package:flutter_test/flutter_test.dart';
import 'package:sicxe/utils/sicxe/assembler/assembler.dart';
import 'package:sicxe/utils/sicxe/assembler/parser.dart';

void main() {
  group("Verify internal function of assembler - pass 1", () {
    test("Basic LineParser and LineParserContext test", () {
      const code = "TEST WORD #3";
      final context = LineParserContext(line: code, locctr: 0);
      final actualValue = LineParser(context: context).context;

      expect(actualValue.colLabel, equals("TEST"));
      expect(actualValue.colOpcode, equals("WORD"));
      expect(actualValue.colOperand, equals("#3"));
    });

    test("LineParserContext directive test", () {
      const code = "TEST WORD #3";
      final context = LineParserContext(line: code, locctr: 0);
      final actualValue = LineParser(context: context).context;

      expect(actualValue.colOpcode, equals("WORD"));
      expect(actualValue.directiveType, equals(LlbAssemblerDirectiveType.WORD));
    });

    test("LineParserOperand constant test", () {
      var context = LineParserContext(line: "TEST WORD #3", locctr: 0);
      LineParser(context: context).context;
      final opernad = LineParserOperand(context: context);

      expect(opernad.toNumberSymbol(), equals(3));
    });

    test("LineParserOperand register test", () {
      var context = LineParserContext(line: "TEST WORD A,B", locctr: 0);
      LineParser(context: context).context;
      final opernad = LineParserOperand(context: context);

      expect(opernad.r1Index, equals(0));
      expect(opernad.r2Index, equals(3));
    });

    test("LineParsercodeLength test", () {
      var context = LineParserContext(line: "TEST RESW 100", locctr: 0);
      LineParser(context: context).context;
      final codeLength = LineParserCodeLength(context: context);

      expect(codeLength.objLength, equals(300));
    });
  });

  group("Verify interanl function of assembler - pass 2", () {});

  test("Example code on the wikipedia (final test for assembler)", () {
    const codeInput = """COPY    START  0
FIRST   STL    RETADR
        LDB   #LENGTH
        BASE   LENGTH
CLOOP  +JSUB   RDREC
        LDA    LENGTH
        COMP  #0
        JEQ    ENDFIL
       +JSUB   WRREC
        J      CLOOP
ENDFIL  LDA    EOF
        STA    BUFFER
        LDA   #3
        STA    LENGTH
       +JSUB   WRREC
        J      @RETADR
EOF     BYTE   C'EOF'
RETADR  RESW   1
LENGTH  RESW   1
BUFFER  RESB   4096
.
.       SUBROUTINE TO READ RECORD INTO BUFFER
.
RDREC   CLEAR  X
        CLEAR  A
        CLEAR  S
       +LDT   #4096
RLOOP   TD     INPUT
        JEQ    RLOOP
        RD     INPUT
        COMPR  A,S
        JEQ    EXIT
        STCH   BUFFER,X
        TIXR   T
        JLT    RLOOP
EXIT    STX    LENGTH
        RSUB
INPUT   BYTE   X'F1'
.
.       SUBROUTINE TO WRITE RECORD FROM BUFFER
.
WRREC   CLEAR  X
        LDT    LENGTH
WLOOP   TD     OUTPUT
        JEQ    WLOOP
        LDCH   BUFFER,X
        WD     OUTPUT
        TIXR   T
        JLT    WLOOP
        RSUB
OUTPUT  BYTE   X'06'
        END    FIRST
""";

    const matchValue = """HCOPY  000000001077
T0000001D17202D69202D4B1010360320262900003320074B10105D3F2FEC032010
T00001D130F20160100030F200D4B10105D3E2003454F46
T0010361DB410B400B44075101000E32019332FFADB2013A00433200857C003B850
T0010531D3B2FEA1340004F0000F1B410774000E32011332FFA53C003DF2008B850
T001070073B2FEF4F000006
M00000705
M00001405
M00002705
E000000
""";
    final assembler =
        LlbAssembler(context: LlbAssemblerContext(text: codeInput));
    assembler.pass1();
    assembler.pass2();
    final actualValue =
        assembler.context.records.map((e) => e.getRecord()).join();

    expect(actualValue, equals(matchValue));
  });
}
