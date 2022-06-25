// ignore_for_file: file_names

// ignore: unused_import
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/after_login/pengirim/pengirimProfileController.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/boxBackgroundDecoration.dart';

class PengirimProfilePage extends GetView<PengirimProfileController> {
  const PengirimProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBarWidget(
          header: controller.headerText,
          autoLeading: true,
          actions: [
            HeaderActionButton(controller: controller),
          ],
        ),
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
        child: BoxBackgroundDecoration(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(3),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage('assets/loading.gif'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                child: Text(
                  "Nama User",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),
              const DetailChild(
                  icon: Icons.phone_android_outlined, text: "08123456789"),
              const DetailChild(
                  icon: Icons.email_outlined, text: "Karauksii@gmail.com"),
              const DetailChild(
                  icon: Icons.home,
                  text:
                      "Jln Industri Kecil Parepare asdasd asdasd asdasda asdas"),
              const DetailChild(
                  icon: Icons.motorcycle_outlined,
                  text: "3 kali melakukan pengiriman barang"),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailChild extends StatelessWidget {
  const DetailChild({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: MediaQuery.of(context).size.width * 0.15,
        right: MediaQuery.of(context).size.width * 0.15,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(
            width: 25,
          ),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderActionButton extends StatelessWidget {
  const HeaderActionButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final PengirimProfileController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout_outlined),
      onPressed: () {
        Get.dialog(
          AlertDialog(
            title: const Text('Logout'),
            content: const Text('Anda yakin ingin logout?'),
            actions: [
              ElevatedButton(
                child: const Text('Yes'),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 2, 72, 72),
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
                  primary: const Color.fromARGB(
                      255, 104, 164, 164), //background color
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
    );
  }
}
