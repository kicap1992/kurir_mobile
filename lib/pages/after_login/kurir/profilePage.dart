// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/after_login/kurir/profileController.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/boxBackgroundDecoration.dart';

class ProfileKurirPage extends GetView<KurirProfileController> {
  const ProfileKurirPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBarWidget(
          header: "Halaman Profil",
          autoLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_outlined),
              onPressed: () {
                // log("ini untuk logout");
                // create get alert dialog
                Get.dialog(
                  AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Anda yakin ingin logout?'),
                    actions: [
                      ElevatedButton(
                        child: const Text('Yes'),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(
                              255, 104, 164, 164), //background color
                          // onPrimary: Colors.black, //ripple color
                        ),
                        onPressed: () {
                          // log("ini untuk logout");
                          Get.back();
                          controller.logout();
                        },
                      ),
                      ElevatedButton(
                        child: const Text('No'),
                        style: ElevatedButton.styleFrom(
                          primary:
                              Color.fromARGB(255, 2, 72, 72), //background color
                          // onPrimary: Colors.black, //ripple color
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Get.offAllNamed(
            '/kurirIndex',
          );
          return false;
        },
        child: BoxBackgroundDecoration(
          child: const Center(
            child: Text('Profile'),
          ),
        ),
      ),
    );
  }
}
