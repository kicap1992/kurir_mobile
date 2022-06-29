// ignore_for_file: file_names

import 'package:get/get.dart';

import '../../../api/pengirimApi.dart';
import '../../../models/usersModel.dart';

class ListKurirController extends GetxController {
  RxList kurirModelList = [].obs;
  RxInt loadKurir = 0.obs;

  @override
  void onReady() {
    super.onReady();
    kurirAll();
  }

  kurirAll() async {
    loadKurir.value = 0;
    kurirModelList.value = [];

    final _api = Get.put(PengirimApi());
    Map<String, dynamic> _data = await _api.getAllKurir();
    // dev.log(_data.toString());

    if (_data['status'] == 200) {
      if (_data['data'].length > 0) {
        kurirModelList.value =
            _data['data'].map((e) => KurirModel.fromJson(e)).toList();
      } else {
        kurirModelList.value = [];
      }
      loadKurir.value = 1;
    } else {
      kurirModelList.value = [];
      loadKurir.value = 2;
    }
  }
}
