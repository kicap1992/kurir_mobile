// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:kurir/controller/after_login/pengirim/infoPengirimanController.dart';

class InfoPengirimanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InfoPengirimanController>(() => InfoPengirimanController());
  }
}
