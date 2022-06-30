// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kurir/api/beforeLoginAPI.dart';
import 'package:kurir/api/kurirApi.dart';
import 'package:kurir/models/usersModel.dart';
import 'package:logger/logger.dart';

class KurirProfileController extends GetxController {
  final dev = Logger();

  Rx<KurirModel> kurirModel = Rx<KurirModel>(KurirModel());
  RxInt loading = 0.obs;
  RxString error = RxString("");

  void cekProfile() async {
    dev.i("sini cek profile");
    loading.value = 0;
    final _api = Get.put(KurirApi());
    Map<String, dynamic> _data = await _api.profileKurir2();
    if (_data['status'] == 200) {
      dev.i("sini dia");
      kurirModel.value = KurirModel.fromJson(_data['data']);
      loading.value = 1;
    } else {
      loading.value = 2;
      error.value = _data['message'];
    }
  }

  lihatFoto(BuildContext context, String foto, String title) {
    if (foto != "") {
      Get.dialog(
        _FotoDialogBox(
          foto: foto,
          title: title,
        ),
      );
    } else {
      Get.snackbar(
        "Info",
        "Foto Barang Pengiriman Masih Dalam Proses Upload",
        icon: const Icon(
          Icons.info_outline_rounded,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 71, 203, 240),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  logout() async {
    await EasyLoading.show(
      status: 'Pengaturan Biaya...',
      maskType: EasyLoadingMaskType.black,
    );

    await BeforeLoginApi.logout();
    await EasyLoading.dismiss();
    Get.offAllNamed(
      '/index',
      arguments: {
        "tap": 0,
        "history": [0],
      },
    );
  }
}

class _FotoDialogBox extends StatelessWidget {
  const _FotoDialogBox({
    Key? key,
    required this.foto,
    required this.title,
  }) : super(key: key);

  final String foto;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 104, 164, 164),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      content: Container(
        height: Get.height * 0.5,
        width: Get.width * 0.6,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/loading.gif'),
                fit: BoxFit.cover,
              ),
            ),
            // child: Container(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: NetworkImage(foto),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            child: Image.network(
              foto,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
