// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurir/widgets/boxBackgroundDecoration.dart';

class PengirimProfilePage extends StatelessWidget {
  const PengirimProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengirim Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              log("logout");
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Get.offAllNamed(
            '/pengirimIndex',
            arguments: {
              'tap': 1,
            },
          );
          return false;
        },
        child: const BoxBackgroundDecoration(
          child: Center(
            child: Text(
              'Pengirim Profile',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
