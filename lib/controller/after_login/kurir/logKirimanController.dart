// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

import '../../../api/kurirApi.dart';
import '../../../api/pengirimApi.dart';
import '../../../function/allFunction.dart';
import '../../../models/pengirimimanModel.dart';

class LogKirimanControllerKurir extends GetxController {
  final dev = Logger();
  RxInt loadPengiriman = 0.obs;
  RxList pengirimanModelList = [].obs;

  @override
  void onInit() {
    super.onInit();
    dev.i("sini on init log kiriman controller kurir");
    pengirimanAll();
  }

  pengirimanAll() async {
    loadPengiriman.value = 0;
    pengirimanModelList.value = [];

    final _api = Get.put(KurirApi());

    Map<String, dynamic> _data = await _api.getAllPengirimanCompleted();

    if (_data['status'] == 200) {
      if (_data['data'].length > 0) {
        pengirimanModelList.value =
            _data['data'].map((e) => PengirimanModel.fromJson(e)).toList();

        dev.d("pengirimanModelList: $pengirimanModelList");
      } else {
        pengirimanModelList.value = [];
      }
      loadPengiriman.value = 1;
    } else {
      pengirimanModelList.value = [];
      loadPengiriman.value = 2;
    }
  }

  cekDistance(LatLng latLngPengiriman, LatLng latLngPermulaan) async {
    final _api = Get.put(PengirimApi());
    double distance = await _api.jarak_route(
      latLngPermulaan.latitude,
      latLngPermulaan.longitude,
      latLngPengiriman.latitude,
      latLngPengiriman.longitude,
    );

    // dev.log(distance.toString() + "ini dia");

    return distance;
  }

  String cekHarga(
      double distance, int biayaMinimal, int biayaMaksimal, int biayaPerKilo) {
    //
    double hargaPerKiloTotal = biayaPerKilo * distance;
    double hargaTotalMinimal = hargaPerKiloTotal + biayaMinimal;
    double hargaTotalMaksimal = hargaPerKiloTotal + biayaMaksimal;

    return "Rp. " +
        AllFunction.thousandSeperatorDouble(hargaTotalMinimal) +
        " - Rp. " +
        AllFunction.thousandSeperatorDouble(hargaTotalMaksimal);
  }
}
