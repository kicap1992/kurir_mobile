// ignore_for_file: file_names

import 'package:get/get.dart';

import '../controller/splashController.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
