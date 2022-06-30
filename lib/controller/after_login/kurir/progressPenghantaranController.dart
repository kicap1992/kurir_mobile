// ignore_for_file: file_names

import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:scan/scan.dart';

import '../../../api/kurirApi.dart';
import '../../../function/allFunction.dart';
import '../../../models/pengirimimanModel.dart';

class ProgressPenghantaranControllerKurir extends GetxController {
  final dev = Logger();

  Rx<String> text = "heheh".obs;
  String id = Get.arguments;
  Rx<Widget> enhanceStepContainer = Container(
    height: Get.height * 0.6,
    width: double.infinity,
    color: Colors.transparent,
    child: const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    ),
  ).obs;
  RxInt currentStep = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // text.value = "heheh222";
    dev.i(id);

    // future 3 sec

    getData();
  }

  void getData() async {
    final _api = Get.put(KurirApi());

    Map<String, dynamic> _data = await _api.detailPengiriman(id);
    if (_data["status"] == 200) {
      final PengirimanModel _pengiriman =
          PengirimanModel.fromJson(_data["data"]);
      List<EnhanceStep> _step = [];
      var _history = _data["data"]["history"];
      currentStep.value = _history.length - 1;
      for (var i = 0; i < _history.length; i++) {
        final History _historyItem = History.fromJson(_history[i]);
        _step.add(
          _enhanceStepChild(_historyItem, _pengiriman),
        );
      }

      enhanceStepContainer.value = Container(
        height: Get.height * 0.6,
        width: double.infinity,
        color: Colors.transparent,
        child: _EnhanceStepper(step: _step, currentStep: currentStep),
      );
    }
  }

  EnhanceStep _enhanceStepChild(History data, PengirimanModel pengiriman) {
    late Icon _icon;
    late Widget _title, _content;
    Widget _subtitle = Text(
      AllFunction.timeZoneAdd8(data.waktu),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
    );

    switch (data.statusPengiriman) {
      case "Dalam Pengesahan Kurir":
        _icon = const Icon(
          Icons.info_outline,
          color: Colors.white,
          size: 30,
        );
        _title = const Text(
          "Dalam Pengesahan Kurir",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        );
        _content = Text(
          "Pengirim melakukan pengiriman dan menunggu pengesahan kurir pada waktu ${AllFunction.timeZoneAdd8(data.waktu)}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        );
        break;
      case "Disahkan Kurir":
        _icon = const Icon(
          Icons.check_box,
          color: Colors.white,
          size: 30,
        );
        _title = const Text(
          "Disahkan Kurir",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        );
        _content = Text(
          "Kurir mengkonfirmasi pengiriman pada waktu ${AllFunction.timeZoneAdd8(data.waktu)}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        );
        break;
      case "Mengambil Paket Pengiriman Dari Pengirim":
        _icon = const Icon(
          Icons.motorcycle_outlined,
          color: Colors.white,
          size: 30,
        );
        _title = const Text(
          "Dalam Perjalanan Mengambil Paket Pengiriman Dari Pengirim",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        );
        _content = _MengambilPaketKirimanRichtext(
          terima: (pengiriman.statusPengiriman ==
                  "Mengambil Paket Pengiriman Dari Pengirim")
              ? true
              : false,
          waktu: (pengiriman.statusPengiriman !=
                      "Mengambil Paket Pengiriman Dari Pengirim" &&
                  pengiriman.statusPengiriman != "Disahkan Kurir" &&
                  pengiriman.statusPengiriman != "Dalam Pengesahan Kurir")
              ? AllFunction.timeZoneAdd8(pengiriman.history![3].waktu)
              : null,
        );
        break;
      case "Menghantar Paket Pengiriman Ke Penerima":
        _icon = const Icon(
          Icons.handshake_outlined,
          color: Colors.white,
          size: 30,
        );
        _title = const Text(
          "Dalam Perjalanan Menghantar Paket Pengiriman Ke Penerima",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        );
        _content = _MenghantarPaketKirimanRichtext(
            terima: (pengiriman.statusPengiriman ==
                    "Menghantar Paket Pengiriman Ke Penerima")
                ? true
                : false,
            waktu: (pengiriman.statusPengiriman !=
                        "Menghantar Paket Pengiriman Ke Penerima" &&
                    pengiriman.statusPengiriman !=
                        "Mengambil Paket Pengiriman Dari Pengirim" &&
                    pengiriman.statusPengiriman != "Disahkan Kurir" &&
                    pengiriman.statusPengiriman != "Dalam Pengesahan Kurir")
                ? AllFunction.timeZoneAdd8(pengiriman.history![4].waktu)
                : null);
        break;
      case "Paket Diterima Oleh Penerima":
        _icon = const Icon(
          Icons.person_pin_sharp,
          color: Colors.white,
          size: 30,
        );
        _title = const Text(
          "Paket telah diterima oleh penerima",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        );
        _content =
            _PaketDiterimaRichtext(waktu: AllFunction.timeZoneAdd8(data.waktu));
        break;
    }

    return EnhanceStep(
      icon: _icon,
      title: _title,
      subtitle: _subtitle,
      content: _content,
      isActive: true,
    );
  }

  Future<void> onQRViewCreated(BuildContext context, String aksinya) async {
    Get.dialog(
      QRcodeScannerWidget(
        title: aksinya,
      ),
    );
  }
}

class QRcodeScannerWidget extends StatefulWidget {
  const QRcodeScannerWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<QRcodeScannerWidget> createState() => _QRcodeScannerWidgetState();
}

class _QRcodeScannerWidgetState extends State<QRcodeScannerWidget> {
  // final ProgressPenghantaranControllerKurir c =
  ScanController qRcontroller = ScanController();

  final dev = Logger();
  bool _isScanning = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 199, 214, 234),
      title: Text("Scan QRCode ${widget.title}"),
      content: SizedBox(
        width: 250, // custom wrap size
        height: 250,
        child: ScanView(
          controller: qRcontroller,
          // custom scan area, if set to 1.0, will scan full area
          scanAreaScale: .8,
          scanLineColor: Colors.green.shade400,
          onCapture: (data) {
            // do something
            // dev.i(data);
            if (data == "hehehe") {
              // Get.back();
              setState(() {
                _isScanning = false;
              });
              dev.i("scanner berhasil");
            } else {
              setState(() {
                _isScanning = false;
              });
              qRcontroller.resume();
            }
          },
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: const Color.fromARGB(255, 2, 72, 72),
          ),
          onPressed: () {
            if (_isScanning) {
              qRcontroller.pause();
            } else {
              qRcontroller.resume();
            }
            setState(() {
              _isScanning = !_isScanning;
            });
          },
          child: Text(_isScanning ? "Pause" : "Resume"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: const Color.fromARGB(255, 2, 72, 72),
          ),
          onPressed: () {
            qRcontroller.toggleTorchMode();
          },
          child: const Text("Flash"),
        ),
      ],
    );
  }
}

