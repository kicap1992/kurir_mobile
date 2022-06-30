import 'dart:async';
import 'dart:io';
// import 'dart:isolate';

// import 'dart:developer' as dev;
// import 'dart:math';

// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:isolate_handler/isolate_handler.dart';
// import 'package:kurir/api/notification_api.dart';
import 'package:kurir/routes/routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:socket_io_client/socket_io_client.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// import 'package:worker_manager/worker_manager.dart';
// import 'api/beforeLoginAPI.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();

//   print("Handling a background message: ${message.messageId}");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeService();
  // await Executor().warmUp(log: true);
  // HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  await _configureLocalTimeZone();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  // dev.log('User granted permission: ${settings.authorizationStatus}');
  // // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');

  //   if (message.notification != null) {
  //     dev.log('Message also contained a notification: ${message.notification}');
  //   }
  // });

  // await AndroidAlarmManager.initialize();
  runApp(const MyApp());
  // FlutterBackgroundService().invoke("setAsBackground");
  // FlutterBackgroundService().invoke("setAsForeground");
  // final int helloAlarmID = 0;
  // await AndroidAlarmManager.periodic(
  //     const Duration(minutes: 1), helloAlarmID, printHello);
  // startForegroundService();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color.fromARGB(255, 2, 72, 72),
        statusBarColor: Color.fromARGB(255, 2, 72, 72),
      ),
    );
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: Routes().routes,
      initialRoute: '/splash',
      builder: EasyLoading.init(),
    );
  }
}

// // This function happens in the isolate.
// void entryPoint(Map<String, dynamic> context) {
//   // Calling initialize from the entry point with the context is
//   // required if communication is desired. It returns a messenger which
//   // allows listening and sending information to the main isolate.
//   final messenger = HandledIsolate.initialize(context);
//   connectToServer();
//   // Triggered every time data is received from the main isolate.
//   // messenger.listen((msg) async {
//   //   // Use a plugin to get some new value to send back to the main isolate.
//   //   final dir = await getApplicationDocumentsDirectory();
//   //   messenger.send(msg + dir.path);
//   // });
// }

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

// void printHello() {
//   final DateTime now = DateTime.now();
//   final int isolateId = Isolate.current.hashCode;
//   dev.log("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
//   NotificationApi.showNotification(
//     id: 2,
//     title: 'Percobaan 2',
//     body: "ini message",
//     payload: 'Percobaan 2',
//   );
//   // AndroidAlarmManager.c
// }

// void startForegroundService() async {
//   await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 5);
//   await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
//   await FlutterForegroundPlugin.startForegroundService(
//     holdWakeLock: true,
//     onStarted: () {
//       dev.log("Foreground on Started");
//     },
//     onStopped: () {
//       dev.log("Foreground on Stopped");
//     },
//     title: "Flutter Foreground Service",
//     content: "This is Content",
//     iconName: "ic_stat_hot_tub",
//   );
// }

// void globalForegroundService() {
//   var random = new Random();
//   NotificationApi.showNotification(
//     id: random.nextInt(100),
//     title: 'Percobaan 2',
//     body: "ini message",
//     payload: 'Percobaan 2',
//   );
//   dev.log("current datetime is ${DateTime.now()}");
// }

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will executed when app is in foreground or background in separated isolate
//       onStart: onStart,

//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: true,

//       // this will executed when app is in foreground in separated isolate
//       onForeground: onStart,

//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );
//   service.startService();
// }

// bool onIosBackground(ServiceInstance service) {
//   WidgetsFlutterBinding.ensureInitialized();
//   dev.log('FLUTTER BACKGROUND FETCH');

//   return true;
// }

// void onStart(ServiceInstance service) async {
//   // Only available for flutter 3.0.0 and later
//   // DartPluginRegistrant.ensureInitialized();

//   // For flutter prior to version 3.0.0
//   // We have to register the plugin manually

//   // SharedPreferences preferences = await SharedPreferences.getInstance();
//   // await preferences.setString("hello", "world");
//   // connectToServer();
//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       // connectToServer();
//       service.setAsForegroundService();
//       // connectToServer();
//     });

//     service.on('setAsBackground').listen((event) {
//       // connectToServer();
//       service.setAsBackgroundService();
//       // connectToServer();
//     });
//   }

//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

//   // {
//   //   if (service is AndroidServiceInstance) {
//   //     service.setForegroundNotificationInfo(
//   //       title: "My App Service",
//   //       content: "Updated at ${DateTime.now()}",
//   //     );
//   //     connectToServer();
//   //   }
//   // }

//   // bring to foreground
//   Timer.periodic(const Duration(seconds: 5), (timer) async {
//     // final hello = preferences.getString("hello");
//     dev.log("hello nya");

//     if (service is AndroidServiceInstance) {
//       service.setForegroundNotificationInfo(
//         title: "My App Service",
//         content: "Updated at ${DateTime.now()}",
//       );
//     }

//     /// you can see this log in logcat
//     dev.log('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
//     var random = new Random();
//     NotificationApi.showNotification(
//       id: random.nextInt(100),
//       title: 'Percobaan 2',
//       body: "ini message",
//       payload: 'Percobaan 2',
//     );

//     // test using external plugin
//     final deviceInfo = DeviceInfoPlugin();
//     String? device;
//     if (Platform.isAndroid) {
//       final androidInfo = await deviceInfo.androidInfo;
//       device = androidInfo.model;
//     }

//     if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       device = iosInfo.model;
//     }

//     service.invoke(
//       'update',
//       {
//         "current_date": DateTime.now().toIso8601String(),
//         "device": device,
//       },
//     );
//   });
// }

// // late Socket socket;
// void connectToServer() async {
//   try {
//     late Socket socket;
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
