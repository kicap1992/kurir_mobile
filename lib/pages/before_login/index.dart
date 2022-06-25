import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurir/controller/before_login/loginController.dart';
// import 'package:kurir/controller/before_login/indexController.dart';

import '../../widgets/appbar.dart';
import '../../widgets/boxBackgroundDecoration.dart';

// class IndexPage extends GetView<IndexController> {
class IndexPage extends GetView<LoginController> {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: const AppBarWidget(
          header: "Halaman Utama",
          autoLeading: true,
        ),
      ),
      body: const DoubleBackToCloseApp(
        child: BoxBackgroundDecoration(
          child: Center(
            child: Text(
              'Hompage',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
        snackBar: SnackBar(
          content: Text('Tekan tombol kembali lagi untuk keluar'),
        ),
      ),
      bottomNavigationBar: Obx(() => controller.bottomNavigationBar()),
    );
  }
}
