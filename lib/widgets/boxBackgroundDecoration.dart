// ignore_for_file: file_names

import 'package:flutter/material.dart';

class BoxBackgroundDecoration extends StatelessWidget {
  final Widget? child;
  const BoxBackgroundDecoration({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // decoration gradient
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 199, 214, 234),
            Color.fromARGB(255, 104, 164, 164),
            Color.fromARGB(255, 4, 103, 103),
            Color.fromARGB(255, 2, 72, 72),
          ],
        ),
      ),
      child: child,
    );
  }
}
