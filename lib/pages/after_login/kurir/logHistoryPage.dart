// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../widgets/boxBackgroundDecoration.dart';

class LogHistoryKurirPage extends StatelessWidget {
  const LogHistoryKurirPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BoxBackgroundDecoration(
        child: Center(
          child: Text(
            'Log History',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
