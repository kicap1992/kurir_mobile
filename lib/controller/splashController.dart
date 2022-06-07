// ignore_for_file: file_names

import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 2500), () {
      log('SplashController onInit');
      // Get.offAllNamed('/index');
      // goto to /index with argument tap : 0
      final _role = (storage.read('role') != null) ? storage.read('role') : '';

      if (_role == 'pengirim' || _role == 'kurir') {
        Get.offAllNamed('/beforeEnter');
      } else {
        Get.offAllNamed(
          '/index',
          arguments: {
            "tap": 0,
            "history": [0],
          },
        );
      }
    });
  }
}
