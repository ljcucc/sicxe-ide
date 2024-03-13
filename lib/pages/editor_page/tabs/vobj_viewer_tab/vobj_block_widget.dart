import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/editor_page/tabs/vobj_viewer_tab/object_code_visualize_provider.dart';

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
        textStyle: GoogleFonts.robotoMono(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        message: message,
        child: body,
      );
    });
  }
}

class VobjBlockWdiget extends StatelessWidget {
  final List<Map<String, String>> objectProgramRecord;

  const VobjBlockWdiget({
    super.key,
    required this.objectProgramRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (Map<String, String> map in objectProgramRecord)
          SuggestableText(
            message: map['tooltip'] ?? "",
            text: map['text'] ?? "",
          ),
      ],
    );
  }
}
