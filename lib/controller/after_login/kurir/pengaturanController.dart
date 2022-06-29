// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kurir/api/kurirApi.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:intl/intl.dart';
import 'package:kurir/models/kurirModel.dart';

class PengaturanKurirController extends GetxController {
  final storage = GetStorage();

  var formKey = GlobalKey<FormState>(); // for form validation

  Rx<String> status = ''.obs;

  final minimalBiayaPengirimanController = TextEditingController();
  final maksimalBiayaPengirimanController = TextEditingController();
  final biayaPerKiloController = TextEditingController();

  final FocusNode minimalBiayaPengirimanFocusNode = FocusNode();
  final FocusNode maksimalBiayaPengirimanFocusNode = FocusNode();
  final FocusNode biayaPerKiloFocusNode = FocusNode();

  @override
  void onInit() {
    log("sini pengaturan controller");
    minimalBiayaPengirimanController.clear();

    maksimalBiayaPengirimanController.clear();
    biayaPerKiloController.clear();
    log('ini idnya ' + storage.read('id'));
    super.onInit();
  }

  @override
  void onReady() {
    cek_datanya();
    super.onReady();
  }

  cek_datanya() async {
    await EasyLoading.show(
      status: 'Loading Data...',
      maskType: EasyLoadingMaskType.black,
    );

    final _api = Get.put(KurirApi());

    final result = await _api.cekPengaturanKurir();

    log(result.toString());
    if (result['status'] == 200 && result['data'] != null) {
      final PengaturanBiayaKurirModel pengaturanBiayaKurir =
          PengaturanBiayaKurirModel.fromJson(result['data']);
      minimalBiayaPengirimanController.text =
          thousandsSeperator(pengaturanBiayaKurir.minimalBiayaPengiriman!);
      maksimalBiayaPengirimanController.text =
          thousandsSeperator(pengaturanBiayaKurir.maksimalBiayaPengiriman!);
      biayaPerKiloController.text =
          thousandsSeperator(pengaturanBiayaKurir.biayaPerKilo!);

      status.value = 'Ubah';
    } else {
      status.value = 'Simpan';
    }

    await EasyLoading.dismiss();
  }

  simpan() async {
    // remove "," from text
    //get alert dialog

    final minimalBiayaPengiriman =
        minimalBiayaPengirimanController.text.replaceAll(RegExp(r','), '');
    final maksimalBiayaPengiriman =
        maksimalBiayaPengirimanController.text.replaceAll(RegExp(r','), '');
    final biayaPerKilo =
        biayaPerKiloController.text.replaceAll(RegExp(r','), '');

    // log(minimalBiayaPengiriman + " ini minimal biaya pengiriman");
    // log(maksimalBiayaPengiriman + " ini maksimal biaya pengiriman");
    // log(biayaPerKilo + " ini biaya per kilo");
    await EasyLoading.show(
      status: 'Pengaturan Biaya...',
      maskType: EasyLoadingMaskType.black,
    );

    final _api = Get.put(KurirApi());
    final result = await _api.pengaturanKurir(
        minimalBiayaPengiriman, maksimalBiayaPengiriman, biayaPerKilo);

    log(result.toString());
    onInit();
    await EasyLoading.dismiss();
  }

  coba() {
    log("sini coba terjadi");
  }

  thousandsSeperator(int number) {
    final formatter = NumberFormat('#,###');
    final numbernya = formatter.format(number);
    // log(numbernya + " ini numbernya");
    return numbernya;
  }

  removeComma(String number) {
    final numbernya = number.replaceAll(RegExp(r','), '');
    return int.parse(numbernya);
  }
}
