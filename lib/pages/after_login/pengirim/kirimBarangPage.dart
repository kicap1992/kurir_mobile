// ignore_for_file: file_names

// ignore: unused_import
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kurir/controller/after_login/pengirim/kirimBarangController.dart';
import 'package:kurir/widgets/boxBackgroundDecoration.dart';
import 'package:kurir/widgets/ourContainer.dart';

class KirimBarangPage extends GetView<KirimBarangController> {
  const KirimBarangPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get.lazyPut<KirimBarangController>(() => KirimBarangController());
    return BoxBackgroundDecoration(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 25),
            OurContainer(
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => controller.show_foto(context),
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
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
                          child: Obx(
                            () => Stack(
                              // put icon on rigth bottom corner
                              alignment: Alignment.center,
                              children: [
                                (controller.adaFoto.value)
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                              'assets/loading.gif',
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            image: DecorationImage(
                                              image: MemoryImage(
                                                controller.imagebytes,
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const Icon(Icons.add,
                                        color: Colors.white, size: 22),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () =>
                                        controller.onChooseOption(context),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: const Icon(
                                        Icons.add_a_photo_outlined,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controller.namaPenerimaController,
                      focusNode: controller.namaPenerimaFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Nama Penerima',
                        labelText: 'Nama Penerima',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama Penerima Tidak Boleh Kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]'),
                        ),
                      ],
                      controller: controller.noTelponPenerimaController,
                      focusNode: controller.noTelponPenerimaFocusNode,
                      maxLength: 13,
                      decoration: InputDecoration(
                        hintText: 'Masukkan No Telpon Penerima',
                        labelText: 'No Telpon Penerima',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama Penerima Tidak Boleh Kosong';
                        }
                        if (value[0] != '0' && value[1] != '8') {
                          return 'No Telpon Penerima Tidak Valid';
                        }

                        if (value.length < 11) {
                          return 'Minimal No Telpon Penerima 11 Digit';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        // log("sini untuk pilih kurir");
                        controller.pilih_kurir(context);
                      },
                      child: TextFormField(
                        enabled: false,
                        // initialValue: (controller.selectedKurirNama.value == '')
                        //     ? 'Klik Untuk Pilih Kurir'
                        //     : "ada",
                        controller: controller.kurirOutroTextController,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Kurir Penghantar',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          errorStyle: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        // validator: (value) {
                        //   if (value! == 'Klik Untuk Pilih Kurir') {
                        //     return 'Nama Penerima Tidak Boleh Kosong';
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.alamatPenerimaController,
                      focusNode: controller.alamatPenerimaFocusNode,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      // minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Alamat Penerima',
                        labelText: 'Alamat Penerima',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama Penerima Tidak Boleh Kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.biayaKirimController,
                      enabled: false,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Biaya Pengiriman',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        errorStyle: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Kurir Belum Dipilih @\nLokasi Pengiriman Belum Ditanda @\nLokasi Permulaan Belum Ditanda';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.jarakTempuhController,
                      enabled: false,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Jarak Tempuh (Km) Kurir',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        errorStyle: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Lokasi Pengiriman atau Lokasi Permulaan Belum Ditanda';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ElevatedButton(
                            onPressed: () {
                              // log("sini pin lokasi");
                              controller.pin_lokasi(context);
                            },
                            child: const Text(
                              'Lokasi Pengiriman',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ElevatedButton(
                            onPressed: () {
                              // create random number
                              // String number =
                              //     Random().nextInt(99999999).toString();
                              // controller.kurirOutroTextController.text = number;
                              // if (controller.formKey.currentState!.validate()) {
                              //   FocusScope.of(context).unfocus();
                              //   controller.konfirmasi_all(context);
                              // }
                              controller.pin_lokasi_permulaan(context, "awal");
                            },
                            child: const Text(
                              'Lokasi Permulaan',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          onPressed: () {
                            WidgetsBinding.instance?.focusManager.primaryFocus
                                ?.unfocus();
                            if (controller.formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              controller.konfirmasi_all(context);
                            }
                          },
                          child: const Text(
                            'Konfirmasi',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
