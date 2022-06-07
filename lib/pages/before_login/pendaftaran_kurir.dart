import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kurir/controller/before_login/pendaftaranKurirController.dart';
import 'package:kurir/widgets/focusToTextFormField.dart';

import '../../widgets/boxBackgroundDecoration.dart';
import '../../widgets/ourContainer.dart';

// import 'package:image_picker/image_picker.dart';

class PendaftaranKurirPage extends GetView<PendaftaranKurirController> {
  const PendaftaranKurirPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FocusScope.of(context).unfocus();
    return WillPopScope(
      onWillPop: () => controller.willPopScopeWidget(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pendaftaran Kurir'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                controller.intro_message();
                // controller.getHttp();
              },
            ),
          ],
        ),
        body: BoxBackgroundDecoration(
          child: SingleChildScrollView(
            reverse: false,
            child: Center(
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    OurContainer(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          const Text(
                            'Detail Login',
                            textAlign: TextAlign.center,
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
                              //focus node
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
                                  // FocusScope.of(context).unfocus();
                                  controller.usernameFocusNode.requestFocus();
                                  return 'Username Harus Terisi';
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
                                obscureText: controller.passwordVisible.value,
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
                                      color: !controller.passwordVisible.value
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
                                    controller.konfirmasiPasswordVisible.value,
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
                                      color: !controller
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
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          const Text(
                            'Detail Kurir',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          EnsureVisibleWhenFocused(
                            focusNode: controller.nikFocusNode,
                            child: TextFormField(
                              //focus node
                              focusNode: controller.nikFocusNode,
                              controller: controller.nikController,
                              maxLength: 16,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'),
                                ),
                              ],
                              decoration: InputDecoration(
                                hintText: 'NIK',
                                labelText: 'NIK',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  controller.nikFocusNode.requestFocus();
                                  return 'NIK Harus Terisi';
                                } else if (value.length < 16) {
                                  controller.nikFocusNode.requestFocus();
                                  return 'NIK Harus 16 Karakter';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          EnsureVisibleWhenFocused(
                            focusNode: controller.namaFocusNode,
                            child: TextFormField(
                              //focus node
                              focusNode: controller.namaFocusNode,
                              controller: controller.namaController,
                              decoration: InputDecoration(
                                hintText: 'Nama Sesuai KTP',
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
                                  controller.namaFocusNode.requestFocus();
                                  return 'Nama Harus Terisi \n Sesuai Nama Di KTP';
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
                              //focus node
                              focusNode: controller.emailFocusNode,
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                // log(controller
                                //     .email_checker(value!)
                                //     .toString());
                                if (value!.isEmpty) {
                                  controller.emailFocusNode.requestFocus();
                                  return 'Email Harus Terisi \n Untuk Konfimasi Pendaftaran Akun \n Pastikan Gunakan Email Yang Valid';
                                } else if (!controller.email_checker(value)) {
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
                                hintText: 'No Telpon',
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
                                hintText: 'Alamat',
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
                          EnsureVisibleWhenFocused(
                            focusNode: controller.noPlatFocusNode,
                            child: TextFormField(
                              //focus node
                              focusNode: controller.noPlatFocusNode,
                              controller: controller.noPlatController,
                              decoration: InputDecoration(
                                hintText: 'No Plat Kenderaan',
                                labelText: 'No Plat Kenderaan',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  controller.noPlatFocusNode.requestFocus();
                                  return 'No Plat Kenderaan Harus Terisi';
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
                              child: EnsureVisibleWhenFocused(
                                focusNode: controller.fotoProfilFocusNode,
                                child: TextFormField(
                                  //focus node
                                  focusNode: controller.fotoProfilFocusNode,
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
                                      controller.fotoProfilFocusNode
                                          .requestFocus();
                                      return 'Foto Profil Belum Di Upload\nKlik Field Ini Untuk Upload Foto Profil';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                // log("sini ontap foto");
                                controller.onChooseOption('ktp');
                              },
                              onDoubleTap: () => [
                                controller.isAdaFotoKTP.value
                                    ? controller.showFoto('ktp')
                                    : log("tidak ada foto"),
                                FocusScope.of(context).unfocus()
                              ],
                              child: EnsureVisibleWhenFocused(
                                focusNode: controller.fotoKTPFocusNode,
                                child: TextFormField(
                                  //focus node
                                  focusNode: controller.fotoKTPFocusNode,
                                  initialValue: '',
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelText: controller.isAdaFotoKTP.value
                                        ? 'Klik 2x Untuk Melihat Foto KTP'
                                        : 'Foto KTP Belum Di Upload',
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
                                    if (!controller.isAdaFotoKTP.value) {
                                      FocusScope.of(context).unfocus();
                                      controller.fotoKTPFocusNode
                                          .requestFocus();
                                      return 'Foto KTP Belum Di Upload\nKlik Field Ini Untuk Upload Foto KTP';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                // log("sini ontap ktp holding");
                                controller.onChooseOption('ktp_holding');
                              },
                              onDoubleTap: () => [
                                controller.isAdaFotoKTPHolding.value
                                    ? controller.showFoto('ktp_holding')
                                    : log("tidak ada foto"),
                                FocusScope.of(context).unfocus()
                              ],
                              child: EnsureVisibleWhenFocused(
                                focusNode: controller.fotoHoldingKTPFocusNode,
                                child: TextFormField(
                                  //focus node
                                  focusNode: controller.fotoHoldingKTPFocusNode,
                                  enabled: false,
                                  initialValue: '',
                                  decoration: InputDecoration(
                                    labelText: controller
                                            .isAdaFotoKTPHolding.value
                                        ? 'Klik 2x Untuk Melihat Foto Memegang KTP'
                                        : 'Foto Memegang KTP ',
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
                                    if (!controller.isAdaFotoKTPHolding.value) {
                                      FocusScope.of(context).unfocus();
                                      controller.fotoHoldingKTPFocusNode
                                          .requestFocus();
                                      return 'Foto Memegang KTP Belum Di Upload\nKlik Field Ini Untuk Upload Foto Memegang KTP';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                // log("sini ontap kendaraan");
                                controller.onChooseOption('kendaraan');
                              },
                              onDoubleTap: () => [
                                controller.isAdaKenderaan.value
                                    ? controller.showFoto('kendaraan')
                                    : log("tidak ada foto"),
                                FocusScope.of(context).unfocus()
                              ],
                              child: EnsureVisibleWhenFocused(
                                focusNode: controller.fotoKendaraanFocusNode,
                                child: TextFormField(
                                  //focus node
                                  focusNode: controller.fotoKendaraanFocusNode,
                                  enabled: false,
                                  initialValue: '',
                                  decoration: InputDecoration(
                                    labelText: controller.isAdaKenderaan.value
                                        ? 'Klik 2x Untuk Melihat Foto Kendaraan'
                                        : 'Foto Kendaraan ',
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
                                    if (!controller.isAdaKenderaan.value) {
                                      FocusScope.of(context).unfocus();
                                      controller.fotoKendaraanFocusNode
                                          .requestFocus();
                                      return 'Foto Kendaraan Belum Di Upload\nKlik Field Ini Untuk Upload Foto Kendaraan';
                                    }
                                    return null;
                                  },
                                ),
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
                            controller.before_sign_up();
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
