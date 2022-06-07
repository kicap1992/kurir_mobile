// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurir/controller/after_login/kurir/indexController.dart';
import 'package:kurir/pages/after_login/kurir/logHistoryPage.dart';
import 'package:kurir/pages/after_login/kurir/pengaturanPage.dart';
import 'package:kurir/pages/after_login/kurir/pengirimanPage.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class KurirIndexPage extends GetView<KurirIndexController> {
  const KurirIndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        child: PageView(
          controller: controller.pageController,
          children: const [
            PengaturanKurirPage(),
            PengirimanKurirPage(),
            LogHistoryKurirPage(),
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
