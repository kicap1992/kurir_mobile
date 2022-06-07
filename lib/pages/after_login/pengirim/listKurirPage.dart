// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:kurir/widgets/boxBackgroundDecoration.dart';

class ListKurirPage extends StatelessWidget {
  const ListKurirPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BoxBackgroundDecoration(
      child: Center(
        child: Text(
          'List Kurir',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
