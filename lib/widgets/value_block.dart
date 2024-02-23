import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ValueBlock extends StatelessWidget {
  final String title;
  final String disp;
  final bool mono;
  final VoidCallback? onTap;

  const ValueBlock({
    super.key,
    required this.title,
    required this.disp,
    this.mono = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      shadowColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title",
              ),
              Text(
                "$disp",
                style: mono
                    ? Theme.of(context).textTheme.headlineSmall
                    : GoogleFonts.spaceMono(
                        textStyle: Theme.of(context).textTheme.headlineSmall,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
