// ignore_for_file: non_constant_identifier_names, file_names
// ignore: unused_import
import 'dart:developer' as dev;

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

class KurirApi {
  static var client = http.Client();

  static var storage = GetStorage();

  static var username = storage.read("username");
  static var password = storage.read("password");
  static var id = storage.read("id");

  static clientClose(http.Client client) {
    client.close();
  }

  // get all pengiriman status ='Dalam Pengesahan Kurir'
  static Future<Map<String, dynamic>>
      getAllPengirimanDalamPengesahanKurir() async {
    client = http.Client();
    late Map<String, dynamic> result;

    bool _cek_jaringan = await cek_jaringan(client);

    log("cek jaringan : " + _cek_jaringan.toString());

    if (!_cek_jaringan) {
      result = {
        'status': 500,
        'message':
            "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
      };
    } else {
      // wait for 3 sec
      // await Future.delayed(Duration(seconds: 3));
      // result = {'status': 200, 'message': "sini dia"};

      try {
        // log("${globals.http_to_server}api/kurir/get_all_kurir_dalam_pengesahan?username=$username&password=$password&id=$id");
        var response = await client.get(
            Uri.parse(
                "${globals.http_to_server}api/kurir/pengiriman_kurir_dalam_pengesahan?username=$username&password=$password&id=$id"),
            headers: {
              "Accept": "application/json",
              // "authorization":
              //     "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
              "crossDomain": "true"
            }).timeout(const Duration(seconds: 10));
        final data = jsonDecode(response.body);
        // log(data.toString());
        // log("ini status : " + response.statusCode.toString());
        if (response.statusCode == 200) {
          result = {
            'status': 200,
            'message': data['message'],
            'data': data['data']
          };
        } else {
          result = {'status': 400, 'message': "Server Error", 'data': data};
        }
      } catch (e) {
        // dev.log(e.toString());
        result = {
          'status': 500,
          'message':
              "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
        };
      }
    }

    return result;
  }

  // cek pengaturan kurir
  static Future<Map<String, dynamic>> cekPengaturanKurir() async {
    client = http.Client();
    late Map<String, dynamic> result;

    bool _cek_jaringan = await cek_jaringan(client);

    log("cek jaringan : " + _cek_jaringan.toString());

    if (!_cek_jaringan) {
      result = {
        'status': 500,
        'message':
            "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
      };
    } else {
      // wait for 3 sec
      // await Future.delayed(Duration(seconds: 3));
      // result = {'status': 200, 'message': "sini dia"};

      try {
        log("${globals.http_to_server}api/kurir/pengaturan?username=$username&password=$password&id=$id");
        var response = await client.get(
            Uri.parse(
                "${globals.http_to_server}api/kurir/pengaturan?username=$username&password=$password&id=$id"),
            headers: {
              "Accept": "application/json",
              // "authorization":
              //     "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
              "crossDomain": "true"
            }).timeout(const Duration(seconds: 10));
        final data = jsonDecode(response.body);
        log(data.toString());
        log("ini status : " + response.statusCode.toString());
        if (response.statusCode == 200) {
          result = {
            'status': 200,
            'message': data['message'],
            'data': data['data']
          };
        } else {
          result = {
            'status': 500,
            'message': "Gagal mengatur biaya pengiriman",
            'data': data
          };
        }
      } catch (e) {
        result = {
          'status': 500,
          'message':
              "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
        };
      }
    }

    return result;
  }

  // tambah/edit pengaturan kurir
  static Future<Map<String, dynamic>> pengaturanKurir(
      String minimalBiaya, String maksimalBiaya, String biayaPerKilo) async {
    client = http.Client();
    late Map<String, dynamic> result;

    bool _cek_jaringan = await cek_jaringan(client);

    log("cek jaringan : " + _cek_jaringan.toString());
    if (!_cek_jaringan) {
      result = {
        'status': 500,
        'message':
            "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
      };
    } else {
      // wait for 3 sec
      // await Future.delayed(Duration(seconds: 3));
      // result = {'status': 200, 'message': "sini dia"};

      try {
        var response = await client.post(
            Uri.parse(
                "${globals.http_to_server}api/kurir/pengaturan?username=$username&password=$password&id=$id"),
            headers: {
              "Accept": "application/json",
              // "authorization":
              //     "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
              "crossDomain": "true"
            },
            body: {
              "minimal_biaya_pengiriman": minimalBiaya,
              "maksimal_biaya_pengiriman": maksimalBiaya,
              "biaya_per_kilo": biayaPerKilo
            }).timeout(const Duration(seconds: 10));
        final data = jsonDecode(response.body);
        log(data.toString());
        log("ini status : " + response.statusCode.toString());
        if (response.statusCode == 200) {
          result = {'status': 200, 'message': data['message'], 'data': data};
        } else {
          result = {
            'status': 500,
            'message': "Gagal mengatur biaya pengiriman",
            'data': data
          };
        }
      } catch (e) {
        result = {
          'status': 500,
          'message':
              "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
        };
      }
    }

    return result;
  }

