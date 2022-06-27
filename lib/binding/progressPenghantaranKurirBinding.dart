// ignore_for_file: file_names

import 'package:get/get.dart';

import '../controller/after_login/kurir/progressPenghantaranController.dart';

class ProgressPenghantaranKurirBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProgressPenghantaranControllerKurir());
  }
}
