import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kurir/controller/before_login/pendaftaranPengirimController.dart';
import 'package:kurir/widgets/boxBackgroundDecoration.dart';
import 'package:kurir/widgets/focusToTextFormField.dart';
import 'package:kurir/widgets/ourContainer.dart';

class PendaftaranPengirimPage extends GetView<PendaftaranPengirimController> {
  const PendaftaranPengirimPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => controller.willPopScopeWidget(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pendaftaran Pengirim'),
          actions: [
            IconButton(
              onPressed: () => controller.intro_message(),
              icon: const Icon(Icons.info_outline),
            ),
          ],
        ),
        body: BoxBackgroundDecoration(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    OurContainer(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          const Text(
                            'Pendaftaran Pengirim',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          EnsureVisibleWhenFocused(
                            focusNode: controller.usernameFocusNode,
                            child: TextFormField(
                              focusNode: controller.usernameFocusNode,
                              controller: controller.usernameController,
                              decoration: InputDecoration(
                                hintText: 'Username',
                                labelText: 'Username',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  // request focus
                                  controller.usernameFocusNode.requestFocus();
                                  return 'Username Harus Terisi';
                                } else if (value.length < 6) {
                                  return 'Username Minimal 6 Karakter';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(
                            () => EnsureVisibleWhenFocused(
                              focusNode: controller.passwordFocusNode,
                              child: TextFormField(
                                //focus node
                                focusNode: controller.passwordFocusNode,
                                controller: controller.passwordController,
                                obscureText: !controller.passwordVisible.value,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  labelText: 'Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: controller.passwordVisible.value
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      controller.passwordVisible.value =
                                          !controller.passwordVisible.value;
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  // log(value!.length.toString() +
                                  //     "ini panjangnya");
                                  if (value!.isEmpty) {
                                    controller.passwordFocusNode.requestFocus();
                                    return 'Password Harus Terisi';
                                  } else if (value.length < 8) {
                                    controller.passwordFocusNode.requestFocus();
                                    return 'Password Minimal 8 Karakter';
                                  } else if (value.toString() !=
                                      controller
                                          .konfirmasiPasswordController.text
                                          .toString()) {
                                    controller.passwordFocusNode.requestFocus();
                                    return 'Password tidak sama dengan konfirmasi password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(
                            () => EnsureVisibleWhenFocused(
                              focusNode: controller.konfirmasiPasswordFocusNode,
                              child: TextFormField(
                                //focus node
                                focusNode:
                                    controller.konfirmasiPasswordFocusNode,
                                controller:
                                    controller.konfirmasiPasswordController,
                                obscureText:
                                    !controller.konfirmasiPasswordVisible.value,
                                decoration: InputDecoration(
                                  hintText: 'Konfirmasi Password',
                                  labelText: 'Konfirmasi Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: controller
                                              .konfirmasiPasswordVisible.value
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      controller
                                              .konfirmasiPasswordVisible.value =
                                          !controller
                                              .konfirmasiPasswordVisible.value;
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  // log('konfirmasi pasword = $value');
                                  if (value!.isEmpty) {
                                    controller.konfirmasiPasswordFocusNode
                                        .requestFocus();
                                    return 'Konfirmasi Password Harus Terisi';
                                  } else if (value.toString() !=
                                      controller.passwordController.text
                                          .toString()) {
                                    controller.konfirmasiPasswordFocusNode
                                        .requestFocus();
                                    return 'Password tidak sama dengan konfirmasi password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    OurContainer(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          const Text(
                            'Detail Pengirim',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          EnsureVisibleWhenFocused(
                            focusNode: controller.namaFocusNode,
                            child: TextFormField(
                              focusNode: controller.namaFocusNode,
                              controller: controller.namaController,
                              decoration: InputDecoration(
                                hintText: 'Masukkan Nama',
                                labelText: 'Nama',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  // request focus
                                  controller.usernameFocusNode.requestFocus();
                                  return 'Nama Harus Terisi';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          EnsureVisibleWhenFocused(
                            focusNode: controller.emailFocusNode,
                            child: TextFormField(
                              focusNode: controller.emailFocusNode,
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                hintText: 'Masukkan Email',
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  // request focus
                                  controller.emailFocusNode.requestFocus();
                                  return 'Email Harus Terisi';
                                } else if (controller
                                        .email_checker(value.toString()) ==
                                    false) {
                                  controller.emailFocusNode.requestFocus();
                                  return 'Email Tidak Valid';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          EnsureVisibleWhenFocused(
                            focusNode: controller.noTelpFocusNode,
                            child: TextFormField(
                              //focus node
                              focusNode: controller.noTelpFocusNode,
                              controller: controller.noTelpController,
                              maxLength: 13,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'),
                                ),
                              ],
                              decoration: InputDecoration(
                                hintText: ' Masukkan No Telpon',
                                labelText: 'No Telpon',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  controller.noTelpFocusNode.requestFocus();
                                  return 'No Telpon Harus Terisi \n Dengan Nomor Yang Valid';
                                } else if (value.length < 11) {
                                  controller.noTelpFocusNode.requestFocus();
                                  return 'No Telpon Minimal Harus 11 Karakter';
                                  // ignore: unrelated_type_equality_checks
                                } else if (int.parse(value[0]) != 0 &&
                                    // ignore: unrelated_type_equality_checks
                                    int.parse(value[1]) != 8) {
                                  controller.noTelpFocusNode.requestFocus();
                                  return 'Format No Telpon Tidak Valid';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          EnsureVisibleWhenFocused(
                            focusNode: controller.alamatFocusNode,
                            child: TextFormField(
                              //focus node
                              focusNode: controller.alamatFocusNode,
                              controller: controller.alamatController,
                              decoration: InputDecoration(
                                hintText: ' Masukkan Alamat',
                                labelText: 'Alamat',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  controller.alamatFocusNode.requestFocus();
                                  return 'Alamat Harus Terisi';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                // log("sini ontap foto profil");
                                controller.onChooseOption('profil');
                              },
                              onDoubleTap: () => [
                                controller.isAdaFotoProfil.value
                                    ? controller.showFoto('profil')
                                    : log("tidak ada profil"),
                                FocusScope.of(context).unfocus()
                              ],
                              child: TextFormField(
                                initialValue: '',
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: controller.isAdaFotoProfil.value
                                      ? 'Klik 2x Untuk Melihat Foto Profil'
                                      : 'Foto Profil Belum Di Upload',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  errorStyle: const TextStyle(
                                    color: Colors.red,
                                    // fontSize: 12,
                                  ),
                                ),
                                validator: (value) {
                                  if (!controller.isAdaFotoProfil.value) {
                                    FocusScope.of(context).unfocus();
                                    return 'Foto Profil Belum Di Upload\nKlik Field Ini Untuk Upload Foto Profil';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            // log("jalankan");
                            controller.before_sign_up(context);
                          } else {
                            Get.snackbar(
                              'Error',
                              'Mohon Lengkapi Data',
                              icon: const Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.orange[400],
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: const Text('Daftar'),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
