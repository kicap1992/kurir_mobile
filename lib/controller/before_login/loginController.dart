// ignore_for_file: file_names, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../api/beforeLoginAPI.dart';

class LoginController extends GetxController {
  var formKey = GlobalKey<FormState>();

  dynamic argumicData = Get.arguments; // get argument from routes.
  final Rx<int> _indexTap = 0.obs; // bottom navigation index tap
  late final RxList _historyIndex = [].obs; // navigation history

  //  for login page
  List<String> role = ['Kurir', 'Pengirim'];
  final Rx<String> selectedRole = 'Kurir'.obs;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool passwordVisible = false.obs;
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void onInit() {
    log("sini on init");
    // print(argumicData);
    _indexTap.value = argumicData['tap'];
    // push to _historyIndex
    _historyIndex.value = argumicData['history'];
    log(_historyIndex.value.toString() + " ini history");
    // print(_historyIndex.length.toString() + " ini panjangnya di oninit");

    // BackButtonInterceptor.add(myInterceptor);
    super.onInit();
  }

  @override
  void dispose() {
    formKey.currentState!.dispose();
    super.dispose();
  }

  // back button history navigation
  Future<bool> willPopScopeWidget() async {
    log('sini willpopscope');
    log(_historyIndex.toString() + ' ini history listnya');
    final int lastIndex = _historyIndex[_historyIndex.length - 2];
    log("sini last index " + lastIndex.toString());
    late String _routeName;
    switch (lastIndex) {
      case 0:
        _routeName = '/index';
        break;
      case 1:
        _routeName = '/login';
        break;
      case 2:
        _routeName = '/daftar';
        break;
    }
    // log("ini route name " + _routeName);
    _historyIndex.removeLast();
    selectedRole.value = role[0];
    usernameController.clear();
    passwordController.clear();
    _indexTap.value = lastIndex;
    // Get.back();
    // await Get.delete<LoginController>();
    Get.offAllNamed(
      _routeName,
      arguments: {
        "tap": lastIndex,
        "history": _historyIndex.value,
      },
    );

    return false;
  }

  // bottom navigation index tapping
  void _onItemTapped(int index) async {
    if (index == _indexTap.value) return;
    _indexTap.value = index;
    late String _routeName;
    switch (index) {
      case 0:
        _routeName = '/index';
        break;
      case 1:
        _routeName = '/login';
        break;
      case 2:
        _routeName = '/daftar';
        break;
    }

    // Get.delete<LoginController>();
    log("sini on item tapped");
    if (index == 0) {
      _historyIndex.clear();
      _historyIndex.add(0);
    } else {
      _historyIndex.add(index);
    }

    //clear all the input in login before navigate to another page
    selectedRole.value = role[0];
    usernameController.clear();
    passwordController.clear();

    // await Get.delete<LoginController>();
    await Get.offAllNamed(
      _routeName,
      arguments: {
        "tap": index,
        "history": _historyIndex.value,
      },
    );
    // Get.toNamed('/second');
  }

  void login() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    log("sini proses login");
    late bool _wrongPassword;
    late String _message;

    String _username = usernameController.text;
    String _password = passwordController.text;
    String _role = selectedRole.value;

    log(_username.toString() + " ini usernamenya");
    log(_password.toString() + " ini passwordnya");
    log(_role.toString() + " ini role nya");

    Map<String, dynamic> _data = await BeforeLoginApi.log_in_user(
        _username, generateMd5(_password), _role.toLowerCase());

    await EasyLoading.dismiss();

    // log(_data.toString() + " ini data");
    switch (_data['status']) {
      case 200:
        _wrongPassword = true;
        _message = _data['message'];
        break;
      case 400:
        _wrongPassword = false;
        _message = _data['message'];
        usernameFocusNode.requestFocus();
        break;
      default:
        _wrongPassword = false;
        _message = _data['message'];
        break;
    }

    if (!_wrongPassword) {
      // focus to username
      // usernameFocusNode.requestFocus();
      // put validator in username

      Get.snackbar(
        "Error",
        _message,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    } else {
      Get.snackbar(
        "Sukses Login",
        _message,
        icon: const Icon(
          Icons.check,
          color: Colors.green,
        ),
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );

      // await 2 second then navigate to index page
      await Future.delayed(const Duration(milliseconds: 1500));
      Get.offAllNamed('/beforeEnter');
    }
  }

  // for input checker
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  // bottom navigation bar
  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: 'Login',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.app_registration),
          label: 'Daftar',
        ),
      ],
      currentIndex: _indexTap.value,
      selectedItemColor: const Color.fromARGB(255, 148, 183, 229),
      onTap: _onItemTapped,
    );
  }
}
