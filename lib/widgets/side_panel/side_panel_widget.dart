import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/widgets/side_panel/side_panel_controller.dart';

class SidePanelWidget extends StatelessWidget {
  final Widget child;
  const SidePanelWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<SidePanelController>(
      builder: (context, controller, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeInOutQuart,
          width: controller.isOpen ? controller.width : 0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.only(right: 16, bottom: 16),
              width: controller.width,
              child: Card(
                shadowColor: Colors.transparent,
                elevation: 0,
                color: Colors.transparent,
                child: Column(
                  children: [
                    Expanded(
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
