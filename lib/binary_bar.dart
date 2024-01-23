import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BinaryBarView extends StatelessWidget {
  final Uint8List values;
  final bool? showNumbers;
  final Color? activedColor;
  final Color? disabledColor;

  const BinaryBarView({
    super.key,
    required this.values,
    this.showNumbers,
    this.activedColor,
    this.disabledColor,
  });

  _binaryBall(context, int bit) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: bit == 0
            ? disabledColor ?? Theme.of(context).colorScheme.secondaryContainer
            : activedColor ?? Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  _byteWidget(context, int value) {
    value = 0x0F & value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showNumbers ?? false)
          Text(
            value.toRadixString(16).padLeft(2, '0'),
            style: GoogleFonts.spaceMono(),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < 4; i++) ...[
              _binaryBall(context, 0x01 << i & value),
              const SizedBox(width: 2),
            ],
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 8,
      spacing: 8,
      children: [
        for (int item in values) _byteWidget(context, item),
      ],
    );
  }
}
