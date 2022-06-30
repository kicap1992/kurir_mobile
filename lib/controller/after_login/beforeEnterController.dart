// ignore_for_file: file_names, non_constant_identifier_names

// import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

class BeforeEnterController extends GetxController {
  final storage = GetStorage();

  final dev = Logger();

  // @override
  // void onInit() async {
  //   // await EasyLoading.show(
  //   //   status: 'Loading...',
  //   //   maskType: EasyLoadingMaskType.black,
  //   // );
  //   // wait 3 sec

  //   // log(storage.read('role') + "ini role nya");
  //   super.onInit();
  //   await Future.delayed(const Duration(seconds: 2));
  //   // await EasyLoading.dismiss();
  //   cek_login();
  // }
  @override
  void onInit() {
    super.onInit();
    // future 1.5 sec
    Future.delayed(const Duration(seconds: 1), () {
      cek_login();
    });
  }

  void cek_login() async {
    // final _username =
    //     (storage.read('username') != null) ? storage.read('username') : "";
    // final _password =
    //     (storage.read('password') != null) ? storage.read('password') : "";
    final _role = (storage.read('role') != null) ? storage.read('role') : "";

    // final _id = (storage.read('id') != null) ? storage.read('id') : "";

    // late bool _wrongPassword;

    // var _c = Get.put(BeforeLoginApi());

    // Map<String, dynamic> _data =
    //     await _c.log_in_user(_username, _password, _role.toLowerCase());

    // dev.i(_data);

    // switch (_data['status']) {
    //   case 200:
    //     _wrongPassword = true;
    //     break;
    //   case 400:
    //     _wrongPassword = false;
    //     break;
    //   default:
    //     _wrongPassword = false;
    //     break;
    // }

    // log(_username.toString() + " ini usernamenya");
    // log(_password.toString() + " ini passwordnya");
    // log(_role.toString() + " ini role nya");
    // log(_id.toString() + " ini id nya");

    // // await Future.delayed(const Duration(seconds: 3));
    // await EasyLoading.dismiss();

    // if (!_wrongPassword) {
    //   storage.remove('username');
    //   storage.remove('password');
    //   storage.remove('role');

    //   Get.offAllNamed(
    //     '/index',
    //     arguments: {
    //       "tap": 0,
    //       "history": [0],
    //     },
    //   );
    //   return;
    // }

    if (_role.toLowerCase() == "kurir") {
      Get.offAllNamed(
        '/kurirIndex',
        arguments: 1,
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
