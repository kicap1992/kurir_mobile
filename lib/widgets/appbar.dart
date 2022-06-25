import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    Key? key,
    required this.header,
    required this.autoLeading,
    this.actions,
  }) : super(key: key);

  final String header;
  final bool autoLeading;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        header,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.03,
          fontWeight: FontWeight.bold,
        ),
      ),
      automaticallyImplyLeading: autoLeading,
      backgroundColor: const Color.fromARGB(255, 2, 72, 72),
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(
      //     bottom: Radius.circular(40),
      //   ),
      // ),
      actions: actions,
    );
  }
}
