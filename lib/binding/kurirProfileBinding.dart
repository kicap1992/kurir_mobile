// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:kurir/controller/after_login/kurir/profileController.dart';

class KurirProfileBinding extends Bindings {
  // KurirProfileBinding() : super(autoInit: false);

  @override
  void dependencies() {
    Get.lazyPut<KurirProfileController>(() => KurirProfileController());
  }
}
