// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:kurir/controller/after_login/pengirim/kirimBarangController.dart';
import 'package:kurir/controller/after_login/pengirim/logKirimanController.dart';

import '../controller/after_login/pengirim/indexController.dart';

class PengirimIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengirimIndexController>(() => PengirimIndexController());

    Get.lazyPut<KirimBarangController>(() => KirimBarangController());

    Get.lazyPut<LogKirimanController>(() => LogKirimanController());
  }
}
