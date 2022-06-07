// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurir/controller/after_login/pengirim/kirimBarangController.dart';
import 'package:kurir/controller/after_login/pengirim/logKirimanController.dart';

class PengirimIndexController extends GetxController {
  dynamic argumicData = Get.arguments;

  final Rx<int> _indexTap = 0.obs; // bottom navigation index tap

  late PageController pageController;

  pageChanged(int index) async {
    // Get.delete<KirimBarangController>();
    if (index == 0) {
      var _init = Get.put(KirimBarangController());
      _init.onInit();
      // Get.lazyPut<KirimBarangController>(() => KirimBarangController());
    }
    if (index == 1) {
      var _init = Get.put(LogKirimanController());
      _init.onInit();
    }

    _indexTap.value = index;
  }

  @override
  void onInit() {
    log("sini on init pengirim index");
    _indexTap.value = argumicData['tap'] ?? 0;
    pageController =
        PageController(initialPage: _indexTap.value, keepPage: true);
    super.onInit();
  }

  BottomNavigationBar bottomNavigationBar(context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.motorcycle_rounded),
          label: 'Kirim Barang',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_rounded),
          label: 'Log Kiriman',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_rounded),
          label: 'List Kurir',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
      currentIndex: _indexTap.value,
      selectedItemColor: const Color.fromARGB(255, 148, 183, 229),
      onTap: (index) => _onItemTapped(index, context),
    );
  }

  _onItemTapped(int index, BuildContext context) {
    log("sini on item tapped");
    if (index == 3) {
      Get.offAllNamed('/profilePengirim');
    }

    _indexTap.value = index;

    FocusScope.of(context).unfocus();
    // Get.delete<PengaturanKurirController>();

    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }
}
