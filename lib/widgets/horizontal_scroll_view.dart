import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HorizontalScrollView extends StatefulWidget {
  final Widget child;

  const HorizontalScrollView({
    super.key,
    required this.child,
  });

  @override
  State<HorizontalScrollView> createState() => _HorizontalScrollViewState();
}

class _HorizontalScrollViewState extends State<HorizontalScrollView> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        /// https://github.com/flutter/flutter/issues/105095
        if (event is PointerScrollEvent) {
          scrollController.animateTo(
              scrollController.offset + event.scrollDelta.dy,
              duration: Duration(milliseconds: 2),
              curve: Curves.bounceIn);
        }
      },
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: widget.child,
      ),
    );
  }
}
