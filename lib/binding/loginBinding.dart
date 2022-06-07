// ignore_for_file: file_names

import 'package:get/get.dart';

import '../controller/before_login/loginController.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    // Get.lazyPut(() => LoginController(), fenix: true);
  }
}