class _PaketDiterimaRichtext extends StatelessWidget {
  const _PaketDiterimaRichtext({
    Key? key,
    required this.waktu,
  }) : super(key: key);

  final String waktu;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        children: [
          const TextSpan(
              text:
                  "Paket diterima oleh penerima, penerima mengkonfirmasi penerimaan paket pada waktu \n"),
          TextSpan(
            text: waktu,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenghantarPaketKirimanRichtext extends StatelessWidget {
  const _MenghantarPaketKirimanRichtext({
    Key? key,
    required this.terima,
    this.waktu,
  }) : super(key: key);

  final bool terima;
  final String? waktu;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (terima)
          RichText(
            textAlign: TextAlign.justify,
            text: const TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              children: [
                TextSpan(
                    text:
                        "Paket diterima dari pengirim. Dalam perjalanan menghantar paket ke penerima. Klik "),
                TextSpan(
                  text: "'Terima Paket Pengiriman' ",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "jika sampai ke lokasi penerima & scan "),
                TextSpan(
                  text: "QRcode ",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "yang ada pada aplikasi pengirim. Klik "),
                TextSpan(
                  text: "'Rute Lokasi' ",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "untuk melihat rute lokasi penerima."),
              ],
            ),
          ),
        if (!terima)
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              children: [
                const TextSpan(
                    text:
                        "Paket diterima dari pengirim. Telah diterima oleh penerima pada waktu \n"),
                TextSpan(
                  text: waktu,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        if (terima)
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _ExpandedButton(flex: 2, text: 'Serahkan Paket\nPengiriman'),
                Expanded(flex: 1, child: SizedBox()),
                _ExpandedButton(flex: 2, text: 'Rute Lokasi'),
              ],
            ),
          ),
      ],
    );
  }
}

