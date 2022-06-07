// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

class BeforeLoginApi extends ChangeNotifier {
// class BeforeLoginApi {
  static var client = http.Client();

  static var storage = GetStorage();

  static clientClose(http.Client client) {
    client.close();
  }

  // sign up kurir
  static Future<Map<String, dynamic>> sign_up_kurir(Map data, String fotoKTP,
      String fotoHoldingKTP, String fotoKendaraan, String fotoProfil) async {
    Map<String, dynamic> result;
    client = http.Client();
    // result = "sini berlakunya signup";
    bool _cek_jaringan = await cek_jaringan(client);

    if (_cek_jaringan) {
      try {
        await EasyLoading.show(
          status: 'Melakukan\nPendaftaran...',
          maskType: EasyLoadingMaskType.black,
        );
        var postUri = Uri.parse('${globals.http_to_server}api/login/daftar1');
        var request = http.MultipartRequest("POST", postUri);
        request.fields['data'] = jsonEncode(data);
        request.files
            .add(await http.MultipartFile.fromPath('ktp_photo', fotoKTP));
        request.files.add(await http.MultipartFile.fromPath(
            'ktp_holding_photo', fotoHoldingKTP));
        request.files.add(await http.MultipartFile.fromPath(
            'kenderaan_photo', fotoKendaraan));
        request.files
            .add(await http.MultipartFile.fromPath('photo', fotoProfil));

        var streamResponse =
            await request.send().timeout(const Duration(seconds: 30));
        // var streamResponse = await request.send();
        var response = await http.Response.fromStream(streamResponse);

        var datanya = jsonDecode(response.body);

        log(response.statusCode.toString() + " ini status code");
        log(datanya.toString());
        if (response.statusCode == 200) {
          result = {
            'status': response.statusCode,
            'message': datanya['message'],
          };
        } else {
          result = {
            'status': response.statusCode,
            'message': datanya['message']
          };
        }
      } on SocketException catch (e) {
        // abort the client
        await EasyLoading.dismiss();
        // closeClient();

        log(e.toString() + " ini error socket");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } on TimeoutException catch (e) {
        // client.close();
        log(e.toString() + " ini timeout");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } catch (e) {
        log(e.toString() + " ini di catch");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      }
    } else {
      result = {
        'status': 500,
        'message': "Tidak dapat terhubung ke server,koneksi timeout"
      };
    }

    return result;
  }

  // sign up pengirim
  static Future<Map<String, dynamic>> sign_up_pengirim(
      Map data, String fotoProfil) async {
    // open client
    client = http.Client();
    Map<String, dynamic> result;
    // result = {'status': 500, 'message': "sini berlakunya signup pengirim"};

    bool _cek_jaringan = await cek_jaringan(client);

    log("cek jaringan : " + _cek_jaringan.toString());

    if (!_cek_jaringan) {
      result = {
        'status': 500,
        'message':
            "Tidak dapat terhubung ke server, Sila periksa koneksi internet anda"
      };
    } else {
      if (_cek_jaringan) {
        try {
          await EasyLoading.show(
            status: 'Melakukan\nPendaftaran...',
            maskType: EasyLoadingMaskType.black,
          );
          var postUri = Uri.parse('${globals.http_to_server}api/login/daftar1');
          var request = http.MultipartRequest("POST", postUri);
          request.fields['data'] = jsonEncode(data);

          request.files
              .add(await http.MultipartFile.fromPath('photo', fotoProfil));

          var streamResponse =
              await request.send().timeout(const Duration(seconds: 30));
          // var streamResponse = await request.send();
          var response = await http.Response.fromStream(streamResponse);

          var datanya = jsonDecode(response.body);

          log(response.statusCode.toString() + " ini status code");
          log(datanya.toString());
          if (response.statusCode == 200) {
            result = {
              'status': response.statusCode,
              'message': datanya['message'],
            };
          } else {
            result = {
              'status': response.statusCode,
              'message': datanya['message']
            };
          }
        } on SocketException catch (e) {
          // abort the client
          await EasyLoading.dismiss();
          // closeClient();

          log(e.toString() + " ini error socket");
          result = {
            'status': 500,
            'message': "Tidak dapat terhubung ke server,koneksi timeout"
          };
        } on TimeoutException catch (e) {
          // client.close();
          log(e.toString() + " ini timeout");
          result = {
            'status': 500,
            'message': "Tidak dapat terhubung ke server,koneksi timeout"
          };
        } catch (e) {
          log(e.toString() + " ini di catch");
          result = {
            'status': 500,
            'message': "Tidak dapat terhubung ke server,koneksi timeout"
          };
        }
      } else {
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      }
    }

    return result;
  }

  // log in user
  static Future<Map<String, dynamic>> log_in_user(
      String username, String password, String role) async {
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
      try {
        await EasyLoading.show(
          status: 'Sedang\nLogin\n...',
          maskType: EasyLoadingMaskType.black,
        );
        var _url = Uri.parse(
            '${globals.http_to_server}api/login?username=$username&password=$password&role=$role');
        var _response = await http.get(
          _url,
          // body: {'username': username, 'password': password, 'role': role},
          headers: {
            "Accept": "application/json",
            // "authorization":
            //     "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
            "crossDomain": "true"
          },
        );

        var _data = jsonDecode(_response.body);

        log(_response.statusCode.toString() + " ini status code");
        log(_data['data']['_idnya'].toString() + " ini id");
        if (_response.statusCode == 200) {
          storage.write('username', username);
          storage.write('password', password);
          storage.write('role', role);
          storage.write('id', _data['data']['_idnya']);
          result = {
            'status': _response.statusCode,
            'message': _data['message'],
            'focus': _data['data'],
          };
        } else {
          storage.remove('username');
          storage.remove('password');
          storage.remove('role');
          result = {
            'status': _response.statusCode,
            'message': _data['message'],
            'focus': _data['data'],
          };
        }
      } catch (e) {
        storage.erase();
        log(e.toString() + " ini di catch");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      }
    }

    return result;
  }

  // logout user
  static Future<void> logout() async {
    storage.remove('username');
    storage.remove('password');
    storage.remove('role');
    storage.remove('id');
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

  // // checking connection to server
  // Future<bool> cek_jaringan1(http.Client client) async {
  //   late bool result;

  //   // client get for globals.http_to_server
  //   try {
  //     var response =
  //         await client.get(Uri.parse("${globals.http_to_server}api"), headers: {
  //       "Accept": "application/json",
  //       // "authorization":
  //       //     "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
  //       "crossDomain": "true"
  //     }).timeout(const Duration(seconds: 5));
  //     // final data = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       result = true;
  //     } else {
  //       result = false;
  //     }
  //   } on SocketException {
  //     await EasyLoading.dismiss();
  //     result = false;
  //     await clientClose(client);
  //     log(" ini error socket");
  //   } on TimeoutException {
  //     await EasyLoading.dismiss();
  //     result = false;
  //     // close client
  //     await clientClose(client);
  //     log(" ini timeout");
  //   } on Exception {
  //     result = false;
  //     log(" ini timeout");
  //   } catch (e) {
  //     result = false;
  //     log(" ini timeout");
  //   }

  //   return result;
  // }

}
