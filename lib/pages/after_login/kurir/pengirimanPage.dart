// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../widgets/boxBackgroundDecoration.dart';

class PengirimanKurirPage extends StatelessWidget {
  const PengirimanKurirPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // ignore: unnecessary_const
      body: const BoxBackgroundDecoration(
        child: Center(
            child: Text(
          'Pengiriman',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        )),
      ),
    );
  }
}
