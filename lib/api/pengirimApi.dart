// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../globals.dart' as globals;

class PengirimApi extends GetConnect {
  static var storage = GetStorage();

  static var username = storage.read("username");
  static var password = storage.read("password");
  static var id = storage.read("id");

  final log = Logger();

  // get all kurir
  Future<Map<String, dynamic>> getAllKurir() async {
    late Map<String, dynamic> result;

    bool _checkServer = await cek_jaringan();

    if (_checkServer) {
      await EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.black,
      );
      try {
        var response = await http.get(
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
      } on SocketException catch (e) {
        // abort the client
        await EasyLoading.dismiss();
        // closeClient();

        log.i(e.toString() + " ini error socket");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } on TimeoutException catch (e) {
        // client.close();
        log.i(e.toString() + " ini timeout");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } on Exception catch (e) {
        // client.close();
        log.i(e.toString() + " ini error");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } catch (e) {
        log.i(e.toString() + " ini di catch");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } finally {
        await EasyLoading.dismiss();
      }
    } else {
      result = {
        'status': 500,
        'message':
            "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
      };
    }

    return result;
  }

  // get kurir by nama
  Future<Map<String, dynamic>> getKurirByNama(String nama) async {
    late Map<String, dynamic> result;

    bool _checkServer = await cek_jaringan();

    if (_checkServer) {
      try {
        await EasyLoading.show(
          status: 'Loading...',
          maskType: EasyLoadingMaskType.black,
        );
        var response = await http.get(
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
      } on SocketException catch (e) {
        // abort the client
        await EasyLoading.dismiss();
        // closeClient();

        log.i(e.toString() + " ini error socket");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } on TimeoutException catch (e) {
        // client.close();
        log.i(e.toString() + " ini timeout");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } on Exception catch (e) {
        // client.close();
        log.i(e.toString() + " ini error");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } catch (e) {
        log.i(e.toString() + " ini di catch");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } finally {
        await EasyLoading.dismiss();
      }
    } else {
      result = {
        'status': 500,
        'message':
            "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
      };
    }

    return result;
  }

  // get kurir by nama
  Future<Map<String, dynamic>> getKurirByFilter(
      String? nama, int? biayaMaksimal, int? biayaPerKm) async {
    late Map<String, dynamic> result;

    bool _checkServer = await cek_jaringan();

    if (_checkServer) {
      await EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.black,
      );
      try {
        String _nama = nama ?? "";
        String _biayaMaksimal = biayaMaksimal?.toString() ?? "";
        String _biayaPerKm = biayaPerKm?.toString() ?? "";

        var response = await http.get(
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
      } on SocketException catch (e) {
        // abort the client
        await EasyLoading.dismiss();
        // closeClient();

        log.i(e.toString() + " ini error socket");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } on TimeoutException catch (e) {
        // client.close();
        log.i(e.toString() + " ini timeout");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } on Exception catch (e) {
        // client.close();
        log.i(e.toString() + " ini error");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } catch (e) {
        log.i(e.toString() + " ini di catch");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } finally {
        await EasyLoading.dismiss();
      }
    } else {
      result = {
        'status': 500,
        'message':
            "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
      };
    }

    return result;
  }

  // post create pengiriman barang
  Future<Map<String, dynamic>> createPengirimanBarang(
      Map<String, dynamic> _datanya) async {
    late Map<String, dynamic> result;

    bool _checkServer = await cek_jaringan();

    if (_checkServer) {
      try {
        await EasyLoading.show(
          status: 'Loading...',
          maskType: EasyLoadingMaskType.black,
        );
        String foto_path = _datanya['foto_path'];
        // log(foto_path.toString() + " ini datanya di pengiriman barang");
        // remove foto_path from _datanya
        _datanya.remove('foto_path');
        var postUri = Uri.parse(
            '${globals.http_to_server}api/pengirim/pengiriman_barang?username=$username&password=$password&id=$id');
        var request = http.MultipartRequest("POST", postUri);
        request.fields['data'] = jsonEncode(_datanya);
        request.files.add(
            await http.MultipartFile.fromPath('foto_pengiriman', foto_path));
        var streamResponse =
            await request.send().timeout(const Duration(seconds: 60));
        // var streamResponse = await request.send();
        var response = await http.Response.fromStream(streamResponse);

        var datanya = jsonDecode(response.body);

        result = {
          'status': 200,
          'message': datanya['message'],
        };
      } on SocketException catch (e) {
        // abort the client
        // closeClient();

        log.i(e.toString() + " ini error socket");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } on TimeoutException catch (e) {
        // client.close();
        log.i(e.toString() + " ini timeout");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } on Exception catch (e) {
        // client.close();
        log.i(e.toString() + " ini error");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } catch (e) {
        log.i(e.toString() + " ini di catch");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } finally {
        await EasyLoading.dismiss();
      }
    } else {
      result = {
        'status': 500,
        'message':
            "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
      };
    }

    return result;
  }

  // get log Kiriman
  Future<Map<String, dynamic>> getLogKiriman() async {
    late Map<String, dynamic> result;

    bool _checkServer = await cek_jaringan();

    if (_checkServer) {
      try {
        var response = await http.get(
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
      } on SocketException {
        // abort the client
        // closeClient();

        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } on TimeoutException {
        // client.close();
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } on Exception {
        // client.close();
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } catch (e) {
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } finally {
        await EasyLoading.dismiss();
      }
    } else {
      result = {
        'status': 500,
        'message':
            "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
      };
    }

    return result;
  }

  Future<double> jarak_route(
      double lat1, double lng1, double lat2, double lng2) async {
    double jarak = 0;

    try {
      var response = await http.get(
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

    return jarak;
  }

  // checking connection to server
  Future<bool> cek_jaringan() async {
    late bool result;

    // client get for globals.http_to_server
    await EasyLoading.show(
      status: 'Sedang\nCek\nJaringan\n...',
      maskType: EasyLoadingMaskType.black,
    );

    try {
      var response =
          await http.get(Uri.parse("${globals.http_to_server}api"), headers: {
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
      result = false;
      // await clientClose(client);
      log.i(" ini error socket");
    } on TimeoutException {
      await EasyLoading.dismiss();
      result = false;
      // close client
      // await clientClose(client);
      log.i(" ini timeout");
    } on Exception {
      result = false;
      log.i(" ini timeout");
    } catch (e) {
      result = false;
      log.i(" ini timeout");
    } finally {
      await EasyLoading.dismiss();
    }

    return result;
  }
}
