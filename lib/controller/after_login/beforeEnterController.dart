// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../api/beforeLoginAPI.dart';

class BeforeEnterController extends GetxController {
  final storage = GetStorage();

  @override
  void onInit() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    // wait 3 sec
    // await Future.delayed(const Duration(seconds: 3));
    // await EasyLoading.dismiss();
    log("sini on init before enter");
    cek_login();

    // log(storage.read('role') + "ini role nya");
    super.onInit();
  }

  void cek_login() async {
    final _username =
        (storage.read('username') != null) ? storage.read('username') : "";
    final _password =
        (storage.read('password') != null) ? storage.read('password') : "";
    final _role = (storage.read('role') != null) ? storage.read('role') : "";

    final _id = (storage.read('id') != null) ? storage.read('id') : "";

    late bool _wrongPassword;

    Map<String, dynamic> _data = await BeforeLoginApi.log_in_user(
        _username, _password, _role.toLowerCase());

    switch (_data['status']) {
      case 200:
        _wrongPassword = true;
        break;
      case 400:
        _wrongPassword = false;
        break;
      default:
        _wrongPassword = false;
        break;
    }

    log(_username.toString() + " ini usernamenya");
    log(_password.toString() + " ini passwordnya");
    log(_role.toString() + " ini role nya");
    log(_id.toString() + " ini id nya");

    // await Future.delayed(const Duration(seconds: 3));
    await EasyLoading.dismiss();

    if (!_wrongPassword) {
      storage.remove('username');
      storage.remove('password');
      storage.remove('role');

      Get.offAllNamed(
        '/index',
        arguments: {
          "tap": 0,
          "history": [0],
        },
      );
      return;
    }

    if (_role.toLowerCase() == "kurir") {
      Get.offAllNamed(
        '/kurirIndex',
      );
      return;
    }

    if (_role.toLowerCase() == "pengirim") {
      Get.offAllNamed(
        'pengirimIndex',
        arguments: {
          "tap": 1,
          // "history": _historyIndex.value,
        },
      );
      return;
    }
  }
}
