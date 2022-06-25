// ignore_for_file: file_names
// ignore: unused_import
import 'dart:developer' as dev;
// import 'dart:isolate';
// import 'dart:math';
// import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:kurir/api/notification_api.dart';
// import 'package:socket_io_client/socket_io_client.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // // @override
  // void initState() {
  //   Workmanager().initialize(
  //     callbackDispatcher,
  //     isInDebugMode: true,
  //   );
  //   Workmanager().registerOneOffTask(
  //     "percobaan1",
  //     "percobaan1",
  //     initialDelay: Duration(seconds: 10),
  //   );
  //   Workmanager().registerPeriodicTask(
  //     "percobaan2",
  //     "percobaan2",
  //     frequency: Duration(minutes: 1),
  //   );
  //   Workmanager().registerPeriodicTask(
  //     "percobaan3",
  //     "percobaan3",
  //     frequency: Duration(seconds: 15),
  //     // initialDelay: Duration(seconds: 15),
  //   );
  //   super.initState();
  // }

  // @override
  // void initState() {
  //   NotificationApi.init(initScheduled: false, context: context);
  //   connectToServer();
  //   dev.log("ini initestatenya");
  //   super.initState();
  // }

  // late Socket socket;
  // void connectToServer() async {
  //   try {
  //     // Configure socket transports must be sepecified
  //     socket = io('http://192.168.43.125:3001/', <String, dynamic>{
  //       'transports': ['websocket'],
  //       'autoConnect': true,
  //     });

  //     // Connect to websocket
  //     socket.connect();

  //     // Handle socket events
  //     socket.on('connect', (_) => dev.log('connect asdasdsad: ${socket.id}'));
  //     socket.on('coba2', (_) => dev.log(_.toString()));
  //     socket.on('percobaan1', (_) {
  //       NotificationApi.showNotification(
  //         id: 1,
  //         title: 'Percobaan 1',
  //         body: _['message'],
  //         payload: 'Percobaan 1',
  //       );
  //     });

  //     // socket.on('typing', handleTyping);
  //     // socket.on('message', handleMessage);
  //     // socket.on('disconnect', (_) => dev.log('disconnect'));
  //     // socket.on('fromServer', (_) => dev.log(_));
  //     dev.log(socket.connected.toString() + " connected");
  //   } catch (e) {
  //     dev.log(e.toString());
  //     dev.log('tidak connect');
  //   }
  // }

  // Cancelable<void>? lastKnownOperation;

  // @override
  // void initState() {
  //   final task = Executor().execute(arg1: 10000, fun1: fib);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        //decoration to gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 199, 214, 234),
              Color.fromARGB(255, 104, 164, 164),
              Color.fromARGB(255, 4, 103, 103),
              Color.fromARGB(255, 2, 72, 72),
            ],
          ),
        ),
        //put logo image in center
        child: Center(
          child: Image.asset(
            'assets/logo.png',
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 2,
          ),
        ),
      ),
    );
  }
}

// int notif() {
//   var random = Random();
//   NotificationApi.showNotification(
//     id: random.nextInt(100),
//     title: 'Percobaan 1',
//     body: 'Percobaan 1',
//     payload: 'Percobaan 1',
//   );
//   return 1;
// }

// int fib(int n) {
//   if (n < 2) {
//     return n;
//   }

//   var random = Random();
//   NotificationApi.showNotification(
//     id: random.nextInt(100),
//     title: 'Percobaan 1',
//     body: 'Percobaan 1',
//     payload: 'Percobaan 1',
//   );
//   // dev.log((fib(n - 2) + fib(n - 1)).toString());
//   return fib(n - 2) + fib(n - 1);
// }

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     switch (task) {
//       case "percobaan1":
//         dev.log("ini di percobaan1");
//         NotificationApi.showNotification(
//           id: 1,
//           title: 'Percobaan 1',
//           body: "ini message",
//           payload: 'Percobaan 1',
//         );
//         Workmanager().(
//           "percobaan1",
//           "percobaan1",
//           initialDelay: Duration(seconds: 10),
//         );
//         break;
//       case "percobaan2":
//         dev.log("ini di percobaan2");
//         NotificationApi.showNotification(
//           id: 2,
//           title: 'Percobaan 2',
//           body: "ini message",
//           payload: 'Percobaan 2',
//         );
//         break;
//       case "percobaan3":
//         dev.log("ini di percobaan3");
//         NotificationApi.showNotification(
//           id: 3,
//           title: 'Percobaan 3',
//           body: "ini message",
//           payload: 'Percobaan 3',
//         );
//         break;
//     }

//     return Future.value(true);
//   });
// }

// The callback function should always be a top-level function.