  // terima pengiriman kurir dan ubah status ke 'Pengiriman Disahkan kurir'
  static Future<Map<String, dynamic>> sahkanPengiriman(
      String? idPengiriman) async {
    client = http.Client();
    late Map<String, dynamic> result;
    bool _cek_jaringan = await cek_jaringan(client);

    // log("cek jaringan : " + _cek_jaringan.toString());

    if (!_cek_jaringan) {
      result = {
        'status': 500,
        'message':
            "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
      };
    } else {
      // wait for 3 sec
      // await Future.delayed(Duration(seconds: 3));
      // result = {'status': 200, 'message': "sini dia"};

      try {
        var response = await client.post(
            Uri.parse(
                "${globals.http_to_server}api/kurir/sahkan_pengiriman?username=$username&password=$password&id=$id"),
            headers: {
              "Accept": "application/json",
              // "authorization":
              //     "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
              "crossDomain": "true"
            },
            body: {
              "id_pengiriman": idPengiriman
            }).timeout(const Duration(seconds: 60));
        final data = jsonDecode(response.body);
        // log(data.toString());
        // log("ini status : " + response.statusCode.toString());
        if (response.statusCode == 200) {
          result = {
            'status': 200,
            'message': data['message'],
            'data': data['data']
          };
        } else {
          result = {
            'status': response.statusCode,
            'message': data['message'],
            'data': data
          };
        }
      } catch (e) {
        result = {
          'status': 500,
          'message':
              "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
        };
      }
    }

    return result;
  }

  static Future<Map<String, dynamic>> detailPengiriman(
      String idPengiriman) async {
    client = http.Client();
    late Map<String, dynamic> result;
    bool _cek_jaringan = await cek_jaringan(client);
    if (!_cek_jaringan) {
      result = {
        'status': 500,
        'message':
            "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
      };
    } else {
      // wait for 3 sec
      // await Future.delayed(Duration(seconds: 3));
      // result = {'status': 200, 'message': "sini dia"};
      try {
        var response = await client.get(
            Uri.parse(
                "${globals.http_to_server}api/kurir/detail_pengiriman?username=$username&password=$password&id=$id&id_pengiriman=$idPengiriman"),
            headers: {
              "Accept": "application/json",
              // "authorization":
              //     "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
              "crossDomain": "true"
            }).timeout(const Duration(seconds: 60));
        final data = jsonDecode(response.body);
        // log(data.toString());
        // log("ini status : " + response.statusCode.toString());
        if (response.statusCode == 200) {
          result = {
            'status': 200,
            'message': data['message'],
            'data': data['data']
          };
        } else {
          result = {
            'status': response.statusCode,
            'message': data['message'],
            'data': data
          };
        }
      } catch (e) {
        result = {
          'status': 500,
          'message':
              "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
        };
      }
    }

    return result;
  }

  static Future<Map<String, dynamic>> mengambilPaketPengiriman(
      String? idPengiriman) async {
    client = http.Client();
    late Map<String, dynamic> result;
    bool _cek_jaringan = await cek_jaringan(client);

    // log("cek jaringan : " + _cek_jaringan.toString());

    if (!_cek_jaringan) {
      result = {
        'status': 500,
        'message':
            "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
      };
    } else {
      // wait for 3 sec
      // await Future.delayed(Duration(seconds: 3));
      // result = {'status': 200, 'message': "sini dia"};

      try {
        var response = await client.post(
            Uri.parse(
                "${globals.http_to_server}api/kurir/mengambil_paket_pengiriman?username=$username&password=$password&id=$id"),
            headers: {
              "Accept": "application/json",
              // "authorization":
              //     "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
              "crossDomain": "true"
            },
            body: {
              "id_pengiriman": idPengiriman
            }).timeout(const Duration(seconds: 60));
        final data = jsonDecode(response.body);
        // log(data.toString());
        // log("ini status : " + response.statusCode.toString());
        if (response.statusCode == 200) {
          result = {
            'status': 200,
            'message': data['message'],
            'data': data['data']
          };
        } else {
          result = {
            'status': response.statusCode,
            'message': data['message'],
            'data': data
          };
        }
      } catch (e) {
        result = {
          'status': 500,
          'message':
              "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
        };
      }
    }

    return result;
  }

  // checking connection to server
  static Future<bool> cek_jaringan(http.Client client) async {
    late bool result;

    // client get for globals.http_to_server
    try {
      var response =
          await client.get(Uri.parse("${globals.http_to_server}api"), headers: {
        "Accept": "application/json",
        // "authorization":
        //     "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
        "crossDomain": "true"
      }).timeout(const Duration(seconds: 10));
      // final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        result = true;
      } else {
        result = false;
      }
    } on SocketException {
      await EasyLoading.dismiss();
      result = false;
      await clientClose(client);
      log(" ini error socket");
    } on TimeoutException {
      await EasyLoading.dismiss();
      result = false;
      // close client
      await clientClose(client);
      log(" ini timeout");
    } on Exception {
      result = false;
      log(" ini timeout");
    } catch (e) {
      result = false;
      log(" ini timeout");
    }

    return result;
  }
}