class _MengambilPaketKirimanRichtext extends StatelessWidget {
  _MengambilPaketKirimanRichtext({
    Key? key,
    required this.terima,
    this.waktu,
  }) : super(key: key);

  final bool terima;
  final String? waktu;

  final dev = Logger();
  final ProgressPenghantaranControllerKurir controller =
      Get.put<ProgressPenghantaranControllerKurir>(
          ProgressPenghantaranControllerKurir());

  @override
  Widget build(BuildContext context) {
    dev.i("terima: $terima");
    return Column(
      children: [
        if (terima)
          RichText(
            textAlign: TextAlign.justify,
            text: const TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              children: [
                TextSpan(
                    text:
                        "Dalam perjalanan mengambil paker dari pengirim. Klik "),
                TextSpan(
                  text: "'Terima Paket Pengiriman' ",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "jika sampai ke lokasi pengirim & scan "),
                TextSpan(
                  text: "QRcode ",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "yang ada pada aplikasi pengirim. Klik "),
                TextSpan(
                  text: "'Rute Lokasi' ",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: "untuk melihat rute lokasi pengirim."),
              ],
            ),
          ),
        if (!terima)
          Text(
            "Paket telah diterima dari pengirim.\nPaket diterima pada waktu $waktu\nDalam perjalanan menghantar paket ke penerima.",
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        if (terima)
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ExpandedButton(
                  flex: 2,
                  text: 'Terima Paket\nPengiriman',
                  onPressed: () {
                    dev.i("terima paket");
                    controller.onQRViewCreated(context, "Pengirim");
                    // Get.to(CobaPageKurir());
                  },
                ),
                const Expanded(flex: 1, child: SizedBox()),
                const _ExpandedButton(flex: 2, text: 'Rute Lokasi'),
              ],
            ),
          ),
      ],
    );
  }
}

class _ExpandedButton extends StatelessWidget {
  const _ExpandedButton(
      {Key? key, required this.text, required this.flex, this.onPressed})
      : super(key: key);

  final String text;
  final int flex;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: FittedBox(
        child: SizedBox(
          width: 100,
          height: 35,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              if (onPressed != null) onPressed!();
            },
            child: FittedBox(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color.fromARGB(255, 2, 72, 72),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EnhanceStepper extends StatelessWidget {
  const _EnhanceStepper({
    Key? key,
    required List<EnhanceStep> step,
    required this.currentStep,
  })  : _step = step,
        super(key: key);

  final List<EnhanceStep> _step;
  final RxInt currentStep;

  @override
  Widget build(BuildContext context) {
    return GetX<ProgressPenghantaranControllerKurir>(
      init: ProgressPenghantaranControllerKurir(),
      builder: (c) {
        return EnhanceStepper(
          stepIconSize: 30,
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return const SizedBox();
          },
          type: StepperType.vertical,
          steps: _step,
          currentStep: c.currentStep.value,
          onStepTapped: (int index) {
            c.currentStep.value = index;
          },
        );
      },
    );
  }
}
