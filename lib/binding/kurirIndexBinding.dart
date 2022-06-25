// ignore_for_file: file_names

import 'package:get/get.dart';

import '../controller/after_login/kurir/indexController.dart';
import '../controller/after_login/kurir/pengaturanController.dart';
import '../controller/after_login/kurir/pengirimanController.dart';

class KurirIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KurirIndexController>(() => KurirIndexController());

    Get.lazyPut<PengaturanKurirController>(() => PengaturanKurirController());
    Get.lazyPut<PengirimanKurirController>(() => PengirimanKurirController());
  }
}
