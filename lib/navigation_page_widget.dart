import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/navigation_page_provider.dart';
import 'package:sicxe/pages/assembler_page/assembler_page.dart';
import 'package:sicxe/pages/home_page/home_page.dart';
import 'package:sicxe/pages/inspector_page/inspector_page.dart';
import 'package:sicxe/pages/terminal_page/terminal_page.dart';
import 'package:sicxe/pages/timeline_page/timeline_page.dart';

class NavigationPageWidget extends StatelessWidget {
  const NavigationPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationPageProvider>(
      builder: (context, navPageProvider, child) {
        final pageId = navPageProvider.id;
        final selectedPage = switch (pageId) {
          NavigationPageId.Home => const HomePage(),
          NavigationPageId.Timeline => const TimelinePage(),
          NavigationPageId.Inspector => const InspectorPage(),
          NavigationPageId.Terminal => const TerminalPage(),
          NavigationPageId.Assembler => const AssemblerPage(),
        };

        return selectedPage;
      },
    );
  }
}
