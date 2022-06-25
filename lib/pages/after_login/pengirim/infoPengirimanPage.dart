// ignore_for_file: file_names, curly_braces_in_flow_control_structures
// ignore: unused_import
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurir/controller/after_login/pengirim/infoPengirimanController.dart';
import 'package:kurir/widgets/boxBackgroundDecoration.dart';
import 'package:kurir/widgets/ourContainer.dart';

class InfoPengirimanPage extends GetView<InfoPengirimanController> {
  const InfoPengirimanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String _harga_minimal = AllFunction.thousandsSeperator(
    //     controller.pengirimanModel.biaya!.biayaMinimal!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Pengiriman'),
        actions: [
          // create back button
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.offAllNamed(
                '/pengirimIndex',
                arguments: {
                  'tap': 1,
                },
              );
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Get.offAllNamed(
            '/pengirimIndex',
            arguments: {
              'tap': 1,
            },
          );
          return false;
        },
        child: BoxBackgroundDecoration(
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
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/loading.gif',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    controller.pengirimanModel.fotoPengiriman!,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        readOnly: true,
                        initialValue:
                            controller.pengirimanModel.statusPengiriman,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Colors.blue,
                          ),
                          labelText: 'Status Pengiriman',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        readOnly: true,
                        initialValue: controller.pengirimanModel.namaPenerima,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Colors.blue,
                          ),
                          labelText: 'Nama Penerima',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        readOnly: true,
                        initialValue:
                            controller.pengirimanModel.noTelponPenerima,
                        // maxLength: 13,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Colors.blue,
                          ),
                          labelText: 'No Telpon Penerima',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        readOnly: true,
                        initialValue: controller.pengirimanModel.alamatPenerima,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        // minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Alamat Penerima',
                          labelStyle: const TextStyle(
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        readOnly: true,
                        initialValue: controller.pengirimanModel.kurir!.nama,
                        // maxLength: 13,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Colors.blue,
                          ),
                          suffix: GestureDetector(
                            onTap: () {
                              // dev.log("message");
                              if (controller.loadingMaps.value)
                                controller.show_kurir_dialog();
                            },
                            child: const Icon(
                              Icons.info_outline_rounded,
                              color: Colors.blue,
                            ),
                          ),
                          labelText: 'Nama Kurir',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: controller.distance_travel_controller,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Colors.blue,
                          ),
                          labelText: 'Jarak Pengiriman',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              if (controller.loadingMaps.value)
                                controller.show_maps_dialog();
                            },
                            child: const Icon(
                              Icons.info_outline_rounded,
                              color: Colors.blue,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: controller.price_controller,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Colors.blue,
                          ),
                          labelText: 'Harga Pengiriman',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      (controller.pengirimanModel.statusPengiriman ==
                              "Dalam Pengesahan Kurir")
                          ? Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                child: const Text("Batalkan Pengiriman"),
                                onPressed: () {},
                              ),
                            )
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
