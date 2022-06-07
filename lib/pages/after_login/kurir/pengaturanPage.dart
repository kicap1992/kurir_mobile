// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurir/controller/after_login/kurir/pengaturanController.dart';
import 'package:kurir/widgets/focusToTextFormField.dart';
import 'package:kurir/widgets/ourContainer.dart';
import 'package:kurir/widgets/thousandSeparator.dart';

import '../../../widgets/boxBackgroundDecoration.dart';

class PengaturanKurirPage extends GetView<PengaturanKurirController> {
  const PengaturanKurirPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // controller.onInit();
    return Scaffold(
      body: BoxBackgroundDecoration(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/logo.png',
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width * 0.30,
              ),
              OurContainer(
                child: Form(
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: controller.formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 5),
                      const Text(
                        'Pengaturan Biaya Pengiriman',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: controller.minimalBiayaPengirimanFocusNode,
                        child: TextFormField(
                          // initialValue: 700.toString(),
                          controller:
                              controller.minimalBiayaPengirimanController,
                          focusNode: controller.minimalBiayaPengirimanFocusNode,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          inputFormatters: [ThousandsSeparatorInputFormatter()],
                          decoration: InputDecoration(
                            // suffix: ,
                            // suffixText: ' / kg',
                            // put suffixText before prefixText
                            prefixText: 'Rp . ',

                            hintText: 'Minimal Biaya Pengiriman',
                            labelText: 'Minimal Biaya Pengiriman',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Minimal Biaya Pengiriman tidak boleh kosong';
                            }

                            if (controller.removeComma(controller
                                    .maksimalBiayaPengirimanController.text) <
                                controller.removeComma(value)) {
                              return 'Minimal Biaya Pengiriman tidak boleh lebih besar dari Maksimal Biaya Pengiriman';
                            }

                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: controller.maksimalBiayaPengirimanFocusNode,
                        child: TextFormField(
                          controller:
                              controller.maksimalBiayaPengirimanController,
                          focusNode:
                              controller.maksimalBiayaPengirimanFocusNode,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          inputFormatters: [ThousandsSeparatorInputFormatter()],
                          decoration: InputDecoration(
                            // suffix: ,
                            // suffixText: ' / kg',
                            // put suffixText before prefixText
                            prefixText: 'Rp . ',

                            hintText: 'Maksimal Biaya Pengiriman',
                            labelText: 'Maksimal Biaya Pengiriman',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Maksimal Biaya Pengiriman tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: controller.biayaPerKiloFocusNode,
                        child: TextFormField(
                          controller: controller.biayaPerKiloController,
                          focusNode: controller.biayaPerKiloFocusNode,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          inputFormatters: [ThousandsSeparatorInputFormatter()],
                          decoration: InputDecoration(
                            // suffix: ,
                            suffixText: ' / km',
                            // put suffixText before prefixText
                            prefixText: 'Rp . ',

                            hintText: 'Biaya Per Kilometer',
                            labelText: 'Biaya Per Kilometer',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Biaya Per Kilometer tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // log()
                          if (controller.formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            // create alert dialog
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Konfirmasi'),
                                  content: Text(controller.status.value ==
                                          'Simpan'
                                      ? 'Informasi Biaya Pengiriman akan disimpan '
                                      : 'Info Biaya Pengiriman akan diubah '),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text('Tidak'),
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            Colors.red[400], //background color
                                        // onPrimary: Colors.black, //ripple color
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text('Ya'),
                                      onPressed: () {
                                        controller.simpan();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Obx(() => Text(
                            controller.status.value == 'Simpan'
                                ? 'Simpan'
                                : 'Ubah')),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: "Pengaturan",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.history),
      //       label: "Log History",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.arrow_back),
      //       label: "Pengiriman",
      //     ),
      //   ],
      //   currentIndex: 0,
      //   selectedItemColor: const Color.fromARGB(255, 148, 183, 229),
      // ),
    );
  }
}
