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
    pengirimanAll();
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
    _polylineCoordinates.clear();
    markers.clear();
    polylines.clear();
  }

  pengirimanAll() async {
    loadPengiriman.value = 0;
    pengirimanModelList.value = [];

    final _api = Get.put(KurirApi());

    Map<String, dynamic> _data =
        await _api.getAllPengirimanDalamPengesahanKurir();

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
    final _api = Get.put(PengirimApi());
    double distance = await _api.jarak_route(
      latLngPermulaan.latitude,
      latLngPermulaan.longitude,
      latLngPengiriman.latitude,
      latLngPengiriman.longitude,
    );

    dev.log(distance.toString() + "ini dia");

    return distance;
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

    LatLng latLngPengiriman = LatLng(
      double.parse(data.kordinatPengiriman!.lat!),
      double.parse(data.kordinatPengiriman!.lng!),
    );

    LatLng latLngPermulaan = LatLng(
      double.parse(data.kordinatPermulaan!.lat!),
      double.parse(data.kordinatPermulaan!.lng!),
    );

    await setPolylines(
      latLngPengiriman,
      latLngPermulaan,
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

  setPolylines(LatLng latLngPengiriman, LatLng latLngPermulaan) async {
    PolylineResult _result = await _polylinePoints.getRouteBetweenCoordinates(
      _googleAPiKey,
      PointLatLng(latLngPermulaan.latitude, latLngPermulaan.longitude),
      PointLatLng(latLngPengiriman.latitude, latLngPengiriman.longitude),
      travelMode: TravelMode.driving,
      // travelMode: TravelMode.driving,
    );

    // log(_result.points.toString() + "ini dia");
    if (_result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      _listLatLng = [latLngPermulaan];
      for (var point in _result.points) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        _listLatLng!.add(LatLng(point.latitude, point.longitude));
      }
      _listLatLng!.add(latLngPengiriman);

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

  lihatFotoKiriman(BuildContext context, String fotoPengiriman) {
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

  void terimaPengiriman(String? sId) {
    // dev.log("terima pengiriman");
    // create get alert dialog
    Get.dialog(
      _TerimaBatalPengiriman(
        text: "terima",
        id: sId,
      ),
    );
  }

  // coba() {
  //   loadPengiriman.value = 0;
  //   pengirimanModelList.clear();
  //   dev.log(loadPengiriman.value.toString());
  //   dev.log(pengirimanModelList.toString());
  // }

  konfirmTerimaPengiriman(String? id) async {
    // dev.log("konfirm terima pengiriman $id");
    // coba();
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );

    final _api = Get.put(KurirApi());

    Map<String, dynamic> _data = await _api.sahkanPengiriman(id);
    if (_data['status'] == 200) {
      // loadPengiriman.value = 0;
      Get.snackbar(
        "Info",
        "Pengiriman Disahkan Oleh Anda\nBisa Klik 'Mengambil Paket' jika ingin mengambil paket",
        icon: const Icon(
          Icons.info_outline_rounded,
          color: Color.fromARGB(255, 2, 72, 72),
        ),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );

      // Get.back();
      // futre 1 sec
      // await Future.delayed(Duration(seconds: 1));
      // loadPengiriman.value = 0;
      // pengirimanModelList.value = [];
      // await pengirimanAll();
      // onReady();
      final ctrl = Get.put<PengirimanKurirController>(
        PengirimanKurirController(),
      );
      ctrl.onReady();
    } else {
      Get.snackbar(
        "Info",
        _data['message'],
        icon: const Icon(
          Icons.info_outline_rounded,
          color: Colors.red,
        ),
        backgroundColor: const Color.fromARGB(255, 199, 214, 234),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }

    await EasyLoading.dismiss();
  }

  void batalkanPengiriman(String? sId) {
    // Get
    Get.dialog(
      _TerimaBatalPengiriman(
        text: "batalkan",
        id: sId,
      ),
    );
  }

  void konfirmBatalPengiriman(String? id) {
    dev.log("konfirm batal pengiriman $id");
  }

  void mengambilPaket(String? sId) {
    // Get
    Get.dialog(
      _TerimaBatalPengiriman(id: sId, text: 'mengambil' // mengambil paket
          ),
    );
  }

  void konfirmasiMengambilPaket(String? id) async {
    // dev.log("konfirm terima pengiriman $id");
    // coba();
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );

    final _api = Get.put(KurirApi());

    Map<String, dynamic> _data = await _api.mengambilPaketPengiriman(id);
    if (_data['status'] == 200) {
      // loadPengiriman.value = 0;
      Get.snackbar(
        "Info",
        "Pengiriman Disahkan Oleh Anda\nBisa Klik 'Mengambil Paket' jika ingin mengambil paket",
        icon: const Icon(
          Icons.info_outline_rounded,
          color: Color.fromARGB(255, 2, 72, 72),
        ),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );

      // Get.back();
      // futre 1 sec
      // await Future.delayed(Duration(seconds: 1));
      // loadPengiriman.value = 0;
      // pengirimanModelList.value = [];
      // await pengirimanAll();
      // onReady();
      final ctrl = Get.put<PengirimanKurirController>(
        PengirimanKurirController(),
      );
      ctrl.onReady();
    } else {
      Get.snackbar(
        "Info",
        _data['message'],
        icon: const Icon(
          Icons.info_outline_rounded,
          color: Colors.red,
        ),
        backgroundColor: const Color.fromARGB(255, 199, 214, 234),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }

    await EasyLoading.dismiss();
  }
}

class _TerimaBatalPengiriman extends StatelessWidget {
  _TerimaBatalPengiriman({
    Key? key,
    this.id,
    required this.text,
  }) : super(key: key);

  final PengirimanKurirController controller = PengirimanKurirController();
  final String? id;
  final String text;

  @override
  Widget build(BuildContext context) {
    late String _text;
    switch (text) {
      case "terima":
        _text = "Anda akan menyetujui permintaan pengiriman ini";
        break;
      case "batalkan":
        _text = "Anda akan membatalkan permintaan pengiriman ini";
        break;
      case "mengambil":
        _text = "Anda akan mengambil paket pengiriman ini?";
        break;
    }

    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Info",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              _text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 75,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: (text != 'batalkan')
                          ? const Color.fromARGB(255, 2, 72, 72)
                          : Colors.red,
                    ),
                    onPressed: () {
                      Get.back();
                      switch (text) {
                        case "terima":
                          controller.konfirmTerimaPengiriman(id);
                          break;
                        case "batalkan":
                          controller.konfirmBatalPengiriman(id);
                          break;
                        case "mengambil":
                          controller.konfirmasiMengambilPaket(id);
                          break;
                      }

                      // if (text == 'terima') {
                      //   controller.konfirmTerimaPengiriman(id);
                      // } else {
                      //   controller.konfirmBatalPengiriman(id);
                      // }
                    },
                    child: const Text("Ya"),
                  ),
                ),
                SizedBox(
                  width: 75,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 104, 164, 164),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Tidak"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
      backgroundColor: const Color.fromARGB(255, 104, 164, 164),
      content: SizedBox(
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
                  return SizedBox(
                    width: 200,
                    child: TextFormField(
                      enabled: false,
                      style: const TextStyle(color: Colors.white),
                      initialValue: snapshot.data.toString() + " km",
                      decoration: InputDecoration(
                        labelText: 'Jarak Pengiriman',
                        labelStyle: const TextStyle(color: Colors.white),
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
                  return const Text(
                    "Error mengambil data",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                } else {
                  return const Center(
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
      backgroundColor: const Color.fromARGB(255, 104, 164, 164),
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
            // child: Container(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: NetworkImage(fotoPengiriman),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            child: Image.network(
              fotoPengiriman,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
