// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:kurir/controller/after_login/pengirim/pengirimProfileController.dart';

class PengirimProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengirimProfileController>(
      () => PengirimProfileController(),
    );
  }
}
