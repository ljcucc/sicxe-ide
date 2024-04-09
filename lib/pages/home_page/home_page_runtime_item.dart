import 'package:flutter/material.dart';

class HomePageRuntimeItemWidget extends StatefulWidget {
  final String runtimeId;
  final String runtimeName;
  final String runtimeDescription;
  final VoidCallback onTap;

  const HomePageRuntimeItemWidget({
    super.key,
    required this.runtimeName,
    required this.runtimeDescription,
    this.runtimeId = "",
    required this.onTap,
  });

  @override
  State<HomePageRuntimeItemWidget> createState() =>
      _HomePageRuntimeItemWidgetState();
}

class _HomePageRuntimeItemWidgetState extends State<HomePageRuntimeItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        "assets/runtime_preview/preview_${widget.runtimeId}.jpg";
    final image = Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          width: 120,
        ),
      ),
    );

    final texts = Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.runtimeName,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 8),
            Opacity(
              opacity: .5,
              child: Text(
                widget.runtimeDescription,
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints:
            BoxConstraints(maxWidth: 500, minWidth: 350, minHeight: 150),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // color: Theme.of(context).colorScheme.secondaryContainer,
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(.35),
          // border: Border.all(
          // ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              texts,
              image,
            ],
          ),
        ),
      ),
    );
  }
}
