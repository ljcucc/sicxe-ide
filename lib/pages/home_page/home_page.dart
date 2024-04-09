import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sicxe/pages/home_page/home_page_runtime_item.dart';
import 'package:sicxe/pages/workspace_page/workspace_page.dart';
import 'package:sicxe/providers.dart';
import 'package:sicxe/utils/sicxe/sicxe_editor_workflow.dart';
import 'package:sicxe/utils/sicxe/sicxe_emulator_workflow.dart';
import 'package:sicxe/utils/uxn/uxn_editor_workflow.dart';
import 'package:sicxe/utils/uxn/uxn_emulator_workflow.dart';
import 'package:sicxe/utils/workflow/contents/contents_workflow.dart';
import 'package:sicxe/utils/workflow/contents/indexeddb_contents_workflow.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final body = Material(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            centerTitle: false,
            // surfaceTintColor: Colors.transparent,
            // leading:
            //     IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
            title: Padding(
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Choose a runtime type',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
            actions: <Widget>[
              PopupMenuButton(
                itemBuilder: (_) => [
                  PopupMenuItem(
                    onTap: () =>
                        launchUrlString("https://github.com/ljcucc/sicxe-ide"),
                    child: ListTile(
                      leading: Icon(Icons.code_rounded),
                      title: Text("Source code"),
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => AboutDialog(
                        applicationName: "SIC/XE Playground",
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text("About"),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 14),
                    child: Text(
                      "Virtual Machine",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: HomePageRuntimeItemWidget(
                      runtimeId: "sicxe",
                      runtimeName: 'SIC/XE',
                      runtimeDescription:
                          'A hypothetical virtual machine design by Leland L. Beck in his book: System Software: An Introduction to System Programming.',
                      onTap: () async {
                        // final contents = kIsWeb
                        //     ? IndexedDbContentsWorkflow(
                        //         headingPath: "/projects/project_beta",
                        //       )
                        //     : ContentsWorkflow();
                        final contents = ContentsWorkflow();
                        await contents.init();
                        final emulator = SicxeEmulatorWorkflow();
                        final editor = SicxeEditorWorkflow(
                          contents: contents,
                        );
                        await editor.createTemplate();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return PopScope(
                                canPop: false,
                                child: Providers(
                                  emulator: emulator,
                                  editor: editor,
                                  child: WorkspacePage(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 16.0),
                  //   child: HomePageRuntimeItemWidget(
                  //     runtimeId: "uxn",
                  //     runtimeName: 'Uxn',
                  //     runtimeDescription:
                  //         'The Uxn (and Varvara) is a ecosystem for personal computing founded by Hundred Rabbits, uxn have implementation-first design, which makes uxn tiny, small but powerful.',
                  //     onTap: () async {
                  //       final contents = ContentsWorkflow();
                  //       await contents.init();

                  //       final emulator = UxnEmulatorWorkflow();
                  //       final editor = UxnEditorWorkflow(
                  //         contents: contents,
                  //       );
                  //       await editor.createTemplate();
                  //       Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //           builder: (context) {
                  //             return PopScope(
                  //               canPop: false,
                  //               child: Providers(
                  //                 emulator: emulator,
                  //                 editor: editor,
                  //                 child: WorkspacePage(),
                  //               ),
                  //             );
                  //           },
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return body;

    return Theme(
      data: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 0, 4, 8),
          brightness: MediaQuery.of(context).platformBrightness,
          // surface: Color.fromARGB(255, 20, 20, 20),
          // background: Color.fromARGB(255, 20, 20, 20),
          // surface: Colors.black,
          secondaryContainer: Colors.white12,
          surfaceTint: Colors.white10,
        ),
        useMaterial3: true,
      ),
      child: Material(
        child: body,
      ),
    );
  }
}
