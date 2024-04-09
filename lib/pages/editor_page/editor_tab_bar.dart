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
    openDialog(editor, etc) {
      Future<List<String>> keys = editor.contents.getFileList();
      showDialog(
        context: context,
        builder: (context) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<EditorTabController>.value(value: etc),
              // ChangeNotifierProvider<EditorWorkflow>.value(value: editor),
            ],
            child: Consumer<EditorTabController>(builder: (context, etc, _) {
              return FutureBuilder(
                future: keys,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final keys = snapshot.data ?? [];
                  return Dialog(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 500),
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
                                    padding:
                                        EdgeInsets.only(right: 32, left: 16),
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
                    ),
                  );
                },
              );
            }),
          );
        },
      );
    }

    final double borderRadius = 100;

    return Consumer<EditorWorkflow>(builder: (context, editor, _) {
      return Consumer<EditorTabController>(builder: (context, etc, _) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            // color: Theme.of(context)
            //     .colorScheme
            //     .secondaryContainer
            //     .withOpacity(.5),
            // color: Theme.of(context).colorScheme.secondaryContainer,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          child: InkWell(
            onTap: () => openDialog(editor, etc),
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              width: double.infinity,
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16).copyWith(right: 8),
                title: Text(
                  etc.tabId,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: Icon(getIconById(etc.tabId)),
                trailing: EditorTabMenu(),
              ),
            ),
          ),
        );
      });
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
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              etc.tabId = id;
            },
            child: Container(
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: etc.tabId == id
                    ? colorScheme.secondaryContainer.withOpacity(.75)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
                // border: Border.all(
                //   color: etc.tabId == id
                //       ? colorScheme.outline
                //       : colorScheme.outlineVariant,
                // ),
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
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
