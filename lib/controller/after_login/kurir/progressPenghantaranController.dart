// ignore_for_file: file_names

import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

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
    dev.i("disini progress penghantaran bagian kurir berlaku");

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
                        "Mengambil Paket Pengiriman Dari Pengirim" ||
                    pengiriman.statusPengiriman != "Disahkan Kurir" ||
                    pengiriman.statusPengiriman != "Dalam Pengesahan Kurir")
                ? AllFunction.timeZoneAdd8(pengiriman.history![3].waktu)
                : null);
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
        _content = const _MenghantarPaketKirimanRichtext();
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
}

class _MenghantarPaketKirimanRichtext extends StatelessWidget {
  const _MenghantarPaketKirimanRichtext({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        const SizedBox(
          height: 10,
        ),
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
              children: const [
                _ExpandedButton(flex: 2, text: 'Terima Paket\nPengiriman'),
                Expanded(flex: 1, child: SizedBox()),
                _ExpandedButton(flex: 2, text: 'Rute Lokasi'),
              ],
            ),
          ),
      ],
    );
  }
}

class _ExpandedButton extends StatelessWidget {
  const _ExpandedButton({
    Key? key,
    required this.text,
    required this.flex,
  }) : super(key: key);

  final String text;
  final int flex;

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
            onPressed: () {},
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
