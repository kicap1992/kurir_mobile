import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class BeforeEnterPage extends StatelessWidget {
  const BeforeEnterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.close),
      //       onPressed: () => Get.offAllNamed(
      //         '/index',
      //         arguments: {
      //           "tap": 0,
      //           "history": [0],
      //         },
      //       ),
      //     ),
      //   ],
      // ),
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
