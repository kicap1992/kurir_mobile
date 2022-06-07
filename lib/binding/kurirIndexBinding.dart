// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:kurir/controller/after_login/kurir/pengaturanController.dart';

import '../controller/after_login/kurir/indexController.dart';

class KurirIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KurirIndexController>(() => KurirIndexController());

    Get.lazyPut<PengaturanKurirController>(() => PengaturanKurirController());
  }
}
