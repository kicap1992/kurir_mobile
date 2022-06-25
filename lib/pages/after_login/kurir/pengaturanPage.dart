// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/after_login/kurir/pengaturanController.dart';
import '../../../widgets/boxBackgroundDecoration.dart';
import '../../../widgets/focusToTextFormField.dart';
import '../../../widgets/ourContainer.dart';
import '../../../widgets/thousandSeparator.dart';

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
                        child: _PengaturanTextFormField(
                          controller:
                              controller.minimalBiayaPengirimanController,
                          hintText: 'Minimal Biaya Pengiriman',
                          labelText: 'Minimal Biaya Pengiriman',
                          focusNode: controller.minimalBiayaPengirimanFocusNode,
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
                        child: _PengaturanTextFormField(
                          controller:
                              controller.maksimalBiayaPengirimanController,
                          hintText: 'Maksimal Biaya Pengiriman',
                          labelText: 'Maksimal Biaya Pengiriman',
                          focusNode:
                              controller.maksimalBiayaPengirimanFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Maksimal Biaya Pengiriman tidak boleh kosong';
                            }

                            if (controller.removeComma(controller
                                    .maksimalBiayaPengirimanController.text) <
                                controller.removeComma(value)) {
                              return 'Maksimal Biaya Pengiriman tidak boleh lebih besar dari Maksimal Biaya Pengiriman';
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
                        child: _PengaturanTextFormField(
                          controller: controller.biayaPerKiloController,
                          hintText: 'Biaya Per Kilometer',
                          labelText: 'Biaya Per Kilometer',
                          focusNode: controller.biayaPerKiloFocusNode,
                          suffixText: ' / km',
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
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 2, 72, 72),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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
                                        primary: const Color.fromARGB(255, 104,
                                            164, 164), //background color
                                        // onPrimary: Colors.black, //ripple color
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text('Ya'),
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color.fromARGB(
                                            255, 2, 72, 72), //background color
                                        // onPrimary: Colors.black, //ripple color
                                      ),
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

class _PengaturanTextFormField extends StatelessWidget {
  const _PengaturanTextFormField({
    Key? key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.validator,
    this.suffixText,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? labelText;
  final FormFieldValidator<String>? validator;
  final String? suffixText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // initialValue: 700.toString(),
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      maxLength: 6,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      decoration: InputDecoration(
        // suffix: ,
        // suffixText: ' / kg',
        // put suffixText before prefixText
        prefixText: 'Rp . ',
        suffixText: suffixText,
        hintText: hintText,
        labelText: labelText,
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
      validator: validator,
    );
  }
}
