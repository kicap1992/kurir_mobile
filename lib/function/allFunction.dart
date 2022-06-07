// ignore_for_file: file_names, non_constant_identifier_names
import 'dart:developer' as dev;
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:maps_toolkit/maps_toolkit.dart' as mp;

class AllFunction {
  static LatLngBounds computeBounds(List<LatLng> list) {
    // assert(list.isNotEmpty);
    var firstLatLng = list.first;
    var s = firstLatLng.latitude,
        n = firstLatLng.latitude,
        w = firstLatLng.longitude,
        e = firstLatLng.longitude;
    for (var i = 1; i < list.length; i++) {
      var latlng = list[i];
      s = min(s, latlng.latitude);
      n = max(n, latlng.latitude);
      w = min(w, latlng.longitude);
      e = max(e, latlng.longitude);
    }
    return LatLngBounds(southwest: LatLng(s, w), northeast: LatLng(n, e));
  }

  static LatLng centerBounds(List<LatLng> list) {
    // assert(list.isNotEmpty);
    var firstLatLng = list.first;
    var s = firstLatLng.latitude,
        n = firstLatLng.latitude,
        w = firstLatLng.longitude,
        e = firstLatLng.longitude;
    for (var i = 1; i < list.length; i++) {
      var latlng = list[i];
      s = min(s, latlng.latitude);
      n = max(n, latlng.latitude);
      w = min(w, latlng.longitude);
      e = max(e, latlng.longitude);
    }
    return LatLng(
      (s + n) / 2,
      (w + e) / 2,
    );
  }

  static bool cekMarkerOffside(LatLng latLng, List<LatLng> polyline) {
    // dev.log("cek marker offside");
    // dev.log(latLng.toString() + "ini latlng");
    // dev.log(polyline.toString() + "ini polyline");
    final MPLatLng = mp.LatLng(latLng.latitude, latLng.longitude);
    final MPLatLngList =
        polyline.map((e) => mp.LatLng(e.latitude, e.longitude)).toList();
    bool isOffside = mp.PolygonUtil.containsLocation(
      MPLatLng,
      MPLatLngList,
      false,
    );
    return isOffside;
  }

  static String thousandsSeperator(int number) {
    final formatter = NumberFormat('#,###');
    final numbernya = formatter.format(number);
    // log(numbernya + " ini numbernya");
    return numbernya.toString();
  }

  static removeComma(String number) {
    final numbernya = number.replaceAll(RegExp(r','), '');
    return numbernya;
  }

  static double check_distance_between(LatLng latLng1, LatLng latLng2) {
    var distance = mp.SphericalUtil.computeDistanceBetween(
      mp.LatLng(latLng1.latitude, latLng1.longitude),
      mp.LatLng(latLng2.latitude, latLng2.longitude),
    );
    distance = distance / 1000;
    double result = double.parse(distance.toStringAsFixed(2));
    return result;
  }

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    dev.log("sini berlaku");
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
