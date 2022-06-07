// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurir/controller/after_login/kurir/profileController.dart';

class ProfileKurirPage extends GetView<KurirProfileController> {
  const ProfileKurirPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              // log("ini untuk logout");
              // create get alert dialog
              Get.dialog(AlertDialog(
                title: const Text('Logout'),
                content: const Text('Anda yakin ingin logout?'),
                actions: [
                  ElevatedButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      // log("ini untuk logout");
                      Get.back();
                      controller.logout();
                    },
                  ),
                  ElevatedButton(
                    child: const Text('No'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[400], //background color
                      // onPrimary: Colors.black, //ripple color
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ));
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Get.offAllNamed(
            '/kurirIndex',
          );
          return false;
        },
        child: const Center(
          child: Text('Profile'),
        ),
      ),
    );
  }
}
