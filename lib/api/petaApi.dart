// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

class PetaApi {
  static var client = http.Client();

  static var storage = GetStorage();

  static var username = storage.read("username");
  static var password = storage.read("password");
  static var id = storage.read("id");

  static clientClose(http.Client client) {
    client.close();
  }

  // cek kecamatan_map
  static Future<Map<String, dynamic>> cekKecamatan() async {
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
        var response = await client.get(
            Uri.parse("${globals.http_to_server}api/peta/kecamatan"),
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
          result = {'status': 200, 'message': "sini dia", 'data': data['data']};
        } else {
          result = {
            'status': 500,
            'message':
                "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
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

  // cek kelurahan_desa_map
  static Future<Map<String, dynamic>> cekKelurahanDesa() async {
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
      try {
        var response = await client.get(
            Uri.parse("${globals.http_to_server}api/peta/kelurahan_desa"),
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
          result = {'status': 200, 'message': "sini dia", 'data': data['data']};
        } else {
          result = {
            'status': 500,
            'message':
                "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
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

  // cek_kelurahan_desa_detail_map
  static Future<Map<String, dynamic>> cekKelurahanDesaDetail(
      String nama) async {
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
      try {
        var response = await client.get(
            Uri.parse(
                "${globals.http_to_server}api/peta/kelurahan_desa?kelurahan_desa=$nama"),
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
          result = {'status': 200, 'message': "sini dia", 'data': data['data']};
        } else {
          result = {
            'status': 500,
            'message':
                "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
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
