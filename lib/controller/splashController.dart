// ignore_for_file: file_names

import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kurir/api/notification_api.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SplashController extends GetxController {
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    NotificationApi.init(initScheduled: false);
    // connectToServer();
    Future.delayed(const Duration(milliseconds: 2500), () {
      dev.log('SplashController onInit');
      // Get.offAllNamed('/index');
      // goto to /index with argument tap : 0
      final _role = (storage.read('role') != null) ? storage.read('role') : '';

      if (_role == 'pengirim' || _role == 'kurir') {
        Get.offAllNamed('/beforeEnter');
      } else {
        Get.offAllNamed(
          '/index',
          arguments: {
            "tap": 0,
            "history": [0],
          },
        );
      }
    });
  }

  late Socket socket;
  void connectToServer() async {
    try {
      // Configure socket transports must be sepecified
      socket = io('http://192.168.43.125:3001/', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      // Connect to websocket
      socket.connect();

      // Handle socket events
      socket.on('connect', (_) => dev.log('connect asdasdsad: ${socket.id}'));
      socket.on('coba2', (_) {
        dev.log(_.toString());
        NotificationApi.showNotification(
          id: 1,
          title: 'Percobaan 1',
          body: _['message'],
          payload: 'Percobaan 1',
        );
      });

      socket.on('percobaan1', (_) {
        NotificationApi.showNotification(
          id: 1,
          title: 'Percobaan 1',
          body: _['message'],
          payload: 'Percobaan 1',
        );
      });

      // socket.on('typing', handleTyping);
      // socket.on('message', handleMessage);
      // socket.on('disconnect', (_) => dev.log('disconnect'));
      // socket.on('fromServer', (_) => dev.log(_));
      dev.log(socket.connected.toString() + " connected");
    } catch (e) {
      dev.log(e.toString());
      dev.log('tidak connect');
    }
  }
}
