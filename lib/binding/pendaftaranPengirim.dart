// ignore_for_file: file_names

import 'package:get/get.dart';

import '../controller/before_login/pendaftaranPengirimController.dart';

class PendaftaranPengirimBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PendaftaranPengirimController());
  }
}
