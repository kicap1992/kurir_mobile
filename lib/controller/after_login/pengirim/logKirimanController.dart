// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kurir/api/pengirimApi.dart';
import 'package:kurir/function/allFunction.dart';
import 'package:kurir/models/pengirimimanModel.dart';

import 'package:kurir/globals.dart' as globals;

class LogKirimanController extends GetxController {
  Rx<Widget> widgetLogKiriman = const Center(
    child: CircularProgressIndicator(),
  ).obs;

  RxBool isPortrait = true.obs;

  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints _polylinePoints = PolylinePoints();
  String _googleAPiKey = globals.api_key;

  List<LatLng>? _listLatLng;

  // late GoogleMapController mapController;
  final _initialCameraPosition = const CameraPosition(
    target: LatLng(-3.5621854706823193, 119.7612856634139),
    zoom: 12.5,
  );

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    log("sini on init log kiriman");

    checkAllLogKiriman();
    // BuildContext? context;
    log(Get.context!.isLandscape.toString() + " is landscape");
    log(Get.context!.isPortrait.toString() + " is potret");
    super.onInit();
  }

  checkScreenOrientation() {
    if (Get.context!.isLandscape) {
      isPortrait.value = false;
    } else {
      isPortrait.value = true;
    }
  }

  checkAllLogKiriman() async {
    Map<String, dynamic> _data = await PengirimApi.getLogKiriman();
    log(_data.toString());
    // await 4 sec
    widgetLogKiriman.value = const Center(
      child: CircularProgressIndicator(),
    );

    if (_data['data'].length > 0) {
      List<Widget> _listWidget = [];

      for (var item in _data['data']) {
        PengirimanModel? _pengirimanModel = PengirimanModel.fromJson(item);
        // log(_pengiriman.kurir!.id.toString());
        _listWidget.add(_widgetLogKiriman(_pengirimanModel));

        // _listWidget.add(_widgetLogKiriman());
      }
      Widget _listview = Column(
        children: [
          ..._listWidget,
        ],
      );

      widgetLogKiriman.value = Center(
        child: Obx(
          () => Container(
            constraints: BoxConstraints(
              // maxHeight: Get.height * 0.65,
              maxHeight:
                  (isPortrait.value) ? Get.height * 0.62 : Get.height * 0.42,

              minHeight: Get.context!.height * 0.42,
            ),
            child: SingleChildScrollView(child: _listview),
          ),
        ),
      );
    } else {
      widgetLogKiriman.value = const Center(
        child: Text("Tidak ada log kiriman"),
      );
    }
  }

  _widgetLogKiriman(PengirimanModel? _pengirimanModel) {
    var _createdAtPlus8 = DateTime.parse(_pengirimanModel!.createdAt!)
        .add(const Duration(hours: 8));

    String _tanggal = DateFormat('dd-MM-yyyy').format(_createdAtPlus8);

    // add am/pm to jam
    String _jam = DateFormat('HH:mm:ss').format(_createdAtPlus8);

    String _nama_kurir = _pengirimanModel.kurir!.nama!;

    String _status = _pengirimanModel.statusPengiriman!;

    String _foto_pengiriman = _pengirimanModel.fotoPengiriman!;
    // log(_foto_pengiriman + " foto pengiriman");

    var _kordinat_pengiriman = _pengirimanModel.kordinatPengiriman!;
    var _kordinat_permulaan = _pengirimanModel.kordinatPermulaan!;

    Widget _listTilenya = Card(
      elevation: 2,
      child: Slidable(
        key: const ValueKey(1),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.80,
          // dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              flex: 2,
              onPressed: (context) {},
              backgroundColor: const Color.fromARGB(255, 70, 192, 232),
              foregroundColor: Colors.white,
              icon: Icons.info_outline_rounded,
              label: 'Info',
            ),
            SlidableAction(
              flex: 3,
              onPressed: (context) {
                _lihat_foto_kiriman(context, _foto_pengiriman);
              },
              backgroundColor: const Color.fromARGB(255, 71, 92, 250),
              foregroundColor: Colors.white,
              icon: Icons.photo_rounded,
              label: 'Barang Kiriman',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.5,
          children: [
            SlidableAction(
              onPressed: (context) {
                _lihat_rute_pengiriman(
                    context, _kordinat_pengiriman, _kordinat_permulaan);
              },
              backgroundColor: Color.fromARGB(255, 242, 78, 23),
              foregroundColor: Colors.white,
              icon: Icons.maps_home_work_rounded,
              label: "Rute Pengiriman",
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      " $_tanggal",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " $_jam",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _nama_kurir,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _status,
                      style: const TextStyle(
                        fontSize: 15,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    return _listTilenya;
  }

  _lihat_foto_kiriman(BuildContext context, String foto_pengiriman) {
    log(foto_pengiriman);
    if (foto_pengiriman != null && foto_pengiriman != "") {
      Get.dialog(
        AlertDialog(
          title: const Text("Foto Pengiriman"),
          content: Container(
            height: Get.height * 0.5,
            width: Get.width * 0.6,
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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/loading.gif'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(foto_pengiriman),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      Get.snackbar(
        "Info",
        "Foto Barang Pengiriman Masih Dalam Proses Upload",
        icon: Icon(
          Icons.info_outline_rounded,
          color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 71, 203, 240),
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  _lihat_rute_pengiriman(
      BuildContext context,
      KordinatPengiriman kordinat_pengiriman,
      KordinatPermulaan kordinat_permulaan) async {
    _markers.clear();
    _polylines.clear();
    _polylineCoordinates = [];
    _listLatLng = null;
    // _polylinePoints.clear();

    LatLng _latLng_pengiriman = LatLng(
      double.parse(kordinat_pengiriman.lat!),
      double.parse(kordinat_pengiriman.lng!),
    );

    LatLng _latLng_permulaan = LatLng(
      double.parse(kordinat_permulaan.lat!),
      double.parse(kordinat_permulaan.lng!),
    );
    _listLatLng = [
      LatLng(
        double.parse(kordinat_permulaan.lat!),
        double.parse(kordinat_permulaan.lng!),
      ),
      LatLng(
        double.parse(kordinat_pengiriman.lat!),
        double.parse(kordinat_pengiriman.lng!),
      ),
    ];

    await setPolylines(
      _latLng_pengiriman,
      _latLng_permulaan,
    );

    _markers.add(
      Marker(
        markerId: const MarkerId("permulaan"),
        position: LatLng(double.parse(kordinat_permulaan.lat!),
            double.parse(kordinat_permulaan.lng!)),
        infoWindow: InfoWindow(
          title: "Lokasi Permulaan",
        ),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId("pengiriman"),
        position: LatLng(double.parse(kordinat_pengiriman.lat!),
            double.parse(kordinat_pengiriman.lng!)),
        infoWindow: InfoWindow(
          title: "LokasiPengiriman",
        ),
      ),
    );
    // await 1 sec
    await Future.delayed(Duration(seconds: 1));
    Get.dialog(
      AlertDialog(
        content: Container(
          height: Get.height * 0.5,
          child: GoogleMap(
            mapType: MapType.hybrid,
            mapToolbarEnabled: true,
            rotateGesturesEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
            polylines: _polylines,
            // liteModeEnabled: true,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: _onBounds,
            // onCameraMove: _onCameraMove,
          ),
        ),
      ),
    );
  }

  setPolylines(LatLng latLng_pengiriman, LatLng latLng_permulaan) async {
    log("sini dia berlaku");
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
      _result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      Polyline polyline = Polyline(
        polylineId: PolylineId("poly"),
        color: Color.fromARGB(255, 40, 122, 198),
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

      log(distance.toString() + "ini dia");
    }
  }

  void _onBounds(GoogleMapController controller) {
    mapController = controller;
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        AllFunction.computeBounds(_listLatLng!),
        15,
      ),
    );
  }
}