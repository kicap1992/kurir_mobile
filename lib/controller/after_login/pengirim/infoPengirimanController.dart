// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:kurir/api/pengirimApi.dart';
import 'package:kurir/function/allFunction.dart';
import 'package:kurir/globals.dart' as globals;

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kurir/models/pengirimimanModel.dart';

class InfoPengirimanController extends GetxController {
  final dynamic _argumicData = Get.arguments;
  late PengirimanModel pengirimanModel;
  // late String jumlah_pembayaran;
  String dummyTest = "heheheheh";

  late GoogleMapController mapController;
  final _initialCameraPosition = const CameraPosition(
    target: LatLng(-3.5621854706823193, 119.7612856634139),
    zoom: 12.5,
  );
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  final PolylinePoints _polylinePoints = PolylinePoints();
  final String _googleAPiKey = globals.api_key;

  List<LatLng>? _listLatLng;
  TextEditingController distance_travel_controller = TextEditingController();
  TextEditingController price_controller = TextEditingController();

  RxBool loadingMaps = false.obs;

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    pengirimanModel = _argumicData['pengiriman_model'];
    dev.log(" ini idnya ${pengirimanModel.fotoPengiriman}");
    distance_travel_controller.text = "loading...";
    price_controller.text = "loading...";
    set_the_maps(pengirimanModel.kordinatPengiriman!,
        pengirimanModel.kordinatPermulaan!);
    super.onInit();
  }

  set_the_maps(KordinatPengiriman kordinat_pengiriman,
      KordinatPermulaan kordinat_permulaan) async {
    LatLng _latLng_pengiriman = LatLng(
      double.parse(kordinat_pengiriman.lat!),
      double.parse(kordinat_pengiriman.lng!),
    );

    LatLng _latLng_permulaan = LatLng(
      double.parse(kordinat_permulaan.lat!),
      double.parse(kordinat_permulaan.lng!),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId("permulaan"),
        position: LatLng(double.parse(kordinat_permulaan.lat!),
            double.parse(kordinat_permulaan.lng!)),
        infoWindow: const InfoWindow(
          title: "Lokasi Permulaan",
        ),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId("pengiriman"),
        position: LatLng(double.parse(kordinat_pengiriman.lat!),
            double.parse(kordinat_pengiriman.lng!)),
        infoWindow: const InfoWindow(
          title: "LokasiPengiriman",
        ),
      ),
    );
    await setPolylines(
      _latLng_pengiriman,
      _latLng_permulaan,
    );
  }

  setPolylines(LatLng latLng_pengiriman, LatLng latLng_permulaan) async {
    // dev.log("sini dia berlaku");
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
      loadingMaps.value = true;
      // GoogleMapController _controller2;
      // _onBounds(_controller2);

      Polyline polyline = Polyline(
        polylineId: const PolylineId("poly"),
        color: const Color.fromARGB(255, 40, 122, 198),
        points: _polylineCoordinates,
        width: 3,
      );
      _polylines.add(polyline);

      double distance = await PengirimApi.jarak_route(
        latLng_permulaan.latitude,
        latLng_permulaan.longitude,
        latLng_pengiriman.latitude,
        latLng_pengiriman.longitude,
      );

      // dev.log(distance.toString() + "ini dia");
      distance_travel_controller.text = "$distance km";
      double _min_price = distance * pengirimanModel.biaya!.biayaPerKilo! +
          pengirimanModel.biaya!.biayaMinimal!;
      // rounded to the nearest 1000
      _min_price = (_min_price / 1000).round() * 1000;
      double _max_price = distance * pengirimanModel.biaya!.biayaPerKilo! +
          pengirimanModel.biaya!.biayaMaksimal!;
      // rounded to the nearest 1000
      _max_price = (_max_price / 1000).round() * 1000;
      price_controller.text =
          "Rp. ${AllFunction.thousandSeperatorDouble(_min_price)} - Rp. ${AllFunction.thousandSeperatorDouble(_max_price)}";
      loadingMaps.value = true;
    }
  }

  show_maps_dialog() async {
    await EasyLoading.show(
      status: 'Loading Peta',
      maskType: EasyLoadingMaskType.black,
    );
    Get.dialog(
      AlertDialog(
        title: const Text("Rute Pengiriman"),
        content: Container(
          height: Get.height * 0.5,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 200,
                  maxHeight: 300,
                  minWidth: 300,
                  maxWidth: 500,
                ),
                child: googleMaps(),
              ),
            ),
          ),
        ),
      ),
    );
    await EasyLoading.dismiss();
  }

  Widget googleMaps() {
    return GoogleMap(
      mapType: MapType.normal,
      mapToolbarEnabled: true,
      rotateGesturesEnabled: true,
      myLocationButtonEnabled: true,
      markers: _markers,
      polylines: _polylines,
      // liteModeEnabled: true,
      initialCameraPosition: _initialCameraPosition,
      onMapCreated: _onBounds,
      // onCameraMove: _onCameraMove,
    );
  }

  void _onBounds(GoogleMapController controller) {
    mapController = controller;
    if (_listLatLng != null)
      // ignore: curly_braces_in_flow_control_structures
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          AllFunction.computeBounds(_listLatLng!),
          15,
        ),
      );
  }

  show_kurir_dialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Detail Kurir"),
        content: SizedBox(
          height: Get.height * 0.5,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10, color: Colors.grey, spreadRadius: 5)
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: const AssetImage('assets/loading.gif'),
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(
                          pengirimanModel.kurir!.photo_url ??
                              'https://via.placeholder.com/150'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: const BoxDecoration(
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
                        color: Colors.white,
                      ),
                      width: 200,
                      height: 200,
                      child: Image.network(
                        pengirimanModel.kurir!.kenderaan_url ??
                            "https://via.placeholder.com/150",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  readOnly: true,
                  initialValue: "Rp. " +
                      AllFunction.thousandsSeperator(
                          pengirimanModel.biaya!.biayaMinimal!),
                  // maxLength: 13,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Colors.blue,
                    ),
                    labelText: 'Harga Minimal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  readOnly: true,
                  initialValue: "Rp. " +
                      AllFunction.thousandsSeperator(
                          pengirimanModel.biaya!.biayaMaksimal!),
                  // maxLength: 13,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Colors.blue,
                    ),
                    labelText: 'Harga Maksimal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  readOnly: true,
                  initialValue: "Rp. " +
                      AllFunction.thousandsSeperator(
                          pengirimanModel.biaya!.biayaPerKilo!),
                  // maxLength: 13,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Colors.blue,
                    ),
                    labelText: 'Biaya Per Kilometer',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  show_foto_pengiriman() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          height: Get.height * 0.5,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 5)
            ],
            image: DecorationImage(
              image: AssetImage('assets/loading.gif'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                image: NetworkImage(pengirimanModel.fotoPengiriman ??
                    "https://via.placeholder.com/150"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
