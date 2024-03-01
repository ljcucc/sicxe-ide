import 'package:flutter/material.dart';
import 'package:sicxe/pages/timeline_page/timeline_ruler_widget.dart';
import 'package:sicxe/pages/timeline_page/timline_scrollview.dart';

class TimelinePage extends StatelessWidget {
  final bool compact;
  const TimelinePage({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: compact ? 0 : 16,
      ).copyWith(bottom: compact ? 0 : null),
      child: Column(
        children: [
          TimelineRulerWidget(),
          SizedBox(height: 8),
          Expanded(
            child: TimelineScrollView(),
          )
          // Expanded(
          //   child: Container(
          //     clipBehavior: Clip.antiAlias,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(compact ? 0 : 16)),
          //     child: SingleChildScrollView(
          //       child: Column(
          //         children: [
          //           // TimelineScrollBar(
          //           //     title: "program counter",
          //           //     color: Colors.purple,
          //           //     itemBuilder: (index, vm) {
          //           //       return vm.pc.get().toRadixString(16).padLeft(5, '0');
          //           //     }),
          //           // SizedBox(height: 4),
          //           TimelineScrollBar(
          //               title: "regA",
          //               color: Colors.yellow,
          //               itemBuilder: (index, vm) {
          //                 if (vm.regA.get() == 0 && index != 0) return null;
          //                 return vm.regA
          //                     .get()
          //                     .toRadixString(16)
          //                     .padLeft(5, '0');
          //               }),
          //           SizedBox(height: 4),
          //           TimelineScrollBar(
          //               title: "regX",
          //               color: Colors.blue,
          //               itemBuilder: (index, vm) {
          //                 if (vm.regX.get() == 0 && index != 0) return null;
          //                 return vm.regX
          //                     .get()
          //                     .toRadixString(16)
          //                     .padLeft(5, '0');
          //               }),
          //           SizedBox(height: 4),
          //           TimelineScrollBar(
          //               title: "regL",
          //               color: Colors.red,
          //               itemBuilder: (index, vm) {
          //                 if (vm.regL.get() == 0 && index != 0) return null;
          //                 return vm.regL
          //                     .get()
          //                     .toRadixString(16)
          //                     .padLeft(5, '0');
          //               }),
          //           SizedBox(height: 4),
          //           TimelineScrollBar(
          //               title: "regSw",
          //               color: Colors.purple,
          //               itemBuilder: (index, vm) {
          //                 if (vm.regSw.get() == 0 && index != 0) return null;
          //                 return vm.regSw
          //                     .get()
          //                     .toRadixString(16)
          //                     .padLeft(5, '0');
          //               }),
          //           SizedBox(height: 4),
          //           TimelineScrollBar(
          //               title: "regB",
          //               color: Colors.yellow,
          //               itemBuilder: (index, vm) {
          //                 if (vm.regB.get() == 0 && index != 0) return null;
          //                 return vm.regB
          //                     .get()
          //                     .toRadixString(16)
          //                     .padLeft(5, '0');
          //               }),
          //           SizedBox(height: 4),
          //           TimelineScrollBar(
          //               title: "regS",
          //               color: Colors.blue,
          //               itemBuilder: (index, vm) {
          //                 if (vm.regS.get() == 0 && index != 0) return null;
          //                 return vm.regS
          //                     .get()
          //                     .toRadixString(16)
          //                     .padLeft(5, '0');
          //               }),
          //           SizedBox(height: 4),
          //           TimelineScrollBar(
          //               title: "regT",
          //               color: Colors.red,
          //               itemBuilder: (index, vm) {
          //                 if (vm.regT.get() == 0 && index != 0) return null;
          //                 return vm.regT
          //                     .get()
          //                     .toRadixString(16)
          //                     .padLeft(5, '0');
          //               }),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
