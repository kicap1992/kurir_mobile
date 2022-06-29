// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../globals.dart' as globals;

class BeforeLoginApi extends GetConnect {
  static final log = Logger();
  static var storage = GetStorage();

  Future<Map<String, dynamic>> sign_up_kurir(Map data, String fotoKTP,
      String fotoHoldingKTP, String fotoKendaraan, String fotoProfil) async {
    Map<String, dynamic> result;

    bool _checkServer = await cek_jaringan();

    if (_checkServer) {
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
            await request.send().timeout(const Duration(seconds: 120));
        // var streamResponse = await request.send();
        var response = await http.Response.fromStream(streamResponse);

        final datanya = jsonDecode(response.body);

        log.i(response.statusCode.toString() + " ini status code");
        log.i(datanya.toString());
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
        'message': "Tidak dapat terhubung ke server,koneksi timeout"
      };
    }

    return result;
  }

  // sign up pengirim
  Future<Map<String, dynamic>> sign_up_pengirim(
      Map data, String fotoProfil) async {
    Map<String, dynamic> result;

    bool _checkServer = await cek_jaringan();

    if (_checkServer) {
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
            await request.send().timeout(const Duration(seconds: 60));
        // var streamResponse = await request.send();
        var response = await http.Response.fromStream(streamResponse);

        // final form = FormData({
        //   'photo': MultipartFile(File(fotoProfil).readAsBytesSync(),
        //       filename: 'photo.jpg'),
        //   'data': jsonEncode(data),
        // });

        // final response =
        //     await post('${globals.http_to_server}api/login/daftar1', form);

        var datanya = jsonDecode(response.body);

        log.i(response.statusCode.toString() + " ini status code");
        log.i(datanya.toString());
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
        'message': "Tidak dapat terhubung ke server,koneksi timeout"
      };
    }

    return result;
  }

  // log in user
  Future<Map<String, dynamic>> log_in_user(
      String username, String password, String role) async {
    // client = http.Client();
    late Map<String, dynamic> result;

    bool _checkServer = await cek_jaringan();

    if (_checkServer) {
      try {
        await EasyLoading.show(
          status: 'Sedang\nLogin\n...',
          maskType: EasyLoadingMaskType.black,
        );

        // var _response = await get(
        //     '${globals.http_to_server}api/login?username=$username&password=$password&role=$role');
        var uri = Uri.parse(
            '${globals.http_to_server}api/login?username=$username&password=$password&role=$role');
        var _response = await http.get(uri, headers: {
          'Content-Type': 'application/json',
          "crossDomain": "true",
        }).timeout(const Duration(seconds: 15));

        var _data = jsonDecode(_response.body);

        log.i(_response.statusCode.toString() + " ini status code");
        log.i(_data['data']['_idnya'].toString() + " ini id");
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
      } on TimeoutException catch (e) {
        log.i(e.toString() + " ini timeout");
        result = {
          'status': 500,
          'message': "Tidak dapat terhubung ke server,koneksi timeout"
        };
      } on Exception catch (e) {
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
        'message': "Tidak dapat terhubung ke server,koneksi timeout"
      };
    }

    await EasyLoading.dismiss();
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
