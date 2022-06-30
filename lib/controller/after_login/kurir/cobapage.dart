import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:scan/scan.dart';

class CobaPageKurir extends StatefulWidget {
  const CobaPageKurir({Key? key}) : super(key: key);

  @override
  State<CobaPageKurir> createState() => _CobaPageKurirState();
}

class _CobaPageKurirState extends State<CobaPageKurir> {
  final dev = Logger();

  ScanController controller = ScanController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coba Page Kurir'),
      ),
      body: SizedBox(
        width: 250, // custom wrap size
        height: 250,
        child: ScanView(
          controller: controller,
// custom scan area, if set to 1.0, will scan full area
          scanAreaScale: .7,
          scanLineColor: Colors.green.shade400,
          onCapture: (data) {
            // do something
            if (data == "heheheh") {
              // show snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Scan berhasil'),
                  duration: const Duration(days: 365),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () {
                      // do something
                      controller.toggleTorchMode();
                      controller.resume();
                    },
                  ),
                ),
              );
            } else {
              controller.resume();
            }
          },
        ),
      ),
    );
  }
}
