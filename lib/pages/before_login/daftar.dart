import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:kurir/controller/before_login/indexController.dart';

import '../../controller/before_login/loginController.dart';
import '../../widgets/appbar.dart';
import '../../widgets/boxBackgroundDecoration.dart';
import '../../widgets/ourContainer.dart';

// class DaftarPage extends GetView<IndexController> {
class DaftarPage extends GetView<LoginController> {
  const DaftarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => controller.willPopScopeWidget(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
          child: const AppBarWidget(
            header: "Halaman Pendaftaran",
            autoLeading: true,
          ),
        ),
        body: BoxBackgroundDecoration(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  // set logo.png on top center of screen
                  Image.asset(
                    'assets/logo.png',
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width * 0.30,
                  ),
                  OurContainer(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Obx(
                            () => DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Daftar Sebagai',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              value: controller.selectedRole.value,
                              items: controller.role.map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (item) {
                                // log(item.toString() + " ini item");
                                controller.selectedRole.value = item.toString();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ElevatedButton(
                            onPressed: () {
                              log(controller.selectedRole.value);
                              if (controller.selectedRole.value == 'Kurir') {
                                // Get.delete<LoginController>();
                                Get.offAllNamed('/pendaftaranKurir');
                              } else if (controller.selectedRole.value ==
                                  'Pengirim') {
                                Get.offAllNamed('/pendaftaranPengirim');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 2, 72, 72),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Daftar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Obx(() => controller.bottomNavigationBar()),
      ),
    );
  }
}
