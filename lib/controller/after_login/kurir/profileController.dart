// ignore_for_file: file_names

import 'package:get/get.dart';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kurir/api/beforeLoginAPI.dart';

class KurirProfileController extends GetxController {
  @override
  void onInit() {
    log("sini profile kurir controller oninit");
    super.onInit();
  }

  logout() async {
    await EasyLoading.show(
      status: 'Pengaturan Biaya...',
      maskType: EasyLoadingMaskType.black,
    );

    await BeforeLoginApi.logout();
    await EasyLoading.dismiss();
    Get.offAllNamed(
      '/index',
      arguments: {
        "tap": 0,
        "history": [0],
      },
    );
  }
}
