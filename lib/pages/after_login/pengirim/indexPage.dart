// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurir/controller/after_login/pengirim/indexController.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:kurir/pages/after_login/pengirim/kirimBarangPage.dart';
import 'package:kurir/pages/after_login/pengirim/listKurirPage.dart';
import 'package:kurir/pages/after_login/pengirim/logKirimanPage.dart';

class PengirimIndexPage extends GetView<PengirimIndexController> {
  const PengirimIndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: unnecessary_const
      body: DoubleBackToCloseApp(
        child: PageView(
          controller: controller.pageController,
          children: const [
            KirimBarangPage(),
            LogKirimanPage(),
            ListKurirPage(),
          ],
          onPageChanged: (index) {
            log("sini on page changed" + index.toString());
            // Get.delete<PengaturanKurirController>();
            FocusScope.of(context).unfocus();

            controller.pageChanged(index);
          },
        ),
        snackBar: const SnackBar(
          content: Text('Tekan tombol kembali lagi untuk keluar'),
        ),
      ),
      bottomNavigationBar: Obx(() => controller.bottomNavigationBar(context)),
    );
  }
}
