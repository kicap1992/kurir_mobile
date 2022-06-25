// ignore_for_file: file_names

// ignore: unused_import
import 'dart:developer' as dev;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kurir/api/beforeLoginAPI.dart';

class PengirimProfileController extends GetxController {
  String headerText = "Profil Pengirim";
  @override
  void onInit() {
    dev.log("sini on init profile pengirim");
    super.onInit();
  }

  logout() async {
    await EasyLoading.show(
      status: 'Logout',
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
