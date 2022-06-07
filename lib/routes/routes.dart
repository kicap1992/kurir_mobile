import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:kurir/binding/beforeEnterBinding.dart';
import 'package:kurir/binding/kurirIndexBinding.dart';
import 'package:kurir/binding/kurirProfileBinding.dart';
// import 'package:kurir/binding/indexBinding.dart';
import 'package:kurir/binding/pendaftaranKurirBinding.dart';
import 'package:kurir/binding/pengirimIndexBinding.dart';
import 'package:kurir/pages/after_login/before_enter.dart';
import 'package:kurir/pages/after_login/kurir/profilePage.dart';
import 'package:kurir/pages/after_login/pengirim/pengirimProfilePage.dart';
import 'package:kurir/pages/before_login/daftar.dart';
import 'package:kurir/pages/before_login/login.dart';

import '../binding/loginBinding.dart';
import '../binding/pendaftaranPengirim.dart';
import '../binding/splashBinding.dart';
import '../pages/after_login/kurir/indexPage.dart';
import '../pages/after_login/pengirim/indexPage.dart';
import '../pages/before_login/index.dart';
import '../pages/before_login/pendaftaran_kurir.dart';
import '../pages/before_login/pendaftaran_pengirirm.dart';
import '../splashScreen.dart';

class Routes {
  List<GetPage<dynamic>> get routes {
    return [
      GetPage(
        name: '/splash',
        page: () => const SplashScreen(),
        binding: SplashBinding(),
        transition: Transition.native,
        transitionDuration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      ),
      GetPage(
        name: '/index',
        page: () => const IndexPage(),
        // binding: IndexBinding(),
        binding: LoginBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      ),
      GetPage(
        name: '/daftar',
        page: () => const DaftarPage(),
        binding: LoginBinding(),
        // binding: IndexBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      ),
      GetPage(
        name: '/login',
        page: () => const LoginPage(),
        binding: LoginBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      ),
      GetPage(
        name: '/pendaftaranKurir',
        page: () => const PendaftaranKurirPage(),
        binding: PendaftaranKurirBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      ),
      GetPage(
        name: '/pendaftaranPengirim',
        page: () => const PendaftaranPengirimPage(),
        binding: PendaftaranPengirimBinding(),
        transition: Transition.native,
        transitionDuration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      ),
      GetPage(
        name: '/beforeEnter',
        page: () => const BeforeEnterPage(),
        binding: BeforeEnterBinding(),
        transition: Transition.native,
        transitionDuration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      ),
      GetPage(
        name: '/kurirIndex',
        page: () => const KurirIndexPage(),
        binding: KurirIndexBinding(),
        transition: Transition.native,
        transitionDuration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      ),
      GetPage(
        name: '/profileKurir',
        page: () => const ProfileKurirPage(),
        binding: KurirProfileBinding(),
        transition: Transition.native,
        transitionDuration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      ),
      GetPage(
        name: '/pengirimIndex',
        page: () => const PengirimIndexPage(),
        binding: PengirimIndexBinding(),
        transition: Transition.native,
        transitionDuration: const Duration(seconds: 1),
      ),
      GetPage(
        name: '/profilePengirim',
        page: () => const PengirimProfilePage(),
        transition: Transition.native,
        transitionDuration: const Duration(seconds: 1),
      )
    ];
  }
}
