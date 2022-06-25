// ignore_for_file: file_names

import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kurir/function/allFunction.dart';

import '../../../api/kurirApi.dart';
import '../../../api/pengirimApi.dart';
import '../../../models/pengirimimanModel.dart';

import 'package:kurir/globals.dart' as globals;

class PengirimanKurirController extends GetxController {
  RxList pengirimanModelList = [].obs;
  RxInt loadPengiriman = 0.obs;

  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  List<LatLng> _polylineCoordinates = [];
  final PolylinePoints _polylinePoints = PolylinePoints();
  final String _googleAPiKey = globals.api_key;

  List<LatLng>? _listLatLng;

  // late GoogleMapController mapController;
  final _initialCameraPosition = const CameraPosition(
    target: LatLng(-3.5621854706823193, 119.7612856634139),
    zoom: 12.5,
  );

  @override
  void onReady() {
    super.onReady();
    dev.log("sini on ready pengiriman");
    pengirimanAll();
  }

  pengirimanAll() async {
    loadPengiriman.value = 0;
    pengirimanModelList.value = [];
    Map<String, dynamic> _data =
        await KurirApi.getAllPengirimanDalamPengesahanKurir();

    if (_data['status'] == 200) {
      if (_data['data'].length > 0) {
        pengirimanModelList.value =
            _data['data'].map((e) => PengirimanModel.fromJson(e)).toList();
      } else {
        pengirimanModelList.value = [];
      }
      loadPengiriman.value = 1;
    } else {
      pengirimanModelList.value = [];
      loadPengiriman.value = 2;
    }
  }

  String timeZoneAdd8(time) {
    // add 8 hours to timezone
    // createdAt.add(Duration(hours: 8));
    // dev.log(createdAt.toString());
    var _time = DateTime.parse(time).add(const Duration(hours: 8));
    // dev.log(_time.toString());
    // seperate date and time
    var _date = _time.toString().split(" ")[0];
    var _time2 = _time.toString().split(" ")[1];
    // only take the hour and minute
    _time2 = _time2.split(":")[0] + ":" + _time2.split(":")[1];
    // if the hour is less than 10, add 0 before
    if (_time2.split(":")[0].length == 1) {
      _time2 = "0" + _time2;
    }
    // if the minute is less than 10, add 0 before
    if (_time2.split(":")[1].length == 1) {
      _time2 = _time2 + "0";
    }
    // if past 12:00, add "PM"
    if (int.parse(_time2.split(":")[0]) >= 12) {
      _time2 = _time2 + " PM";
    } else {
      _time2 = _time2 + " AM";
    }

    return _date + " | " + _time2;
  }

  String cekHarga(
      double distance, int biayaMinimal, int biayaMaksimal, int biayaPerKilo) {
    //
    double hargaPerKiloTotal = biayaPerKilo * distance;
    double hargaTotalMinimal = hargaPerKiloTotal + biayaMinimal;
    double hargaTotalMaksimal = hargaPerKiloTotal + biayaMaksimal;

    return "Rp. " +
        AllFunction.thousandSeperatorDouble(hargaTotalMinimal) +
        " - Rp. " +
        AllFunction.thousandSeperatorDouble(hargaTotalMaksimal);
  }

  cekDistance(LatLng latLngPengiriman, LatLng latLngPermulaan) async {
    dev.log("sini dia berlaku");
    PolylineResult _result = await _polylinePoints.getRouteBetweenCoordinates(
      _googleAPiKey,
      PointLatLng(latLngPermulaan.latitude, latLngPermulaan.longitude),
      PointLatLng(latLngPengiriman.latitude, latLngPengiriman.longitude),
      travelMode: TravelMode.driving,
      // travelMode: TravelMode.driving,
    );

    // log(_result.points.toString() + "ini dia");
    if (_result.points.isNotEmpty) {
      double distance = await PengirimApi.jarak_route(
        latLngPermulaan.latitude,
        latLngPermulaan.longitude,
        latLngPengiriman.latitude,
        latLngPengiriman.longitude,
      );

      dev.log(distance.toString() + "ini dia");

      return distance;
    } else {
      return 0;
    }
  }

