// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../controller/after_login/kurir/profileController.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/boxBackgroundDecoration.dart';

class ProfileKurirPage extends StatefulWidget {
  const ProfileKurirPage({Key? key}) : super(key: key);

  @override
  State<ProfileKurirPage> createState() => _ProfileKurirPageState();
}

class _ProfileKurirPageState extends State<ProfileKurirPage> {
  final dev = Logger();
  late KurirProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put<KurirProfileController>(KurirProfileController());
    // await 3 sec
    Future.delayed(const Duration(seconds: 1), () {
      controller.cekProfile();
    });
    // controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBarWidget(
          header: "Halaman Profil",
          autoLeading: true,
          actions: [
            IconButton(
              onPressed: () {
                if (controller.loading.value == 1) {
                  controller.lihatFoto(
                      context,
                      controller.kurirModel.value.kenderaan_url!,
                      "Foto Kenderaan");
                }
              },
              icon: const Icon(Icons.motorcycle),
            ),
            _LogoutButton(controller: controller),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Get.offAllNamed('/kurirIndex', arguments: 1);
          return false;
        },
        child: BoxBackgroundDecoration(
          child: Obx(
            () => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    alignment: Alignment.center,
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
                    child: (controller.loading.value == 0)
                        ? const SizedBox()
                        : (controller.loading.value == 1)
                            ? ClipOval(
                                child: Image.network(
                                  controller.kurirModel.value.photo_url!,
                                  fit: BoxFit.cover,
                                  width: 200,
                                  height: 200,
                                ),
                              )
                            : const SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 10),
                    child: Text(
                      (controller.loading.value == 0)
                          ? "Loading..."
                          : (controller.loading.value == 1)
                              ? controller.kurirModel.value.nama!
                              : "Error Load Data",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  DetailChild(
                    icon: Icons.person,
                    text: (controller.loading.value == 0)
                        ? "Loading..."
                        : (controller.loading.value == 1)
                            ? controller.kurirModel.value.nik!
                            : "Error Load Data",
                    icon2: GestureDetector(
                      onTap: () {
                        if (controller.loading.value == 1) {
                          controller.lihatFoto(context,
                              controller.kurirModel.value.ktp_url!, "Foto KTP");
                        }
                      },
                      child: const Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  DetailChild(
                      icon: Icons.phone_android_outlined,
                      text: (controller.loading.value == 0)
                          ? "Loading..."
                          : (controller.loading.value == 1)
                              ? controller.kurirModel.value.no_telp!
                              : "Error Load Data"),
                  DetailChild(
                      icon: Icons.email_outlined,
                      text: (controller.loading.value == 0)
                          ? "Loading..."
                          : (controller.loading.value == 1)
                              ? controller.kurirModel.value.email!
                              : "Error Load Data"),
                  DetailChild(
                      icon: Icons.home,
                      text: (controller.loading.value == 0)
                          ? "Loading..."
                          : (controller.loading.value == 1)
                              ? controller.kurirModel.value.alamat!
                              : "Error Load Data"),
                  DetailChild(
                    icon: Icons.motorcycle_outlined,
                    text: (controller.loading.value == 0)
                        ? "Loading..."
                        : (controller.loading.value == 1)
                            ? controller.kurirModel.value.no_kenderaan!
                            : "Error Load Data",
                    icon2: GestureDetector(
                      onTap: () {
                        if (controller.loading.value == 1) {
                          controller.lihatFoto(
                              context,
                              controller.kurirModel.value.kenderaan_url!,
                              "Foto Kenderaan");
                        }
                      },
                      child: const Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailChild extends StatelessWidget {
  const DetailChild(
      {Key? key, required this.icon, required this.text, this.icon2})
      : super(key: key);

  final IconData icon;
  final String text;
  final Widget? icon2;

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
          Expanded(
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
          ),
          if (icon2 != null) icon2!
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final KurirProfileController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
                  primary: const Color.fromARGB(
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
                      const Color.fromARGB(255, 2, 72, 72), //background color
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
