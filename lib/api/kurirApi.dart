// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

class KurirApi extends GetConnect {
  static var storage = GetStorage();

  static var username = storage.read("username");
  static var password = storage.read("password");
  static var id = storage.read("id");

  // get all pengiriman status ='Dalam Pengesahan Kurir'
  Future<Map<String, dynamic>> getAllPengirimanDalamPengesahanKurir() async {
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
        'message': "Tidak dapat terhubung ke server,koneksi timeout"
      };
    }

    return result;
  }

  // get all pengiriman status ='Paket Diterima Oleh Penerima, Ditolak Oleh Kurir, Dibatalkan Oleh Pengirim'
  Future<Map<String, dynamic>> getAllPengirimanCompleted() async {
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
                "${globals.http_to_server}api/kurir/pengiriman_completed?username=$username&password=$password&id=$id"),
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
        'message': "Tidak dapat terhubung ke server,koneksi timeout"
      };
    }

    return result;
  }

  // cek pengaturan kurir
  Future<Map<String, dynamic>> cekPengaturanKurir() async {
    late Map<String, dynamic> result;

    bool _checkServer = await cek_jaringan();

    if (_checkServer) {
      await EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.black,
      );

      try {
        log("${globals.http_to_server}api/kurir/pengaturan?username=$username&password=$password&id=$id");
        var response = await http.get(
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
        'message': "Tidak dapat terhubung ke server,koneksi timeout"
      };
    }

    return result;
  }

  // tambah/edit pengaturan kurir
  Future<Map<String, dynamic>> pengaturanKurir(
      String minimalBiaya, String maksimalBiaya, String biayaPerKilo) async {
    late Map<String, dynamic> result;

    bool _checkServer = await cek_jaringan();

    if (_checkServer) {
      try {
        await EasyLoading.show(
          status: 'Loading...',
          maskType: EasyLoadingMaskType.black,
        );
        var response = await http.post(
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
        'message': "Tidak dapat terhubung ke server,koneksi timeout"
      };
    }

    return result;
  }

  // terima pengiriman kurir dan ubah status ke 'Pengiriman Disahkan kurir'
  Future<Map<String, dynamic>> sahkanPengiriman(String? idPengiriman) async {
    late Map<String, dynamic> result;

    bool _checkServer = await cek_jaringan();

    if (_checkServer) {
      try {
        var response = await http.post(
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
        'message': "Tidak dapat terhubung ke server,koneksi timeout"
      };
    }

    return result;
  }

  Future<Map<String, dynamic>> detailPengiriman(String idPengiriman) async {
    late Map<String, dynamic> result;

    bool _checkServer = await cek_jaringan();

    if (_checkServer) {
      try {
        var response = await http.get(
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
        'message': "Tidak dapat terhubung ke server,koneksi timeout"
      };
    }

    return result;
  }

  Future<Map<String, dynamic>> mengambilPaketPengiriman(
      String? idPengiriman) async {
    late Map<String, dynamic> result;

    bool _checkServer = await cek_jaringan();

    if (_checkServer) {
      try {
        var response = await http.post(
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
        'message': "Tidak dapat terhubung ke server,koneksi timeout"
      };
    }

    return result;
  }

  // checking connection to server
  // ignore: non_constant_identifier_names
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
    } on TimeoutException {
      result = false;
      // close client
      // await clientClose(client);
    } on Exception {
      result = false;
    } catch (e) {
      result = false;
    } finally {
      await EasyLoading.dismiss();
    }

    return result;
  }
}
