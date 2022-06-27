// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:socket_io_client/socket_io_client.dart';

import 'pengaturanController.dart';
import 'pengirimanController.dart';

class KurirIndexController extends GetxController {
  late Socket socket;

  final Rx<int> _indexTap = 0.obs; // bottom navigation index tap

  PageController pageController =
      PageController(initialPage: 0, keepPage: true);

  pageChanged(int index) async {
    _indexTap.value = index;
    switch (index) {
      case 0:
        final ctrl = Get.put<PengaturanKurirController>(
          PengaturanKurirController(),
        );
        ctrl.onInit();

        // Get.put(PengaturanKurirController());

        break;
      case 1:
        final ctrl = Get.put<PengirimanKurirController>(
          PengirimanKurirController(),
        );
        ctrl.onInit();

        // Get.put(PengaturanKurirController());

        break;
      default:
    }
  }

  @override
  void onInit() {
    log('KurirIndexController onInit');
    // final ctrl = Get.put(PengaturanKurirController());
    // ctrl.onInit();
    connectToServer();
    super.onInit();
  }

  BottomNavigationBar bottomNavigationBar(context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Pengaturan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: 'Pengiriman',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.app_registration),
          label: 'Log History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
      currentIndex: _indexTap.value,
      selectedItemColor: const Color.fromARGB(255, 2, 72, 72),
      unselectedItemColor: const Color.fromARGB(255, 199, 214, 234),
      onTap: (index) => _onItemTapped(index, context),
    );
  }

  _onItemTapped(int index, BuildContext context) {
    log("sini on item tapped");
    _indexTap.value = index;
    if (index == 3) {
      Get.offAllNamed('/kurirIndex/profileKurir');
    }
    FocusScope.of(context).unfocus();
    // Get.delete<PengaturanKurirController>();

    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void connectToServer() async {
    log("sini connect to socket io");
    try {
      // Configure socket transports must be sepecified
      socket = io('http://192.168.43.125:3001/', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      // Connect to websocket
      socket.connect();
      socket.onConnect((_) {
        log("sini connected");
        // socket.emit('join', 'kurir');
      });
      // Connect to websocket
      // socket.connect();
      socket.on('connect', (_) => log('connect asdasdsad: ${socket.id}'));
      socket.on('coba1', (_) => log(_.toString() + " ini coba2"));

      log(socket.connected.toString());
    } catch (e) {
      log(e.toString());
      log('tidak connect');
    }
  }

  // onWillpop() async {
  //   log("ini onWillpop");
  //   return false;
  // }
}
