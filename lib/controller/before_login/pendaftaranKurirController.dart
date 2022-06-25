// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kurir/api/beforeLoginAPI.dart';

// sini coba
import 'package:path_provider/path_provider.dart';

import 'dart:convert';
import 'package:crypto/crypto.dart';

class PendaftaranKurirController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // ini untuk detail login
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final konfirmasiPasswordController = TextEditingController();
  RxBool passwordVisible = true.obs;
  RxBool konfirmasiPasswordVisible = true.obs;
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode konfirmasiPasswordFocusNode = FocusNode();

  // ini untuk detail kurir
  final nikController = TextEditingController();
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final noTelpController = TextEditingController();
  final alamatController = TextEditingController();
  final noPlatController = TextEditingController();
  final FocusNode nikFocusNode = FocusNode();
  final FocusNode namaFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode noTelpFocusNode = FocusNode();
  final FocusNode alamatFocusNode = FocusNode();
  final FocusNode noPlatFocusNode = FocusNode();
  final FocusNode fotoProfilFocusNode = FocusNode();
  final FocusNode fotoKTPFocusNode = FocusNode();
  final FocusNode fotoKendaraanFocusNode = FocusNode();
  final FocusNode fotoHoldingKTPFocusNode = FocusNode();

  // ini untuk foto
  RxBool isAdaFotoProfil = false.obs;
  RxBool isAdaFotoKTP = false.obs;
  RxBool isAdaFotoKTPHolding = false.obs;
  RxBool isAdaKenderaan = false.obs;

  // storing image path
  String? imgProfil;
  String? imgKTP;
  String? imgKendaraan;
  String? imgHoldingKTP;

  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;

  // create onimagebuttonpressed
  Future<void> _onImageButtonPressed(ImageSource source, String option) async {
    log('sini on image button pressed + $option');
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      _imageFile = pickedFile;
      // log("ini dia ");
      log(_imageFile!.path.toString());
      switch (option) {
        case "profil":
          imgProfil = _imageFile!.path.toString();
          isAdaFotoProfil.value = true;
          break;
        case "ktp":
          imgKTP = _imageFile!.path.toString();
          isAdaFotoKTP.value = true;

          break;
        case "kendaraan":
          imgKendaraan = _imageFile!.path.toString();
          isAdaKenderaan.value = true;
          break;
        case "ktp_holding":
          imgHoldingKTP = _imageFile!.path.toString();
          isAdaFotoKTPHolding.value = true;
          break;
      }
      // log("ini dia " + imgKTP!);
    } catch (e) {
      log(e.toString());
    }
  }

  // show foto
  Future showFoto(String option) async {
    Uint8List? _bytes;
    // log("ini dia img ktp" + imgKTP!);
    // final appStorage = await getTemporaryDirectory();
    late String _initialPath;
    switch (option) {
      case "profil":
        _initialPath = imgProfil!;
        break;
      case "ktp":
        _initialPath = imgKTP!;
        break;
      case "kendaraan":
        _initialPath = imgKendaraan!;
        break;
      case "ktp_holding":
        _initialPath = imgHoldingKTP!;
        break;
    }
    final _file = File(_initialPath);
    if (_file.existsSync()) {
      log("ada");
      Uint8List bytes = await _file.readAsBytes();
      _bytes = bytes;
      //
      return await Get.bottomSheet(
        Container(
          height: MediaQuery.of(Get.context!).size.height / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: MemoryImage(_bytes),
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    } else {
      log("tidak ada");
    }

    // show getx bottom sheet
  }

  //delete foto on cache and storage
  Future _cek_and_delete() async {
    final appStorage = await getTemporaryDirectory();
    // // if (appStorage.existsSync()) {
    // // log("ada file");
    // // print all filename in directory
    final fileList = appStorage.listSync();
    log(fileList.toString() + "ini file list");
    if (fileList.isNotEmpty) {
      log("ada file");
      // print(fileList);
      for (var i = 0; i < fileList.length; i++) {
        final file = fileList[i];
        log(file.path);
        if (file.toString().contains(".jpg") ||
            file.toString().contains(".png") ||
            file.toString().contains(".jpeg") ||
            file.toString().contains(".JPG") ||
            file.toString().contains(".PNG") ||
            file.toString().contains(".JPEG")) {
          log("delete");
          await file.delete(recursive: true);
        }
      }
    } else {
      log("tidak ada file");
      // print(fileList);
    }
  }

  // choose option of photo
  Future<void> onChooseOption(String option) async {
    return Get.dialog(
      AlertDialog(
        // title: Text('Pilih'),
        content: const Text(
          "Pilih",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              ElevatedButton(
                onPressed: () {
                  _onImageButtonPressed(ImageSource.camera, option);
                  Get.back();
                },
                child: const Text("Camera"),
              ),
              const SizedBox(),
              ElevatedButton(
                onPressed: () {
                  _onImageButtonPressed(ImageSource.gallery, option);
                  Get.back();
                },
                child: const Text("Galeri"),
              ),
              const SizedBox(),
            ],
          )
        ],
      ),
    );
  }

  @override
  void onInit() {
    log('Sini contoller pendaftaran kurir');
    // intro_message();
    super.onInit();
  }

  @override
  void onReady() {
    // log('Sini contoller pendaftaran kurir');
    intro_message();
    super.onReady();
  }

  @override
  void dispose() {
    // dispose formKey
    // ignore: invalid_use_of_protected_member
    formKey.currentState?.dispose();
    // dispose controller
    usernameController.dispose();
    passwordController.dispose();
    konfirmasiPasswordController.dispose();
    nikController.dispose();
    namaController.dispose();
    emailController.dispose();
    noTelpController.dispose();
    alamatController.dispose();
    noPlatController.dispose();

    // dispose focusNode
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    konfirmasiPasswordFocusNode.dispose();
    nikFocusNode.dispose();
    namaFocusNode.dispose();
    emailFocusNode.dispose();
    noTelpFocusNode.dispose();
    alamatFocusNode.dispose();
    noPlatFocusNode.dispose();
    fotoProfilFocusNode.dispose();
    fotoKTPFocusNode.dispose();
    fotoHoldingKTPFocusNode.dispose();
    fotoKendaraanFocusNode.dispose();

    super.dispose();
  }

  // intro message
  Future intro_message() {
    return Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text('Info Penting', textAlign: TextAlign.center),
          content: const Text(
            "Silahkan isi data diri anda dengan benar\nData anda akan dievaluasi oleh admin sebelum anda dapat mendaftar ke dalam sistem",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 2, 72, 72),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("OK"),
                ),
                const SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }

  // before sign up and sign up process
  before_sign_up() {
    log("ini before sign up");
    // show get dialog
    return Get.dialog(AlertDialog(
      title: const Text("Pendaftaran Kurir", textAlign: TextAlign.center),
      content: const Text(
          "Yakin dengan data yang anda masukkan benar?\nAdmin akan mengevaluasi data yang anda masukkan sebelum menerima pendaftaran",
          textAlign: TextAlign.center),
      actions: [
        ElevatedButton(
          child: const Text('Tidak'),
          style: ElevatedButton.styleFrom(
            primary: const Color.fromARGB(255, 2, 72, 72),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        ElevatedButton(
          child: const Text('Ya'),
          style: ElevatedButton.styleFrom(
            primary: const Color.fromARGB(255, 104, 164, 164),
          ),
          onPressed: () {
            sign_up();
            // await _cek_and_delete();
            // await Get.offAllNamed(
            //   '/index',
            //   arguments: {"tap": 0},
            // );
          },
        ),
      ],
    ));
  }

  void sign_up() async {
    Get.back();
    String username = usernameController.text;
    String password = passwordController.text;
    String nik = nikController.text;
    String nama = namaController.text;
    String email = emailController.text;
    String noTelp = noTelpController.text;
    String alamat = alamatController.text;
    String noPlat = noPlatController.text;
    String fotoProfil = imgProfil!;
    String fotoKTP = imgKTP!;
    String fotoHoldingKTP = imgHoldingKTP!;
    String fotoKendaraan = imgKendaraan!;

    Map<String, dynamic> data = {
      "username": username,
      "password": generateMd5(password),
      "nik": nik,
      "nama": nama,
      "email": email,
      "no_telp": noTelp,
      "alamat": alamat,
      "no_kenderaan": noPlat,
      "role": "kurir",
    };

    try {
      await EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.black,
      );
      Map<String, dynamic> inidia = await BeforeLoginApi.sign_up_kurir(
          data, fotoKTP, fotoHoldingKTP, fotoKendaraan, fotoProfil);

      late String title, content;
      // ignore: prefer_typing_uninitialized_variables
      late var color, icon;

      switch (inidia['status']) {
        case 200:
          title = "Pendaftaran Berhasil ";
          content = inidia['message'];
          color = Colors.green;
          icon = Icons.check;

          break;
        case 400:
          title = "Pendaftaran Gagal ";
          content = inidia['message'];
          color = Colors.orange[400];
          icon = Icons.error;
          break;
        case 500:
          title = "Koneksi Bermasalah ";
          content = inidia['message'];
          color = Colors.red;
          icon = Icons.error;
          break;
      }
      Get.snackbar(
        title,
        content,
        icon: Icon(icon, color: Colors.white),
        backgroundColor: color,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      Get.dialog(
        WillPopScope(
          onWillPop: () {
            // Get.back();
            return Future.value(false);
          },
          child: AlertDialog(
            title: Text(title, textAlign: TextAlign.center),
            content: Text(content, textAlign: TextAlign.justify),
            actions: [
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () async {
                  if (inidia['status'] == 200) {
                    await _cek_and_delete();
                    await Get.offAllNamed(
                      '/index',
                      arguments: {
                        "tap": 0,
                        'history': [0]
                      },
                    );
                  } else {
                    Get.back();
                    switch (inidia['focus']) {
                      case 'nik':
                        nikFocusNode.requestFocus();
                        break;
                      case 'no_telp':
                        noTelpFocusNode.requestFocus();
                        break;
                      case 'email':
                        emailFocusNode.requestFocus();
                        break;
                    }
                  }
                },
              ),
            ],
          ),
        ),
      );
      //
      await EasyLoading.dismiss();
    } catch (e) {
      log(e.toString());
    }

    // return BeforeLoginApi.sign_up(
    //         data, fotoKTP, fotoHoldingKTP, fotoKendaraan, fotoProfil)
    //     .then((response) {
    //   log(response.toString());
    // }).catchError((e) {
    //   log(e.toString());
    // }).whenComplete(() {
    //   log("complete");
    // });

    // log("sini berlaku proses sign up");
  }

  // for input checker
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  bool email_checker(String email) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return regex.hasMatch(email);
    // return false;
  }

  // back button alert box
  willPopScopeWidget() {
    // create get dialog
    return Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Anda yakin ingin keluar dari halaman ini?'),
        actions: [
          ElevatedButton(
            child: const Text('Tidak'),
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 104, 164, 164),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          ElevatedButton(
            child: const Text('Ya'),
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 2, 72, 72),
            ),
            onPressed: () async {
              await _cek_and_delete();
              await Get.offAllNamed(
                '/index',
                arguments: {
                  "tap": 0,
                  'history': [0]
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
