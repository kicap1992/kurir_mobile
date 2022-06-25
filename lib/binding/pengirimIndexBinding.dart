// ignore_for_file: file_names

import 'package:get/get.dart';

import '../controller/after_login/pengirim/indexController.dart';
import '../controller/after_login/pengirim/kirimBarangController.dart';
import '../controller/after_login/pengirim/listKurirController.dart';
import '../controller/after_login/pengirim/logKirimanController.dart';

class PengirimIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengirimIndexController>(() => PengirimIndexController());

    Get.lazyPut<KirimBarangController>(() => KirimBarangController());

    Get.lazyPut<LogKirimanController>(() => LogKirimanController());

    Get.lazyPut<ListKurirController>(() => ListKurirController());
  }
}
