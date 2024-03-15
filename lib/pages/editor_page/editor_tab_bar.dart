import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicxe/pages/editor_page/editor_tab_controller.dart';
import 'package:sicxe/pages/editor_page/editor_tab_menu.dart';
import 'package:sicxe/utils/workflow/editor_workflow.dart';
import 'package:sicxe/widgets/horizontal_scroll_view.dart';

class EditorCompactTabSwitchButton extends StatelessWidget {
  const EditorCompactTabSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    openDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return Consumer<EditorTabController>(builder: (context, etc, _) {
            return Consumer<EditorWorkflow>(builder: (context, editor, _) {
              final keys = editor.contents.keys.toList();
              return Dialog(
                child: Column(
                  children: [
                    SizedBox(height: 48),
                    Divider(height: 0),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: keys.length,
                        itemBuilder: (context, index) {
                          final key = keys[index];
                          return ListTile(
                            minVerticalPadding: 24,
                            onTap: () {
                              etc.tabId = key;
                              Navigator.of(context).pop();
                            },
                            title: Text(key),
                            leading: Container(
                              padding: EdgeInsets.only(right: 32, left: 16),
                              child: Icon(getIconById(key)),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(height: 0),
                    SizedBox(height: 48),
                  ],
                ),
              );
            });
          });
        },
      );
    }

    return Consumer<EditorTabController>(builder: (context, etc, _) {
      return Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: openDialog,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            child: ListTile(
              title: Text(
                etc.tabId,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: Icon(getIconById(etc.tabId)),
            ),
          ),
        ),
      );
    });
  }
}

getIconById(String id) {
  return switch (id.split(".").last) {
    "asm" => Icons.code,
    "vobj" => Icons.view_in_ar_outlined,
    String() => Icons.insert_drive_file_outlined,
  };
}

class EditorTabBar extends StatelessWidget {
  const EditorTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(builder: (context, constraints) {
      return Consumer<EditorTabController>(builder: (context, etc, _) {
        Widget tabWidget(String id) {
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              etc.tabId = id;
            },
            child: Container(
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: etc.tabId == id
                    ? colorScheme.secondaryContainer
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(getIconById(id)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(id),
                  ),
                ],
              ),
            ),
          );
        }

        if (constraints.maxWidth < 500) {
          return EditorCompactTabSwitchButton();
        }

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
          child: HorizontalScrollView(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (index, id) in etc.openedTabs.indexed) ...[
                  tabWidget(id),
                  const SizedBox(width: 8),
                ],
                EditorTabMenu(),
              ],
            ),
          ),
        );
      });
    });
  }
}
