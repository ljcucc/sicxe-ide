import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/navigation_page_provider.dart';
import 'package:sicxe/pages/assets_page/assets_page.dart';
import 'package:sicxe/pages/editor_page/editor_page.dart';
import 'package:sicxe/pages/home_page/home_page.dart';
import 'package:sicxe/pages/terminal_page/terminal_page.dart';
import 'package:sicxe/pages/timeline_page/timeline_page.dart';

class NavigationPageView extends StatelessWidget {
  const NavigationPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationPageProvider>(
      builder: (context, navPageProvider, child) {
        final pageId = navPageProvider.id;
        final selectedPage = switch (pageId) {
          NavigationPageId.Home => const HomePage(),
          NavigationPageId.Timeline => const TimelinePage(),
          NavigationPageId.Terminal => const TerminalPage(),
          NavigationPageId.Editor => const EditorPage(),
          NavigationPageId.Assets => const AssetsPage(),
        };

        return selectedPage;
      },
    );
  }
}
