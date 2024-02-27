import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/assembler_page/assembler_page.dart';
import 'package:sicxe/pages/home_page/home_page.dart';
import 'package:sicxe/pages/home_page/home_page_compact.dart';
import 'package:sicxe/pages/playground_page/playground_page.dart';
import 'package:sicxe/pages/settings_page/settings_page.dart';
import 'package:sicxe/pages/timeline_page/timeline_page.dart';
import 'package:sicxe/pages/timeline_page/timing_control_bar.dart';
import 'package:sicxe/screen_size.dart';
import 'package:sicxe/widgets/document_display/document_display_widget.dart';
import 'package:sicxe/widgets/logo_widget.dart';

class CompactLayout extends StatelessWidget {
  final int selectedIndex;
  final Function(int index) onSelected;

  const CompactLayout({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final maxIndex = 3;
    final selectedPage = switch (selectedIndex) {
      0 => HomePageCompact(),
      1 => const TimelinePage(
          compact: true,
        ),
      2 => const PlaygroundPage(),
      3 => AssemblerPage(),
      int() => AssemblerPage(),
    };

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 65,
        surfaceTintColor: Colors.transparent,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.menu),
        // ),
        title: LogoWidget(
          compact: true,
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () {},
                child: ListTile(
                  title: Text("Help"),
                  leading: Icon(Icons.help_outline),
                ),
              ),
              PopupMenuItem(
                onTap: () {},
                child: ListTile(
                  title: Text("Settings"),
                  leading: Icon(Icons.settings_outlined),
                ),
              )
            ],
          ),
        ],
      ),
      body: Provider.value(
        value: ScreenSize.Compact,
        child: Center(
          child: Column(
            children: [
              Expanded(child: selectedPage),
              TimingControlBar(
                compact: true,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        selectedIndex: selectedIndex,
        onDestinationSelected: onSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.graphic_eq),
            label: "Timeline",
          ),
          NavigationDestination(
            icon: Icon(Icons.memory_rounded),
            label: "Inspector",
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_rounded),
            label: "Assembler",
          ),
        ],
      ),
    );
  }
}
