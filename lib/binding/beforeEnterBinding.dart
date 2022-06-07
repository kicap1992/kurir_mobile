// ignore_for_file: file_names

import 'package:get/get.dart';

import '../controller/after_login/beforeEnterController.dart';

class BeforeEnterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeforeEnterController());
  }
}
