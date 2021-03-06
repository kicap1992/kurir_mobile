import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../binding/beforeEnterBinding.dart';
import '../binding/infoPengirimanBinding.dart';
import '../binding/kurirIndexBinding.dart';
// import '../binding/kurirProfileBinding.dart';
import '../binding/loginBinding.dart';
import '../binding/pendaftaranKurirBinding.dart';
import '../binding/pendaftaranPengirim.dart';
import '../binding/pengirimIndexBinding.dart';
import '../binding/pengirimProfileBinding.dart';
import '../binding/progressPenghantaranKurirBinding.dart';
import '../binding/splashBinding.dart';
import '../pages/after_login/before_enter.dart';
import '../pages/after_login/kurir/indexPage.dart';
import '../pages/after_login/kurir/profilePage.dart';
import '../pages/after_login/kurir/progressPenghantaranPage.dart';
import '../pages/after_login/pengirim/indexPage.dart';
import '../pages/after_login/pengirim/infoPengirimanPage.dart';
import '../pages/after_login/pengirim/pengirimProfilePage.dart';
import '../pages/before_login/daftar.dart';
import '../pages/before_login/index.dart';
import '../pages/before_login/login.dart';
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
        children: [
          GetPage(
            name: '/progressPenghantaran',
            page: () => const ProgressPenghantaranPage(),
            binding: ProgressPenghantaranKurirBinding(),
            transition: Transition.native,
            transitionDuration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          ),
          GetPage(
            name: '/profileKurir',
            page: () => const ProfileKurirPage(),
            // binding: KurirProfileBinding(),
            transition: Transition.native,
            transitionDuration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          ),
        ],
      ),
      GetPage(
        name: '/pengirimIndex',
        page: () => const PengirimIndexPage(),
        binding: PengirimIndexBinding(),
        transition: Transition.native,
        transitionDuration: const Duration(seconds: 1),
        children: [
          GetPage(
            name: '/infoPengiriman',
            page: () => const InfoPengirimanPage(),
            binding: InfoPengirimanBinding(),
            transition: Transition.native,
            transitionDuration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          ),
          GetPage(
            name: '/profilePengirim',
            page: () => const PengirimProfilePage(),
            binding: PengirimProfileBinding(),
            transition: Transition.native,
            transitionDuration: const Duration(seconds: 1),
          )
        ],
      ),
    ];
  }
}
