// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

class PengirimApi {
  static var client = http.Client();

  static var storage = GetStorage();

  static var username = storage.read("username");
  static var password = storage.read("password");
  static var id = storage.read("id");

  static clientClose(http.Client client) {
    client.close();
  }

  // get all kurir
  static Future<Map<String, dynamic>> getAllKurir() async {
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
        var response = await client.get(
            Uri.parse(
                "${globals.http_to_server}api/pengirim/kurir?username=$username&password=$password&id=$id"),
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

  // get kurir by nama
  static Future<Map<String, dynamic>> getKurirByNama(String nama) async {
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
        var response = await client.get(
            Uri.parse(
                "${globals.http_to_server}api/pengirim/kurir/nama?nama=$nama&username=$username&password=$password&id=$id"),
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

  // get kurir by nama
  static Future<Map<String, dynamic>> getKurirByFilter(
      String? nama, int? biayaMaksimal, int? biayaPerKm) async {
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
        String _nama = nama ?? "";
        String _biayaMaksimal = biayaMaksimal?.toString() ?? "";
        String _biayaPerKm = biayaPerKm?.toString() ?? "";

        var response = await client.get(
            Uri.parse(
                "${globals.http_to_server}api/pengirim/kurir/filter?nama=$_nama&biaya_maksimal=$_biayaMaksimal&biaya_per_km=$_biayaPerKm&username=$username&password=$password&id=$id"),
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

  // post create pengiriman barang
  static Future<Map<String, dynamic>> createPengirimanBarang(
      Map<String, dynamic> _datanya) async {
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
      try {
        String foto_path = _datanya['foto_path'];
        // log(foto_path.toString() + " ini datanya di pengiriman barang");
        // remove foto_path from _datanya
        _datanya.remove('foto_path');
        log(_datanya.toString());
        var postUri = Uri.parse(
            '${globals.http_to_server}api/pengirim/pengiriman_barang?username=$username&password=$password&id=$id');
        var request = http.MultipartRequest("POST", postUri);
        request.fields['data'] = jsonEncode(_datanya);
        request.files.add(
            await http.MultipartFile.fromPath('foto_pengiriman', foto_path));
        var streamResponse =
            await request.send().timeout(const Duration(seconds: 30));
        // var streamResponse = await request.send();
        var response = await http.Response.fromStream(streamResponse);

        var datanya = jsonDecode(response.body);

        log(datanya.toString() + " ini datanya di pengiriman barang");

        result = {
          'status': 200,
          'message': datanya['message'],
        };
      } catch (e) {
        log(e.toString() + " ini error");
        result = {'status': 500, 'message': e.toString()};
      }
    }

    return result;
  }

  // get log Kiriman
  static Future<Map<String, dynamic>> getLogKiriman() async {
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
        var response = await client.get(
            Uri.parse(
                "${globals.http_to_server}api/pengirim/log_kiriman?username=$username&password=$password&id=$id"),
            headers: {
              "Accept": "application/json",
              // "authorization":
              //     "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
              "crossDomain": "true"
            }).timeout(const Duration(seconds: 10));
        final data = jsonDecode(response.body);
        // log(data.toString());
        if (response.statusCode == 200) {
          result = {
            'status': 200,
            'message': "Berhasil mendapatkan log kiriman",
            'data': data['data']
          };
        } else {
          result = {
            'status': 500,
            'message': "Gagal mengambil data log kiriman",
            'data': data
          };
        }
      } catch (e) {
        log(e.toString() + " ini error");
        result = {
          'status': 500,
          'message':
              "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
        };
      }
    }

    return result;
  }

  static Future<double> jarak_route(
      double lat1, double lng1, double lat2, double lng2) async {
    client = http.Client();
    double jarak = 0;

    bool _cek_jaringan = await cek_jaringan(client);

    // log("cek jaringan : " + _cek_jaringan.toString());

    if (!_cek_jaringan) {
      jarak = 0;
    } else {
      try {
        var response = await client.get(
            Uri.parse(
                "https://maps.googleapis.com/maps/api/directions/json?origin=$lat1,$lng1&destination=$lat2,$lng2&key=${globals.api_key}"),
            headers: {
              "Accept": "application/json",
              // "authorization":
              //     "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
              "crossDomain": "true"
            }).timeout(const Duration(seconds: 10));

        // log()
        final data = jsonDecode(response.body);

        if (data["routes"].length > 0) {
          jarak = data["routes"][0]["legs"][0]["distance"]["value"] / 1000;
        } else {
          jarak = 0;
        }
      } catch (e) {
        jarak = 0;
      }
    }

    return jarak;
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
