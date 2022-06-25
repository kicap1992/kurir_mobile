// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurir/controller/after_login/pengirim/logKirimanController.dart';
import 'package:kurir/widgets/boxBackgroundDecoration.dart';
import 'package:kurir/widgets/ourContainer.dart';

class LogKirimanPage extends GetView<LogKirimanController> {
  const LogKirimanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.checkScreenOrientation();
    return BoxBackgroundDecoration(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                  minHeight: MediaQuery.of(context).size.height * 0.75,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: OurContainer(
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          'Log Kiriman',
                          style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Cari Kiriman',
                          labelText: 'Cari Kiriman',
                          prefixIcon: Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 10),
                            child: GestureDetector(
                              child: const Icon(
                                Icons.list_alt_rounded,
                                color: Color.fromARGB(255, 4, 103, 103),
                              ),
                              onTap: () {},
                            ),
                          ),
                          suffixIcon: const Icon(Icons.search),
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
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() => controller.widgetLogKiriman.value),
                    ],
                  ),
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