  void showMapDialog(BuildContext context, PengirimanModel data) async {
    await EasyLoading.show(
      status: 'Loading Peta...',
      maskType: EasyLoadingMaskType.black,
    );
    markers.clear();
    polylines.clear();
    _polylineCoordinates = [];
    _listLatLng = null;
    // _polylinePoints.clear();

    LatLng _latLng_pengiriman = LatLng(
      double.parse(data.kordinatPengiriman!.lat!),
      double.parse(data.kordinatPengiriman!.lng!),
    );

    LatLng _latLng_permulaan = LatLng(
      double.parse(data.kordinatPermulaan!.lat!),
      double.parse(data.kordinatPermulaan!.lng!),
    );

    await setPolylines(
      _latLng_pengiriman,
      _latLng_permulaan,
    );

    markers.add(
      Marker(
        markerId: const MarkerId("permulaan"),
        position: LatLng(double.parse(data.kordinatPermulaan!.lat!),
            double.parse(data.kordinatPermulaan!.lng!)),
        infoWindow: const InfoWindow(
          title: "Lokasi Permulaan",
        ),
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId("pengiriman"),
        position: LatLng(double.parse(data.kordinatPengiriman!.lat!),
            double.parse(data.kordinatPengiriman!.lng!)),
        infoWindow: const InfoWindow(
          title: "LokasiPengiriman",
        ),
      ),
    );
    // await 1 sec
    // await Future.delayed(Duration(seconds: 1));
    Get.dialog(_MapDialogBox(
      data: data,
      onBounds: onBounds,
      markers: markers,
      polylines: polylines,
      initialCameraPosition: _initialCameraPosition,
      cekDistance: cekDistance,
    ));

    await EasyLoading.dismiss();
  }

  setPolylines(LatLng latLng_pengiriman, LatLng latLng_permulaan) async {
    PolylineResult _result = await _polylinePoints.getRouteBetweenCoordinates(
      _googleAPiKey,
      PointLatLng(latLng_permulaan.latitude, latLng_permulaan.longitude),
      PointLatLng(latLng_pengiriman.latitude, latLng_pengiriman.longitude),
      travelMode: TravelMode.driving,
      // travelMode: TravelMode.driving,
    );

    // log(_result.points.toString() + "ini dia");
    if (_result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      _listLatLng = [latLng_permulaan];
      for (var point in _result.points) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        _listLatLng!.add(LatLng(point.latitude, point.longitude));
      }
      _listLatLng!.add(latLng_pengiriman);

      Polyline polyline = Polyline(
        polylineId: const PolylineId("poly"),
        color: const Color.fromARGB(255, 40, 122, 198),
        points: _polylineCoordinates,
        width: 3,
      );
      polylines.add(polyline);
    }
  }

  void onBounds(GoogleMapController controller) {
    mapController = controller;
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        AllFunction.computeBounds(_listLatLng!),
        15,
      ),
    );
  }

  lihat_foto_kiriman(BuildContext context, String fotoPengiriman) {
    if (fotoPengiriman != "") {
      Get.dialog(
        _FotoPengirimanDialogBox(
          fotoPengiriman: fotoPengiriman,
        ),
      );
    } else {
      Get.snackbar(
        "Info",
        "Foto Barang Pengiriman Masih Dalam Proses Upload",
        icon: const Icon(
          Icons.info_outline_rounded,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 71, 203, 240),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}

class _MapDialogBox extends StatelessWidget {
  const _MapDialogBox(
      {Key? key,
      required this.markers,
      required this.polylines,
      required this.onBounds,
      required this.initialCameraPosition,
      required this.cekDistance,
      required this.data})
      : super(key: key);

  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final void Function(GoogleMapController controller) onBounds;
  final CameraPosition initialCameraPosition;
  final PengirimanModel data;
  final Function cekDistance;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 104, 164, 164),
      content: Container(
        height: Get.height * 0.5,
        child: GoogleMap(
          mapType: MapType.normal,
          mapToolbarEnabled: true,
          rotateGesturesEnabled: true,
          myLocationButtonEnabled: true,
          markers: markers,
          polylines: polylines,
          // liteModeEnabled: true,
          initialCameraPosition: initialCameraPosition,
          onMapCreated: onBounds,
          // onCameraMove: _onCameraMove,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(),
            FutureBuilder(
              future: cekDistance(
                  LatLng(double.parse(data.kordinatPengiriman!.lat!),
                      double.parse(data.kordinatPengiriman!.lng!)),
                  LatLng(double.parse(data.kordinatPermulaan!.lat!),
                      double.parse(data.kordinatPermulaan!.lng!))),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: 200,
                    child: TextFormField(
                      enabled: false,
                      style: TextStyle(color: Colors.white),
                      initialValue: snapshot.data.toString() + " km",
                      decoration: InputDecoration(
                        labelText: 'Jarak Pengiriman',
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.transparent,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    "Error mengambil data",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox()
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class _FotoPengirimanDialogBox extends StatelessWidget {
  const _FotoPengirimanDialogBox({Key? key, required this.fotoPengiriman})
      : super(key: key);

  final String fotoPengiriman;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 104, 164, 164),
      title: const Text(
        "Foto Pengiriman",
        style: TextStyle(color: Colors.white),
      ),
      content: Container(
        height: Get.height * 0.5,
        width: Get.width * 0.6,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/loading.gif'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(fotoPengiriman),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
