// ignore_for_file: file_names

import 'package:get/get.dart';

import '../controller/before_login/pendaftaranKurirController.dart';

class PendaftaranKurirBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PendaftaranKurirController());
  }
}
