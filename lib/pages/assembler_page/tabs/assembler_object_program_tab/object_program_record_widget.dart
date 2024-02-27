import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/utils/assembler.dart';
import 'package:sicxe/pages/assembler_page/tabs/assembler_object_program_tab/object_code_visualize_provider.dart';

class SuggestableText extends StatelessWidget {
  final String message;
  final String text;
  final Color? color;

  const SuggestableText({
    super.key,
    required this.message,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final objectCodeIsVisualized = context.watch<ObjectCodeIsVisualized>();
    final isVisualized = objectCodeIsVisualized.visualized;
    final body = InkWell(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCirc,
        padding: EdgeInsets.all(isVisualized ? 8 : 0),
        margin: EdgeInsets.all(isVisualized ? 2 : 0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: isVisualized
              ? Theme.of(context)
                  .colorScheme
                  .surfaceTint
                  .harmonizeWith(
                    color ?? Theme.of(context).colorScheme.surfaceTint,
                  )
                  .withOpacity(.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.robotoMono().copyWith(
            color: color != null
                ? Theme.of(context).colorScheme.primary.harmonizeWith(color!)
                : null,
          ),
        ),
      ),
    );

    return Builder(builder: (context) {
      return Tooltip(
        message: message,
        child: body,
      );
    });
  }
}

class ObjectProgramRecordWdiget extends StatelessWidget {
  final ObjectProgramRecord objectProgramRecord;

  const ObjectProgramRecordWdiget({
    super.key,
    required this.objectProgramRecord,
  });

  /// Header record display widget
  Widget headerInteractiveDisp(HeaderRecord hr) {
    return Builder(builder: (context) {
      return Row(
        children: [
          SuggestableText(
            message: "Header char, for HeaderRecord is [T]",
            text: "H",
            color: Colors.green[800],
          ),
          SuggestableText(
            message: "Program name",
            text: hr.programName,
            color: Colors.green[800],
          ),
          SuggestableText(
            message: "Staring address of object program.",
            text: hr.startingAddress,
            color: Colors.green[800],
          ),
          SuggestableText(
            message: "Length of object program in bytes.",
            text: hr.length,
            color: Colors.green[800],
          ),
        ],
      );
    });
  }

  /// Text record display widget
  Widget textInteractiveDisp(TextRecord tr) {
    return Row(
      children: [
        SuggestableText(
            message: "Heading char, for TextRecord is [T]", text: "T"),
        SuggestableText(
            message: "Starting address for object code in this record.",
            text: tr.startingAddress),
        SuggestableText(
            message: "Length of object code in this record in bytes",
            text: tr.lengthString),
        for (final block in tr.blocks)
          SuggestableText(message: "Object code: $block", text: block),
      ],
    );
  }

  /// End record display widget
  Widget endInteractiveDisp(EndRecord er) {
    return Row(
      children: [
        SuggestableText(
          message: "Heading char, for EndRecord is [E]",
          text: "E",
        ),
        SuggestableText(
          message: "Starting address of this program",
          text: er.bootAddress,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (objectProgramRecord is HeaderRecord) {
      return headerInteractiveDisp(objectProgramRecord as HeaderRecord);
    }

    if (objectProgramRecord is TextRecord) {
      return textInteractiveDisp(objectProgramRecord as TextRecord);
    }

    if (objectProgramRecord is EndRecord) {
      return endInteractiveDisp(objectProgramRecord as EndRecord);
    }

    return Container();
  }
}
