// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';

import '../../api/beforeLoginAPI.dart';

class PendaftaranPengirimController extends GetxController {
  final formKey = GlobalKey<FormState>(); // form key

  // ini untuk detail login
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final konfirmasiPasswordController = TextEditingController();
  RxBool passwordVisible = false.obs;
  RxBool konfirmasiPasswordVisible = false.obs;
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode konfirmasiPasswordFocusNode = FocusNode();

  // ini untuk detail pengirim
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final noTelpController = TextEditingController();
  final alamatController = TextEditingController();
  final FocusNode namaFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode noTelpFocusNode = FocusNode();
  final FocusNode alamatFocusNode = FocusNode();

  // ini untuk foto
  RxBool isAdaFotoProfil = false.obs;

  // stroing image path
  String? imgProfil;

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  void onInit() {
    log('sini init controller pendaftran pengirim');
    super.onInit();
  }

  @override
  void onReady() {
    intro_message();
    super.onReady();
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

  // before sign up and sign up process
  before_sign_up(BuildContext context) async {
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
          onPressed: () {
            Get.back();
          },
        ),
        ElevatedButton(
          child: const Text('Ya'),
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          onPressed: () {
            // log("sini sign up");
            _sign_up(context);
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

  void _sign_up(BuildContext context) async {
    Get.back();
    String username = usernameController.text;
    String password = passwordController.text;
    String nama = namaController.text;
    String email = emailController.text;
    String noTelp = noTelpController.text;
    String alamat = alamatController.text;
    String fotoProfil = imgProfil!;

    Map<String, dynamic> data = {
      "username": username,
      "password": generateMd5(password),
      "nama": nama,
      "email": email,
      "no_telp": noTelp,
      "alamat": alamat,
      "role": "pengirim",
    };

    // final BeforeLoginApi _api =
    //     Provider.of<BeforeLoginApi>(context, listen: false);

    try {
      await EasyLoading.show(
        status: 'Cek Koneksi...',
        maskType: EasyLoadingMaskType.black,
      );
      Map<String, dynamic> _inidia =
          await BeforeLoginApi.sign_up_pengirim(data, fotoProfil);

      // final Map<String, dynamic> _inidia = await _api.sign_up_pengirim(
      //   data,
      //   fotoProfil,
      // );
      await EasyLoading.dismiss();

      log(_inidia.toString());
      late String title, content;
      // ignore: prefer_typing_uninitialized_variables
      late var color, icon;

      switch (_inidia['status']) {
        case 200:
          title = "Pendaftaran Berhasil ";
          content = _inidia['message'];
          color = Colors.green;
          icon = Icons.check;

          break;
        case 400:
          title = "Pendaftaran Gagal ";
          content = _inidia['message'];
          color = Colors.orange[400];
          icon = Icons.error;
          break;
        case 500:
          title = "Koneksi Bermasalah ";
          content = _inidia['message'];
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
                  if (_inidia['status'] == 200) {
                    // Get.back();
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
                    switch (_inidia['focus']) {
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

  willPopScopeWidget() {
    // create get dialog
    return Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text(
            'Anda yakin ingin keluar dari halaman ini?\nPendaftran anda akan dibatalkan'),
        actions: [
          ElevatedButton(
            child: const Text('Tidak'),
            onPressed: () {
              Get.back();
            },
          ),
          ElevatedButton(
            child: const Text('Ya'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            onPressed: () async {
              // await _cek_and_delete();
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
