import 'package:flutter/material.dart';

class BounceScrollerWidget extends StatelessWidget {
  const BounceScrollerWidget({Key? key, required this.children})
      : super(key: key);

  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      width: double.infinity,
      child: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: children,
      ),
    );
  }
}
