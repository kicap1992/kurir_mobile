// ignore_for_file: file_names, curly_braces_in_flow_control_structures
// ignore: unused_import
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurir/controller/after_login/pengirim/infoPengirimanController.dart';
import 'package:kurir/widgets/boxBackgroundDecoration.dart';
import 'package:kurir/widgets/ourContainer.dart';

import '../../../widgets/appbar.dart';

class InfoPengirimanPage extends GetView<InfoPengirimanController> {
  const InfoPengirimanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String _harga_minimal = AllFunction.thousandsSeperator(
    //     controller.pengirimanModel.biaya!.biayaMinimal!);
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(
          '/pengirimIndex',
          arguments: {
            'tap': 1,
          },
        );
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
          child: AppBarWidget(
            header: "Info Pengiriman",
            autoLeading: true,
            actions: [
              // create back button
              if (controller.pengirimanModel.statusPengiriman ==
                  'Mengambil Paket Pengiriman Dari Pengirim')
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.qr_code_2_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

              if (controller.pengirimanModel.statusPengiriman ==
                  'Mengambil Paket Pengiriman Dari Pengirim')
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.motorcycle_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        body: BoxBackgroundDecoration(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                OurContainer(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.show_foto_pengiriman();
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: _FotoWidget(controller: controller),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      _ThisTextFormField(
                        text: (controller.pengirimanModel.statusPengiriman ==
                                'Mengambil Paket Pengiriman Dari Pengirim')
                            ? 'Kurir Dalam Perjalanan Mengmabil Paket'
                            : controller.pengirimanModel.statusPengiriman!,
                        maxLines: 2,
                        label: "Status Pengiriman",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      _ThisTextFormField(
                          text: controller.pengirimanModel.namaPenerima!,
                          label: 'Nama Penerima'),
                      const SizedBox(
                        height: 15,
                      ),
                      _ThisTextFormField(
                          text: controller.pengirimanModel.noTelponPenerima!,
                          label: 'No Telpon Penerima'),
                      const SizedBox(
                        height: 15,
                      ),
                      _ThisTextFormField(
                          text: controller.pengirimanModel.alamatPenerima!,
                          label: 'Alamat Penerima',
                          maxLines: 4),
                      const SizedBox(
                        height: 15,
                      ),
                      _ThisTextFormField(
                        text: controller.pengirimanModel.kurir!.nama!,
                        label: 'Nama Kurir',
                        suffix: GestureDetector(
                          onTap: () {
                            // dev.log("message");
                            if (controller.loadingMaps.value)
                              controller.show_kurir_dialog();
                          },
                          child: const Icon(
                            Icons.info_outline_rounded,
                            color: Color.fromARGB(255, 104, 164, 164),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      _ThisTextFormField(
                        controller: controller.distance_travel_controller,
                        label: 'Jarak Pengiriman',
                        suffix: GestureDetector(
                          onTap: () {
                            if (controller.loadingMaps.value)
                              controller.show_maps_dialog();
                          },
                          child: const Icon(
                            Icons.info_outline_rounded,
                            color: Color.fromARGB(255, 104, 164, 164),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      _ThisTextFormField(
                          label: 'Harga Pengiriman',
                          controller: controller.price_controller),
                      const SizedBox(
                        height: 15,
                      ),
                      (controller.pengirimanModel.statusPengiriman ==
                              "Dalam Pengesahan Kurir")
                          ? Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text("Batalkan Pengiriman"),
                                onPressed: () {},
                              ),
                            )
                          : (controller.pengirimanModel.statusPengiriman ==
                                  "Mengambil Paket Pengiriman Dari Pengirim")
                              ? const _ButtonKurirDalamPerjalan()
                              : const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonKurirDalamPerjalan extends StatelessWidget {
  const _ButtonKurirDalamPerjalan({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 2, 72, 72),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Scan QR Code"),
            onPressed: () {},
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 2, 72, 72),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Lokasi Kurir"),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _FotoWidget extends StatelessWidget {
  const _FotoWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final InfoPengirimanController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        image: const DecorationImage(
          image: AssetImage(
            'assets/loading.gif',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: (controller.pengirimanModel.fotoPengiriman != null)
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: NetworkImage(
                    controller.pengirimanModel.fotoPengiriman!,
                  ),
                  fit: BoxFit.fill,
                  onError: (object, stacktrace) {
                    // print(e);
                  },
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}

class _ThisTextFormField extends StatelessWidget {
  const _ThisTextFormField({
    Key? key,
    this.text,
    this.maxLines = 1,
    required this.label,
    this.suffix,
    this.controller,
  }) : super(key: key);

  final String? text;
  final String label;
  final int maxLines;
  final Widget? suffix;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: true,
      initialValue: text,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 4, 103, 103),
        ),
        labelText: label,
        suffix: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 2, 72, 72),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 2, 72, 72),
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 104, 164, 164),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 2, 72, 72),
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
      ),
    );
  }
}
