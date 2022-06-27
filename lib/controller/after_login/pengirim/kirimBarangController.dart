// ignore_for_file: file_names, non_constant_identifier_names, invalid_use_of_protected_member, prefer_const_constructors

import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kurir/api/pengirimApi.dart';
import 'package:kurir/api/petaApi.dart';
import 'package:kurir/function/allFunction.dart';
import 'package:kurir/models/kurirModel.dart';
import 'package:kurir/models/petaModel.dart';
import 'package:kurir/models/usersModel.dart';
import 'package:kurir/widgets/boxBackgroundDecoration.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kurir/widgets/ourContainer.dart';
import 'package:kurir/widgets/thousandSeparator.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';

import '../../../widgets/appbar.dart';

class KirimBarangController extends GetxController {
  //////// begin of marking delivery location ///////
  List<String> kelurahan_desa_list = []; //list for kelurahan desa
  RxBool mapTypenya = false.obs; //maptype
  late GoogleMapController mapController; // google maps controller

  final Set<Polygon> _polygons = HashSet<Polygon>(); // set for polygon
  final Set<Marker> _markers = HashSet<Marker>(); // set for marker
  List<LatLng> _latLngs = []; // list of polygon latlng
  int _pilihanKelurahanDesa = 0; // keluarahan_desa_list index

  LatLng? _markerPosition; // marker position

  LatLng? konfirmMarker; // if  marker is konfirm, this is the marker position
  int?
      konfirmKelurahanDesaIndex; // if  marker is konfirm, this is the kelurahan_desa_list index

  // _initialCamera for google maps
  final _initialCameraPosition = const CameraPosition(
    target: LatLng(-3.5621854706823193, 119.7612856634139),
    zoom: 12.5,
  );
  //////// end of marking delivery location ///////

  /////// begin of kurir search  ///////
  final List<Widget> _kurirWidget = <Widget>[];
  String? _namaKurirSearch;
  final FocusNode _namaKurirSearchFocusNode = FocusNode();
  final _biayaMaksimalFilterController = TextEditingController();
  final FocusNode _biayaMaksimalFilterFocusNode = FocusNode();
  final _biayaPerKmFilterController = TextEditingController();
  final FocusNode _biayaPerKmFilterFocusNode = FocusNode();

  String? selectedKurirNama;
  KurirModel? _selectedKurirModel;
  PengaturanBiayaKurirModel? _selectedKurirPengaturanBiaya;
  ////// end of kurir search ///////

  ////// for camera and gallery ///////
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  RxBool adaFoto = false.obs;
  late Uint8List imagebytes;
  ///// end of camera and gallery ///////

  /////// begin for the page ///////
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController namaPenerimaController = TextEditingController();
  final TextEditingController noTelponPenerimaController =
      TextEditingController();
  final TextEditingController alamatPenerimaController =
      TextEditingController();
  final TextEditingController jarakTempuhController = TextEditingController();
  final TextEditingController biayaKirimController = TextEditingController();

  final FocusNode namaPenerimaFocusNode = FocusNode();
  final FocusNode noTelponPenerimaFocusNode = FocusNode();
  final FocusNode alamatPenerimaFocusNode = FocusNode();
  final kurirOutroTextController = TextEditingController();
  /////// end for the page ///////

  ////// begin of lokasi permulaan ///////
  LatLng?
      konfirmMarkerLokasiPermulaan; // if  marker is konfirm, this is the marker position
  int?
      konfirmKelurahanDesaLokasiPermulaanIndex; // if  marker is konfirm, this is the kelurahan_desa_list index
  Location location = Location();
  String peta_check = "lokasi pengiriman";
  bool tanda_peta = false;
  ////// end of lokasi permulaan ///////

  @override
  void onInit() {
    log("sini on init kirim barang controller");
    super.onInit();
    konfirmMarker = null;
    konfirmKelurahanDesaIndex = null;
    kurirOutroTextController.text = "Klik Untuk Pilih Kurir";
    _kurirWidget.clear();
    _namaKurirSearch = null;
    selectedKurirNama = null;
    _selectedKurirModel = null;
    _selectedKurirPengaturanBiaya = null;
    namaPenerimaController.text = "";
    noTelponPenerimaController.text = "";
    alamatPenerimaController.text = "";
    jarakTempuhController.text = "";
    biayaKirimController.text = "";

    konfirmMarkerLokasiPermulaan = null;
    konfirmKelurahanDesaLokasiPermulaanIndex = null;
    _markerPosition = null;

    _cek_and_delete();
  }

  @override
  void dispose() {
    mapController.dispose(); // dispose map controller
    super.dispose();
  }

  // the fist function to open if clicked "Pin Lokasi Pengiriman"
  pin_lokasi(BuildContext context) async {
    peta_check = "lokasi pengiriman";
    _markerPosition = null;
    // open get bottom sheet
    await EasyLoading.show(
      status: 'Loading Peta...',
      maskType: EasyLoadingMaskType.black,
    );
    Map<String, dynamic> map_kecamatan = await get_kecamatan_map();
    // ignore: unused_local_variable
    bool adaPetaKecamatan = false;
    late PetaKecamatanModel petaKecamatanModel;

    if (map_kecamatan['status'] == 200) {
      // log(map_kecamatan['data']['kecamatan'].toString() +
      //     " ini data kecamatan");
      petaKecamatanModel = PetaKecamatanModel.fromJson(map_kecamatan['data']);
      adaPetaKecamatan = true;
      // List<LatLng> _latLngs = [];
      // log(petaKecamatanModel.polygon.toString() + " ini peta kecamatan");

      if (konfirmMarker != null) {
        _pilihanKelurahanDesa = konfirmKelurahanDesaIndex!;
        _markerPosition = konfirmMarker!;
        Map<String, dynamic> kelurahan_desa_map =
            await PetaApi.cekKelurahanDesaDetail(
                kelurahan_desa_list[konfirmKelurahanDesaIndex!]);

        PetaKelurahanDesaModel kelurahan_desa_model =
            PetaKelurahanDesaModel.fromJson(kelurahan_desa_map['data']);

        // log(kelurahan_desa_model.polygon.toString() + " ini kelurahan desa model");

        for (var latlng in kelurahan_desa_model.polygon!) {
          LatitudeLongitude _latLng = LatitudeLongitude.fromJson(latlng);
          _latLngs.add(LatLng(_latLng.latitude, _latLng.longitude));
        }
        _polygons.add(Polygon(
          polygonId: const PolygonId("polygon_1"),
          points: _latLngs,
          fillColor: Colors.red.withOpacity(0.2),
          strokeColor: Colors.red.withOpacity(0.2),
          strokeWidth: 2,
        ));

        _markers.add(Marker(
          markerId: const MarkerId("marker_1"),
          position: konfirmMarker!,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(
            title: "Lokasi Anda",
            snippet: "Drag untuk mengubah lokasi",
          ),
          draggable: true,
          onDragEnd: (newposition) {
            // log(newposition.toString() + " ini dragend");
            bool isOffside =
                AllFunction.cekMarkerOffside(newposition, _latLngs);
            // log(isOffside.toString() + " ini offside");
            _markerPosition = newposition;
            log(newposition.toString() + " ini newposition");
            log(_markerPosition.toString() + " ini marker position");
            if (!isOffside) {
              Get.snackbar(
                'Peta',
                'Marker tidak boleh di luar batas peta',
                icon: const Icon(
                  Icons.error,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            }
          },
        ));
      } else {
        for (var latlng in petaKecamatanModel.polygon) {
          LatitudeLongitude _latLng = LatitudeLongitude.fromJson(latlng);
          _latLngs.add(LatLng(_latLng.latitude, _latLng.longitude));
        }
        _polygons.add(Polygon(
          polygonId: const PolygonId("polygon_1"),
          points: _latLngs,
          fillColor: Colors.blue.withOpacity(0.03),
          strokeColor: Colors.blue.withOpacity(0.2),
          strokeWidth: 2,
        ));
      }
    }

    bottomSheetMap(context);
    await EasyLoading.dismiss();
  }

  // onBounds to set the map zoom
  void _onBounds(GoogleMapController controller) {
    mapController = controller;
    Timer(const Duration(seconds: 1), () {
      if (_latLngs.isNotEmpty) {
        if (konfirmKelurahanDesaIndex != null &&
            peta_check == "lokasi pengiriman") {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: konfirmMarker!,
                zoom: 18,
              ),
            ),
          );
        } else if (_markerPosition != null &&
            peta_check == "lokasi permulaan") {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _markerPosition!,
                zoom: 18,
              ),
            ),
          );
        } else {
          mapController.animateCamera(
            CameraUpdate.newLatLngBounds(
              AllFunction.computeBounds(_latLngs),
              20,
            ),
          );
        }
      } else {
        log("sini untuk pertama sekali peta");
        //camera to _initialCameraPosition
        if (konfirmMarkerLokasiPermulaan != null &&
            peta_check == "lokasi permulaan") {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: konfirmMarkerLokasiPermulaan!,
                zoom: 18,
              ),
            ),
          );
        } else if (_markerPosition != null &&
            peta_check == "lokasi permulaan") {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _markerPosition!,
                zoom: 18,
              ),
            ),
          );
        } else {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              _initialCameraPosition,
            ),
          );
        }
      }
    });
  }

  // get kecamatan map
  get_kecamatan_map() async {
    _markers.clear();
    _latLngs.clear();
    _polygons.clear();
    _pilihanKelurahanDesa = 0;
    mapTypenya.value = false;
    kelurahan_desa_list.clear();
    kelurahan_desa_list.add("-Pilih Kelurahan / Desa-");
    Map<String, dynamic> kecamatan_map = await PetaApi.cekKecamatan();

    Map<String, dynamic> kelurahan_desa_map = await PetaApi.cekKelurahanDesa();

    List<dynamic> allListKelurahanDesa = kelurahan_desa_map['data'];

    // log(allListKelurahanDesa.toString() + " ini all list kelurahan desa");
    for (var kelurahan_desa in allListKelurahanDesa) {
      PetaKelurahanDesaModel kelurahan_desa_model =
          PetaKelurahanDesaModel.fromJson(kelurahan_desa);

      kelurahan_desa_list.add(kelurahan_desa_model.kelurahan_desa);
    }

    log(kelurahan_desa_list.toString() + " ini kelurahan desa list");

    return kecamatan_map;
  }

  // get kelurahan desa map
  get_kelurahn_desa_map(String nama, BuildContext context) async {
    await EasyLoading.show(
      status: 'Loading Peta...',
      maskType: EasyLoadingMaskType.black,
    );
    konfirmKelurahanDesaIndex = null;
    konfirmMarker = null;
    _markers.clear();
    _latLngs.clear();
    _polygons.clear();
    _check_jarak_tempuh();
    Map<String, dynamic> kelurahan_desa_map =
        await PetaApi.cekKelurahanDesaDetail(nama);

    PetaKelurahanDesaModel kelurahan_desa_model =
        PetaKelurahanDesaModel.fromJson(kelurahan_desa_map['data']);

    // log(kelurahan_desa_model.polygon.toString() + " ini kelurahan desa model");

    for (var latlng in kelurahan_desa_model.polygon!) {
      LatitudeLongitude _latLng = LatitudeLongitude.fromJson(latlng);
      _latLngs.add(LatLng(_latLng.latitude, _latLng.longitude));
    }
    _polygons.add(Polygon(
      polygonId: const PolygonId("polygon_1"),
      points: _latLngs,
      fillColor: Colors.red.withOpacity(0.2),
      strokeColor: Colors.red.withOpacity(0.2),
      strokeWidth: 2,
    ));

    // if (_pilihanKelurahanDesa != 0) {

    var _centernya = AllFunction.centerBounds(_latLngs);

    _markerPosition = _centernya;

    // var coba  = mapsToolkit.PolygonUtil.isLocationOnPath(LatLng(-3.554163813591, 119.77689743042001));

    // log(_centernya.toString() + " ini center");
    // log(_latLngs.toString() + " ini latlng");
    _markers.add(
      Marker(
        markerId: const MarkerId("marker_1"),
        infoWindow: const InfoWindow(
          title: "Lokasi Pengiriman",
          // snippet: "Kecamatan " + kelurahan_desa_model.kecamatan,
        ),
        position: _centernya,
        icon: BitmapDescriptor.defaultMarker,
        draggable: true,
        onDragEnd: (newposition) {
          // log(newposition.toString() + " ini dragend");
          bool isOffside = AllFunction.cekMarkerOffside(newposition, _latLngs);
          // log(isOffside.toString() + " ini offside");
          _markerPosition = newposition;
          log(newposition.toString() + " ini newposition");
          log(_markerPosition.toString() + " ini marker position");
          if (!isOffside) {
            Get.snackbar(
              'Peta',
              'Marker tidak boleh di luar batas peta',
              icon: const Icon(
                Icons.error,
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }
        },
      ),
    );
    // }
    Get.back();
    bottomSheetMap(context);
    await EasyLoading.dismiss();
  }

  // bottom sheet for map
  bottomSheetMap(BuildContext context) async {
    Get.bottomSheet(
      BoxBackgroundDecoration(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                PreferredSize(
                  preferredSize: Size.fromHeight(
                      MediaQuery.of(context).size.height * 0.08),
                  child: AppBarWidget(
                    header: "Pin Lokasi Pengiriman",
                    autoLeading: false,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Pilih Kelurahan / Desa',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    value: (konfirmKelurahanDesaIndex != null)
                        ? kelurahan_desa_list[konfirmKelurahanDesaIndex!]
                        : (_pilihanKelurahanDesa == 0)
                            ? "-Pilih Kelurahan / Desa-"
                            : kelurahan_desa_list[_pilihanKelurahanDesa],
                    items: kelurahan_desa_list.map((value) {
                      if (value == "-Pilih Kelurahan / Desa-") {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          onTap: () {},
                          enabled: false,
                        );
                      } else {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }
                    }).toList(),
                    onChanged: (item) {
                      // log(item.toString() + " ini item");
                      // log(item.toString() + " ini item");
                      for (var i = 0; i < kelurahan_desa_list.length; i++) {
                        if (kelurahan_desa_list[i] == item) {
                          _pilihanKelurahanDesa = i;
                        }
                      }
                      get_kelurahn_desa_map(item.toString(), context);
                    },
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Tipe Map',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    value: mapTypenya.value ? "Normal" : "Satellite",
                    items: ['Satellite', 'Normal'].map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (item) {
                      // log(item.toString() + " ini item");
                      switch (item) {
                        case "Satellite":
                          mapTypenya.value = false;
                          break;
                        case "Normal":
                          mapTypenya.value = true;
                          break;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    child: Obx(
                      () => GoogleMap(
                        mapType:
                            mapTypenya.value ? MapType.normal : MapType.hybrid,
                        mapToolbarEnabled: true,
                        rotateGesturesEnabled: true,
                        myLocationButtonEnabled: true,
                        polygons: _polygons,
                        markers: _markers,
                        // liteModeEnabled: true,
                        initialCameraPosition: _initialCameraPosition,
                        onMapCreated: _onBounds,
                        // onCameraMove: _onCameraMove,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_pilihanKelurahanDesa == 0) {
                        Get.snackbar(
                          'Peta',
                          'Pilih Kelurahan / Desa terlebih dahulu',
                          icon: const Icon(
                            Icons.error,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      } else {
                        WidgetsBinding.instance!.focusManager.primaryFocus
                            ?.unfocus();
                        konfirmKelurahanDesaIndex = _pilihanKelurahanDesa;
                        konfirmMarker = _markerPosition;
                        _check_jarak_tempuh();
                        Get.back();
                        Get.snackbar(
                          'Sukses',
                          'Lokasi Pengiriman Berhasil Ditanda',
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      }
                    },
                    child: const Text('Simpan Lokasi'),
                    style: ElevatedButton.styleFrom(
                      primary: (_pilihanKelurahanDesa == 0)
                          ? Colors.grey
                          : Color.fromARGB(255, 104, 164, 164),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      enableDrag: false,
    );
  }

  pilih_kurir(BuildContext context) async {
    _kurirWidget.clear();
    _namaKurirSearch = null;
    await EasyLoading.show(
      status: 'Mengambil data kurir',
      maskType: EasyLoadingMaskType.black,
    );

    if (selectedKurirNama == null) {
      await get_all_kurir(context);
    } else {
      log(selectedKurirNama.toString() + " ini selectedKurirNama");
      _namaKurirSearch = selectedKurirNama;
      _kurirWidget.add(custom_tile_list(
          _selectedKurirModel!, _selectedKurirPengaturanBiaya!, context));
    }

    bottomSheetPilihKurir(context);
    await EasyLoading.dismiss();
  }

  get_all_kurir(BuildContext context) async {
    _kurirWidget.clear();
    _check_jarak_tempuh();
    Map<String, dynamic> _dataKurirAll = await PengirimApi.getAllKurir();
    // log(_dataKurirAll['status'].toString() + " ini data kurir all");
    kurir_widget(_dataKurirAll, context);
  }

  kurir_widget(Map<String, dynamic> _dataKurir, BuildContext context) {
    if (_dataKurir['status'] == 200) {
      List<dynamic> _listAllKurir = _dataKurir['data'];
      if (_listAllKurir.isNotEmpty) {
        for (var _kurir in _listAllKurir) {
          log(_kurir['pengaturan_pengiriman'].toString() +
              " ini pengaturan pengiriman");

          late PengaturanBiayaKurirModel _pengaturanBiayaKurirModel;
          if (_kurir['pengaturan_pengiriman'].isNotEmpty) {
            Map<String, dynamic> _pengaturanPengiriman =
                _kurir['pengaturan_pengiriman'][0];
            _pengaturanBiayaKurirModel =
                PengaturanBiayaKurirModel.fromJson(_pengaturanPengiriman);
          } else {
            _pengaturanBiayaKurirModel = PengaturanBiayaKurirModel.fromJson({});
          }
          KurirModel _kurirModel = KurirModel.fromJson(_kurir);
          _kurirWidget.add(custom_tile_list(
              _kurirModel, _pengaturanBiayaKurirModel, context));
          // KurirModel _kurirModel = KurirModel.fromJson(_kurir);
          // _kurirWidget.add(custom_tile_list(_kurirModel));
          // log(_kurirModel.photo_url.toString() + " ini photo url");
        }
      } else {
        Widget _widget = Center(
          child: Column(
            children: const [
              SizedBox(height: 20),
              Text(
                'Tidak ada kurir',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
        _kurirWidget.add(_widget);
      }
    } else {
      Widget _error = Center(
        child: Column(
          children: const [
            SizedBox(height: 20),
            Text(
              'Error mengambil data kurir',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
      _kurirWidget.add(_error);
    }
  }

  Widget custom_tile_list(
      KurirModel kurirModel,
      PengaturanBiayaKurirModel _pengaturanBiayaKurirModel,
      BuildContext context) {
    Widget _listTilenya = Card(
      elevation: 1,
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          // dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              onPressed: (context) => _infoKurirDialog(
                  kurirModel, _pengaturanBiayaKurirModel, context),
              backgroundColor: const Color.fromARGB(255, 70, 192, 232),
              foregroundColor: Colors.white,
              icon: Icons.info_outline_rounded,
              label: 'Info',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: (selectedKurirNama == null) ? 0.25 : 0.5,
          // dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              onPressed: (context) {
                if (selectedKurirNama == null) {
                  _selectKurirDialog(kurirModel, _pengaturanBiayaKurirModel);
                } else {
                  Get.snackbar(
                    'Konfirmasi',
                    'Kurir ${kurirModel.nama} sudah dipilih',
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.white,
                    colorText: Colors.black,
                    duration: const Duration(seconds: 2),
                  );
                }
              },
              backgroundColor: (selectedKurirNama == null)
                  ? const Color.fromARGB(255, 47, 255, 1)
                  : const Color.fromARGB(255, 1, 124, 255),
              foregroundColor: Colors.white,
              icon: Icons.check_rounded,
              label: (selectedKurirNama == null) ? "Pilih" : "Sudah Dipilih",
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10, color: Colors.grey, spreadRadius: 2)
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: const AssetImage('assets/loading.gif'),
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 40.0,
                      // backgroundImage: NetworkImage(
                      //   kurirModel.photo_url ??
                      //       'https://via.placeholder.com/150',

                      // ),
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.network(
                          kurirModel.photo_url ??
                              'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: const Icon(
                                Icons.error,
                                color: Colors.grey,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${kurirModel.nama}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text('${kurirModel.no_telp}'),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((_pengaturanBiayaKurirModel.minimalBiayaPengiriman ==
                            null)
                        ? "- min"
                        : "Rp. ${AllFunction.thousandsSeperator(_pengaturanBiayaKurirModel.minimalBiayaPengiriman!)} min"),
                    const SizedBox(height: 5),
                    Text((_pengaturanBiayaKurirModel.maksimalBiayaPengiriman ==
                            null)
                        ? "- maks"
                        : "Rp. ${AllFunction.thousandsSeperator(_pengaturanBiayaKurirModel.maksimalBiayaPengiriman!)} maks"),
                    const SizedBox(height: 5),
                    Text((_pengaturanBiayaKurirModel.biayaPerKilo == null)
                        ? "- / km"
                        : "Rp. ${AllFunction.thousandsSeperator(_pengaturanBiayaKurirModel.biayaPerKilo!)} / km"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return _listTilenya;
  }

  bottomSheetPilihKurir(BuildContext context) async {
    Get.bottomSheet(
      Stack(
        children: [
          BoxBackgroundDecoration(
            child: Center(
              child: Image.asset(
                'assets/logo.png',
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      onChanged: (value) {
                        _namaKurirSearch = value;
                      },
                      initialValue: _namaKurirSearch ?? '',
                      focusNode: _namaKurirSearchFocusNode,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 10),
                          child: GestureDetector(
                            child: const Icon(
                              Icons.list_alt_rounded,
                              color: Colors.blueAccent,
                            ),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              filterDialogKurir(context);
                            },
                          ),
                        ),
                        suffixIcon: const Icon(Icons.search),
                        hintText: 'Masukkan Nama Kurir',
                        labelText: 'Pencarian Kurir',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        searchKurir(value, context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  OurContainer(
                    child: Container(
                      // height: 400,
                      constraints: const BoxConstraints(
                        minHeight: 50,
                        maxHeight: 450,
                      ),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        // put 100 dummy data
                        children: [
                          ..._kurirWidget,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      isScrollControlled: true,
      enableDrag: false,
    );
  }

  searchKurir(String nama, BuildContext context) async {
    _namaKurirSearch = nama;
    selectedKurirNama = null;
    _selectedKurirModel = null;
    _selectedKurirPengaturanBiaya = null;
    kurirOutroTextController.text = "Klik Untuk Pilih Kurir";
    Get.back();
    await EasyLoading.show(
      status: 'Mengambil data kurir',
      maskType: EasyLoadingMaskType.black,
    );
    _kurirWidget.clear();
    _check_jarak_tempuh();

    Map<String, dynamic> _dataKurir = await PengirimApi.getKurirByNama(nama);

    // log(_dataKurir.toString() + " ini data kurir");
    kurir_widget(_dataKurir, context);
    bottomSheetPilihKurir(context);
    await EasyLoading.dismiss();
  }

  filterDialogKurir(BuildContext context) {
    Get.dialog(
      SingleChildScrollView(
        child: WillPopScope(
          onWillPop: () async {
            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
            return true;
          },
          child: AlertDialog(
            title: const Text('Filter Pencarain Kurir'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _biayaMaksimalFilterController,
                  focusNode: _biayaMaksimalFilterFocusNode,
                  maxLength: 6,
                  decoration: InputDecoration(
                    prefix: const Text('Rp. '),
                    hintText: 'Biaya Maksimal Pengiriman',
                    labelText: 'Biaya Maksimal Pengiriman',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]'),
                    ),
                    ThousandsSeparatorInputFormatter(),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLength: 6,
                  controller: _biayaPerKmFilterController,
                  focusNode: _biayaPerKmFilterFocusNode,
                  decoration: InputDecoration(
                    prefix: const Text('Rp. '),
                    hintText: 'Biaya Per / Km',
                    labelText: 'Biaya Per / Km',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]'),
                    ),
                    ThousandsSeparatorInputFormatter(),
                  ],
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  _namaKurirSearchFocusNode.unfocus();
                  _filterPencarianKurir(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _filterPencarianKurir(BuildContext context) async {
    int? _biayaMaksimal;
    int? _biayaPerKm;

    // check if _biayaMaksimalFilterController.text is not empty and is number
    if (_biayaMaksimalFilterController.text.isNotEmpty) {
      if (int.tryParse(
              AllFunction.removeComma(_biayaMaksimalFilterController.text)) !=
          null) {
        _biayaMaksimal = int.parse(
            AllFunction.removeComma(_biayaMaksimalFilterController.text));
        // log(_biayaMaksimal.toString() + " ini biaya maksimal");
      } else {
        // log("biaya maksimal is not number");
        Get.snackbar(
          'Error',
          'Biaya maksimal harus angka',
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
          backgroundColor: Colors.white,
          colorText: Colors.black,
          borderRadius: 10,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        _biayaMaksimalFilterFocusNode.requestFocus();
        return;
      }
    }

    if (_biayaPerKmFilterController.text.isNotEmpty) {
      if (int.tryParse(
              AllFunction.removeComma(_biayaPerKmFilterController.text)) !=
          null) {
        _biayaPerKm = int.parse(
            AllFunction.removeComma(_biayaPerKmFilterController.text));
        // log(_biayaPerKm.toString() + " ini biaya per km");
      } else {
        // log("biaya per km is not number");
        Get.snackbar(
          'Error',
          'Biaya per km harus angka',
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
          backgroundColor: Colors.white,
          colorText: Colors.black,
          borderRadius: 10,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        _biayaPerKmFilterFocusNode.requestFocus();
        return;
      }
    }

    selectedKurirNama = null;
    _selectedKurirModel = null;
    _selectedKurirPengaturanBiaya = null;
    kurirOutroTextController.text = "Klik Untuk Pilih Kurir";
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    Get.back();
    Get.back();
    await EasyLoading.show(
      status: 'Mengambil data kurir',
      maskType: EasyLoadingMaskType.black,
    );

    Map<String, dynamic> _dataKurir = await PengirimApi.getKurirByFilter(
      _namaKurirSearch,
      _biayaMaksimal,
      _biayaPerKm,
    );

    _kurirWidget.clear();
    _check_jarak_tempuh();

    if (_dataKurir['status'] == 200) {
      int count = 0;
      for (var item in _dataKurir['data']) {
        // log(item.toString());
        if (item['kurir'].length > 0) {
          count++;
          KurirModel _kurirModel = KurirModel.fromJson(item['kurir'][0]);
          PengaturanBiayaKurirModel _pengaturanBiayaKurirModel =
              PengaturanBiayaKurirModel.fromJson(item);
          // log(_kurirModel.nama.toString() + " ini kurir model");
          // log(_pengaturanBiayaKurirModel.biayaPerKilo.toString() +
          //     " ini pengaturan biaya kurir model");
          _kurirWidget.add(custom_tile_list(
              _kurirModel, _pengaturanBiayaKurirModel, context));
        }
      }

      if (count == 0) {
        Widget _widget = Center(
          child: Column(
            children: const [
              SizedBox(height: 20),
              Text(
                'Tidak ada kurir yang sesuai dengan filter',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
        _kurirWidget.add(_widget);
      }
    } else {
      Widget _widget = Center(
        child: Column(
          children: const [
            SizedBox(height: 20),
            Text(
              'Error Tiada Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
      _kurirWidget.add(_widget);
    }

    bottomSheetPilihKurir(context);

    await EasyLoading.dismiss();
  }

  _infoKurirDialog(
      KurirModel kurirModel,
      PengaturanBiayaKurirModel _pengaturanBiayaKurirModel,
      BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Info Kurir',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                    // backgroundImage: NetworkImage(kurirModel.photo_url ??
                    //     'https://via.placeholder.com/150'),
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.network(
                        kurirModel.photo_url ??
                            'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        errorBuilder: (context, url, error) {
                          return Center(
                            child: const Icon(
                              Icons.error,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ),
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
                      kurirModel.kenderaan_url.toString(),
                      fit: BoxFit.cover,
                      width: 100,
                      errorBuilder: (context, url, error) {
                        return Center(
                          child: const Icon(
                            Icons.error,
                            size: 20,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Nama Kurir',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                initialValue: kurirModel.nama,
              ),
              const SizedBox(height: 15),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'No Kenderaan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                initialValue: kurirModel.no_kenderaan,
              ),
              const SizedBox(height: 15),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Minimal Biaya',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                initialValue: (_pengaturanBiayaKurirModel
                            .minimalBiayaPengiriman !=
                        null)
                    ? "Rp. ${AllFunction.thousandsSeperator(_pengaturanBiayaKurirModel.minimalBiayaPengiriman!)}"
                    : "Belum Diinput",
              ),
              const SizedBox(height: 15),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Maksimal Biaya',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                initialValue: (_pengaturanBiayaKurirModel
                            .maksimalBiayaPengiriman !=
                        null)
                    ? "Rp. ${AllFunction.thousandsSeperator(_pengaturanBiayaKurirModel.maksimalBiayaPengiriman!)}"
                    : "Belum Diinput",
              ),
              const SizedBox(height: 15),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Biaya / Km',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                initialValue: (_pengaturanBiayaKurirModel.biayaPerKilo != null)
                    ? "Rp. ${AllFunction.thousandsSeperator(_pengaturanBiayaKurirModel.biayaPerKilo!)}"
                    : "Belum Diinput",
              ),
            ],
          ),
        ),
        // actions: [
        //   ElevatedButton(
        //     child: const Text('OK'),
        //     onPressed: () {
        //       Get.back();
        //     },
        //   ),
        // ],
      ),
    );
  }

  _selectKurirDialog(KurirModel kurirModel,
      PengaturanBiayaKurirModel pengaturanBiayaKurirModel) async {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Konfirmasi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 5)
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/loading.gif'),
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 50.0,
                  // backgroundImage: NetworkImage(kurirModel.photo_url ??
                  //     'https://via.placeholder.com/150'),
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image.network(
                      kurirModel.photo_url ?? 'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      errorBuilder: (context, url, error) {
                        return Center(
                          child: const Icon(
                            Icons.error,
                            size: 20,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Apakah anda ingin mengambil kurir " ',
                    ),
                    TextSpan(
                      text: '${kurirModel.nama}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue,
                      ),
                    ),
                    const TextSpan(
                      text: ' " ?',
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
        actions: [
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();

              selectedKurirNama = kurirModel.nama!;
              kurirOutroTextController.text = kurirModel.nama!;
              _selectedKurirModel = kurirModel;
              _selectedKurirPengaturanBiaya = pengaturanBiayaKurirModel;
              _check_jarak_tempuh();
              Get.back();
              Get.back();
              Get.snackbar(
                'Success',
                'Kurir ${kurirModel.nama} dipilih',
                icon: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                backgroundColor: Colors.white,
                colorText: Colors.black,
                borderRadius: 10,
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 3),
              );
            },
          ),
        ],
      ),
    );
  }

  // choose option of photo
  onChooseOption(BuildContext context) async {
    // _cek_and_delete();
    Get.dialog(
      AlertDialog(
        // title: Text('Pilih'),
        content: const Text(
          "Pilih",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              ElevatedButton(
                onPressed: () {
                  _onImageButtonPressed(ImageSource.camera);
                  Get.back();
                },
                child: const Text("Camera"),
              ),
              const SizedBox(),
              ElevatedButton(
                onPressed: () {
                  _onImageButtonPressed(ImageSource.gallery);
                  Get.back();
                },
                child: const Text("Galeri"),
              ),
              const SizedBox(),
            ],
          )
        ],
      ),
    );
  }

  // create onimagebuttonpressed
  _onImageButtonPressed(ImageSource source) async {
    // _cek_and_delete();
    // log('sini on image button pressed ');
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      _imageFile = pickedFile;

      log('sini on image button pressed + ${_imageFile!.path}');
      final _file = File(_imageFile!.path);
      if (_file.existsSync()) {
        log("ada");
        Uint8List bytes = await _file.readAsBytes();
        imagebytes = bytes;
        adaFoto.value = false;
        adaFoto.value = true;
        //
        // log('sini on image button pressed + ${_imageFile!.path}');
      } else {
        log("tidak ada");
      }
      // log("ini dia ");
      // log(_imageFile!.path.toString());

      // log("ini dia " + imgKTP!);
    } catch (e) {
      log(e.toString());
    }
  }

  //delete foto on cache and storage
  _cek_and_delete() async {
    adaFoto.value = false;
    final appStorage = await getTemporaryDirectory();
    // // if (appStorage.existsSync()) {
    // // log("ada file");
    // // print all filename in directory
    final fileList = appStorage.listSync();
    log(fileList.toString() + "ini file list");
    if (fileList.isNotEmpty) {
      log("ada file");
      // print(fileList);
      for (var i = 0; i < fileList.length; i++) {
        final file = fileList[i];
        log(file.path);
        if (file.toString().contains(".jpg") ||
            file.toString().contains(".png") ||
            file.toString().contains(".jpeg") ||
            file.toString().contains(".JPG") ||
            file.toString().contains(".PNG") ||
            file.toString().contains(".JPEG")) {
          log("delete");
          await file.delete(recursive: true);
        }
      }
    } else {
      log("tidak ada file");
      // print(fileList);
    }
  }

  // show foto
  show_foto(BuildContext context) async {
    bool stat = adaFoto.value;
    if (stat) {
      Get.bottomSheet(
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
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
                  image: MemoryImage(
                    imagebytes,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      Get.snackbar(
        'Info',
        'Foto Belum Ditambahkan\nKlik Icon Foto Untuk Menambahkan Foto',
        icon: const Icon(
          Icons.error,
          color: Colors.orange,
        ),
        backgroundColor: Colors.white,
        colorText: Colors.black,
        borderRadius: 10,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // after clicked button "Lokasi Permulaan"
  pin_lokasi_permulaan(BuildContext context, String stat) async {
    // log("sini pin lokasi permulaan");
    peta_check = "lokasi permulaan";
    await EasyLoading.show(
      status: 'Loading Peta...',
      maskType: EasyLoadingMaskType.black,
    );

    if (stat == 'lokasi_now') {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('Lokasi Permulaan'),
          position: _markerPosition!,
          // icon: BitmapDescriptor.defaultMarkerWithHue(
          //   BitmapDescriptor.hueViolet,
          // ),
          infoWindow: const InfoWindow(
            title: 'Lokasi Permulaan',
            snippet: 'Drag Untuk Menanda Lokasi Permulaan',
          ),
        ),
      );
    } else if (stat == 'awal') {
      tanda_peta = false;
      _latLngs = [];
      _markerPosition = null;
      _polygons.clear();
      if (konfirmMarkerLokasiPermulaan != null) {
        Get.snackbar(
          'Info',
          'Lokasi Permulaan Sudah Ditandai',
          icon: const Icon(
            Icons.error,
            color: Colors.blueAccent,
          ),
          backgroundColor: Colors.white,
          colorText: Colors.black,
          borderRadius: 10,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );

        _markers.clear();
        if (tanda_peta == true) {
          _markers.add(
            Marker(
              markerId: const MarkerId('Lokasi Permulaan'),
              position: konfirmMarkerLokasiPermulaan!,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet,
              ),
              infoWindow: const InfoWindow(
                title: 'Lokasi Permulaan',
                // snippet: 'Drag Untuk Menanda Lokasi Permulaan',
              ),
            ),
          );
        } else {
          _markerPosition = konfirmMarkerLokasiPermulaan;

          if (konfirmKelurahanDesaLokasiPermulaanIndex != null) {
            _pilihanKelurahanDesa = konfirmKelurahanDesaLokasiPermulaanIndex!;
            Map<String, dynamic> kelurahan_desa_map =
                await PetaApi.cekKelurahanDesaDetail(kelurahan_desa_list[
                    konfirmKelurahanDesaLokasiPermulaanIndex!]);

            PetaKelurahanDesaModel kelurahan_desa_model =
                PetaKelurahanDesaModel.fromJson(kelurahan_desa_map['data']);

            // log(kelurahan_desa_model.polygon.toString() + " ini kelurahan desa model");

            for (var latlng in kelurahan_desa_model.polygon!) {
              LatitudeLongitude _latLng = LatitudeLongitude.fromJson(latlng);
              _latLngs.add(LatLng(_latLng.latitude, _latLng.longitude));
            }
            _polygons.add(Polygon(
              polygonId: const PolygonId("polygon_1"),
              points: _latLngs,
              fillColor: Colors.red.withOpacity(0.2),
              strokeColor: Colors.red.withOpacity(0.2),
              strokeWidth: 2,
            ));
          }

          log(_latLngs.toString() + "ini latlng");

          _markers.add(
            Marker(
              markerId: const MarkerId('Lokasi Permulaan'),
              position: konfirmMarkerLokasiPermulaan!,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet,
              ),
              infoWindow: const InfoWindow(
                title: 'Lokasi Permulaan',
                snippet: 'Drag Untuk Menanda Lokasi Permulaan',
              ),
              draggable: true,
              onDragEnd: (newposition) {
                // log(newposition.toString() + " ini dragend");
                bool isOffside =
                    AllFunction.cekMarkerOffside(newposition, _latLngs);
                // log(isOffside.toString() + " ini offside");
                _markerPosition = newposition;
                log(newposition.toString() + " ini newposition");
                log(_markerPosition.toString() + " ini marker position");
                if (!isOffside) {
                  Get.snackbar(
                    'Peta',
                    'Marker tidak boleh di luar batas peta',
                    icon: const Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                }
              },
            ),
          );
        }
      } else {
        Map<String, dynamic> map_kecamatan = await get_kecamatan_map();
        // ignore: unused_local_variable
        bool adaPetaKecamatan = false;
        late PetaKecamatanModel petaKecamatanModel;

        if (map_kecamatan['status'] == 200) {
          // log(map_kecamatan['data']['kecamatan'].toString() +
          //     " ini data kecamatan");
          petaKecamatanModel =
              PetaKecamatanModel.fromJson(map_kecamatan['data']);
          adaPetaKecamatan = true;
          // List<LatLng> _latLngs = [];
          // log(petaKecamatanModel.polygon.toString() + " ini peta kecamatan");

          for (var latlng in petaKecamatanModel.polygon) {
            LatitudeLongitude _latLng = LatitudeLongitude.fromJson(latlng);
            _latLngs.add(LatLng(_latLng.latitude, _latLng.longitude));
          }
          _polygons.add(Polygon(
            polygonId: const PolygonId("polygon_1"),
            points: _latLngs,
            fillColor: Colors.blue.withOpacity(0.03),
            strokeColor: Colors.blue.withOpacity(0.2),
            strokeWidth: 2,
          ));
        }
      }
    }

    _bottom_sheet_lokasi_permulaan(context);
    await EasyLoading.dismiss();
  }

  // bottom sheet lokasi permulaan
  _bottom_sheet_lokasi_permulaan(BuildContext context) {
    Get.bottomSheet(
      BoxBackgroundDecoration(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                PreferredSize(
                  preferredSize: Size.fromHeight(
                      MediaQuery.of(context).size.height * 0.08),
                  child: AppBarWidget(
                    header: "Pin Lokasi Permulaan",
                    autoLeading: false,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Pilih Kelurahan / Desa',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    value: (konfirmKelurahanDesaLokasiPermulaanIndex != null)
                        ? kelurahan_desa_list[
                            konfirmKelurahanDesaLokasiPermulaanIndex!]
                        : (_pilihanKelurahanDesa == 0)
                            ? "-Pilih Kelurahan / Desa-"
                            : kelurahan_desa_list[_pilihanKelurahanDesa],
                    items: kelurahan_desa_list.map((value) {
                      if (value == "-Pilih Kelurahan / Desa-") {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          onTap: () {},
                          enabled: false,
                        );
                      } else {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }
                    }).toList(),
                    onChanged: (item) {
                      // log(item.toString() + " ini item");
                      // log(item.toString() + " ini item");
                      for (var i = 0; i < kelurahan_desa_list.length; i++) {
                        if (kelurahan_desa_list[i] == item) {
                          _pilihanKelurahanDesa = i;
                        }
                      }
                      get_kelurahan_desa_map_permulaan(
                          item.toString(), context);
                    },
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Tipe Map',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    value: mapTypenya.value ? "Normal" : "Satellite",
                    items: ['Satellite', 'Normal'].map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (item) {
                      // log(item.toString() + " ini item");
                      switch (item) {
                        case "Satellite":
                          mapTypenya.value = false;
                          break;
                        case "Normal":
                          mapTypenya.value = true;
                          break;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    width: 400,
                    height: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Obx(
                        () => GoogleMap(
                          mapType: mapTypenya.value
                              ? MapType.normal
                              : MapType.hybrid,
                          mapToolbarEnabled: true,
                          rotateGesturesEnabled: true,
                          myLocationButtonEnabled: true,
                          polygons: _polygons,
                          markers: _markers,
                          // liteModeEnabled: true,
                          initialCameraPosition: _initialCameraPosition,
                          onMapCreated: _onBounds,
                          // onCameraMove: _onCameraMove,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _pin_current_location2(context);
                        },
                        child: const Text('Lokasi Sekarang'),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 4, 103, 103),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          log("ini ditekannya");
                          if (_markerPosition != null ||
                              konfirmMarkerLokasiPermulaan != null) {
                            // log("bagian sini");
                            if (tanda_peta == false) {
                              konfirmKelurahanDesaLokasiPermulaanIndex =
                                  _pilihanKelurahanDesa;
                            }
                            konfirmMarkerLokasiPermulaan = _markerPosition;
                            WidgetsBinding.instance!.focusManager.primaryFocus
                                ?.unfocus();
                            _check_jarak_tempuh();
                            Get.back();

                            Get.snackbar(
                              'Sukses',
                              'Berhasil menanda lokasi permulaan',
                              icon: const Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              borderRadius: 10,
                              snackPosition: SnackPosition.TOP,
                              duration: const Duration(seconds: 2),
                            );
                          } else {
                            Get.snackbar(
                              'Peringatan',
                              'Anda belum memilih lokasi',
                              icon: const Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                              borderRadius: 10,
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 2),
                            );
                          }
                        },
                        child: const Text('Simpan Lokasi'),
                        style: ElevatedButton.styleFrom(
                          primary: (_markerPosition == null &&
                                  konfirmMarkerLokasiPermulaan == null)
                              ? Colors.grey
                              : Color.fromARGB(255, 104, 164, 164),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      enableDrag: false,
    );
  }

  // get kelurahan desa map for lokasi permulaan
  get_kelurahan_desa_map_permulaan(String nama, BuildContext context) async {
    await EasyLoading.show(
      status: 'Loading Peta...',
      maskType: EasyLoadingMaskType.black,
    );
    konfirmKelurahanDesaLokasiPermulaanIndex = null;
    konfirmMarkerLokasiPermulaan = null;
    _markers.clear();
    _latLngs.clear();
    _polygons.clear();
    _check_jarak_tempuh();
    tanda_peta = false;
    Map<String, dynamic> kelurahan_desa_map =
        await PetaApi.cekKelurahanDesaDetail(nama);

    PetaKelurahanDesaModel kelurahan_desa_model =
        PetaKelurahanDesaModel.fromJson(kelurahan_desa_map['data']);

    // log(kelurahan_desa_model.polygon.toString() + " ini kelurahan desa model");

    for (var latlng in kelurahan_desa_model.polygon!) {
      LatitudeLongitude _latLng = LatitudeLongitude.fromJson(latlng);
      _latLngs.add(LatLng(_latLng.latitude, _latLng.longitude));
    }
    _polygons.add(Polygon(
      polygonId: const PolygonId("polygon_1"),
      points: _latLngs,
      fillColor: Colors.red.withOpacity(0.2),
      strokeColor: Colors.red.withOpacity(0.2),
      strokeWidth: 2,
    ));

    // if (_pilihanKelurahanDesa != 0) {

    var _centernya = AllFunction.centerBounds(_latLngs);

    _markerPosition = _centernya;

    // var coba  = mapsToolkit.PolygonUtil.isLocationOnPath(LatLng(-3.554163813591, 119.77689743042001));

    // log(_centernya.toString() + " ini center");
    // log(_latLngs.toString() + " ini latlng");
    _markers.add(
      Marker(
        markerId: const MarkerId("marker_1"),
        infoWindow: const InfoWindow(
          title: "Lokasi Permulaan",
          // snippet: "Kecamatan " + kelurahan_desa_model.kecamatan,
        ),
        position: _centernya,
        icon: BitmapDescriptor.defaultMarker,
        draggable: true,
        onDragEnd: (newposition) {
          // log(newposition.toString() + " ini dragend");
          bool isOffside = AllFunction.cekMarkerOffside(newposition, _latLngs);
          // log(isOffside.toString() + " ini offside");
          _markerPosition = newposition;
          log(newposition.toString() + " ini newposition");
          log(_markerPosition.toString() + " ini marker position");
          if (!isOffside) {
            Get.snackbar(
              'Peta',
              'Marker tidak boleh di luar batas peta',
              icon: const Icon(
                Icons.error,
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }
        },
      ),
    );
    // }
    Get.back();
    _bottom_sheet_lokasi_permulaan(context);
    await EasyLoading.dismiss();
  }

  _pin_current_location2(BuildContext context) async {
    _pilihanKelurahanDesa = 0;
    _markerPosition = null;
    _markers.clear();
    _polygons.clear();
    konfirmMarkerLokasiPermulaan = null;
    konfirmKelurahanDesaLokasiPermulaanIndex = null;
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    // ignore: unused_local_variable
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        log("tidak diaktifkan1");
        Get.snackbar(
          'Error',
          'Geolocation Permission Denied\nTidak dapat mengakses lokasi',
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );

        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        log("tidak diaktifkan2");
        Get.snackbar(
          'Error',
          'Geolocation Permission Denied\nTidak dapat mengakses lokasi',
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
        return;
      }
    }

    await EasyLoading.show(
      status: 'Loading Lokasi...',
      maskType: EasyLoadingMaskType.black,
    );
    location.changeSettings(
        accuracy: LocationAccuracy.high, interval: 1000, distanceFilter: 10);

    _locationData = await location.getLocation();
    _markerPosition = LatLng(_locationData.latitude!, _locationData.longitude!);

    log(_markerPosition.toString() + " ini location");
    Get.back();
    tanda_peta = true;
    pin_lokasi_permulaan(context, "lokasi_now");
    await EasyLoading.dismiss();
  }

  _check_jarak_tempuh() {
    if (konfirmMarker != null && konfirmMarkerLokasiPermulaan != null) {
      double jarak = AllFunction.check_distance_between(
          konfirmMarker!, konfirmMarkerLokasiPermulaan!);
      // log(jarak.toString() + " ini jarak");

      jarakTempuhController.text = jarak.toString() + " km";

      if (_selectedKurirPengaturanBiaya != null) {
        int? biaya_per_km = _selectedKurirPengaturanBiaya?.biayaPerKilo;
        int? biaya_minimal =
            _selectedKurirPengaturanBiaya!.minimalBiayaPengiriman;
        int? biaya_maksimal =
            _selectedKurirPengaturanBiaya?.maksimalBiayaPengiriman;
        double jumlah_biaya = jarak * biaya_per_km!;
        double jumlah_biaya_minimal = biaya_minimal! + jumlah_biaya;
        double jumlah_biaya_maksimal = biaya_maksimal! + jumlah_biaya;
        // log(jumlah_biaya.toString() + " ini jumlah biaya");
        // log(biaya_minimal.toString() + " ini jumlah biaya minimal");
        // log(biaya_maksimal.toString() + " ini jumlah biaya maksimal");
        // log(biaya_per_km.toString() + " ini biaya per km");
        biayaKirimController.text = "Rp. " +
            AllFunction.thousandsSeperator(
                int.parse(jumlah_biaya_minimal.toStringAsFixed(0))) +
            " - Rp. " +
            AllFunction.thousandsSeperator(
                int.parse(jumlah_biaya_maksimal.toStringAsFixed(0)));
      }
    } else {
      biayaKirimController.text = "";
      jarakTempuhController.text = "";
    }
  }

  // kofirmasi all
  konfirmasi_all(BuildContext context) async {
    if (_selectedKurirModel == null) {
      Get.snackbar(
        'Info',
        'Kurir Belum Terpilih',
        icon: const Icon(
          Icons.error,
          color: Colors.orange,
        ),
        backgroundColor: Colors.white,
        colorText: Colors.black,
        borderRadius: 10,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      // await 1 second
      await Future.delayed(const Duration(seconds: 1));
      pilih_kurir(context);
      return;
    } else if (konfirmMarker == null) {
      Get.snackbar(
        'Info',
        'Lokasi Belum Ditandai\nKlik Button "Pin Lokasi Pengiriman" Untuk Menandai Lokasi Pengiriman',
        icon: const Icon(
          Icons.error,
          color: Colors.orange,
        ),
        backgroundColor: Colors.white,
        colorText: Colors.black,
        borderRadius: 10,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      // await 1 second
      await Future.delayed(const Duration(seconds: 1));
      pin_lokasi(context);
      return;
    } else if (konfirmMarkerLokasiPermulaan == null) {
      Get.snackbar(
        'Info',
        'Lokasi Permulaan Belum Ditandai\nKlik Button "Pin Lokasi Permulaan" Untuk Menandai Lokasi Permulaan',
        icon: const Icon(
          Icons.error,
          color: Colors.orange,
        ),
        backgroundColor: Colors.white,
        colorText: Colors.black,
        borderRadius: 10,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      // await 1 second
      await Future.delayed(const Duration(seconds: 1));
      pin_lokasi_permulaan(context, "awal");
      return;
    } else if (adaFoto.value == false) {
      Get.snackbar(
        'Info',
        'Foto Belum Ditambahkan\nKlik Icon Foto Untuk Menambahkan Foto',
        icon: const Icon(
          Icons.error,
          color: Colors.orange,
        ),
        backgroundColor: Colors.white,
        colorText: Colors.black,
        borderRadius: 10,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      // await 1 second
      await Future.delayed(const Duration(seconds: 1));
      onChooseOption(context);
      return;
    } else {
      String? _id_kurir = _selectedKurirModel?.id;
      String? _nama_penerima = namaPenerimaController.text;
      String? _no_telpon_penerima = noTelponPenerimaController.text;
      String? _alamat_penerima = alamatPenerimaController.text;
      LatLng? _lokasi_pengirman = konfirmMarker;
      String? _kelurahan_desa_pengiriman =
          kelurahan_desa_list[konfirmKelurahanDesaIndex!].toString();
      String? _foto_path = _imageFile?.path;
      LatLng? _lokasi_permulaan = konfirmMarkerLokasiPermulaan;

      await EasyLoading.show(
        status: 'Memproses',
        maskType: EasyLoadingMaskType.black,
      );

      Map<String, dynamic> _data = {
        "id_kurir": _id_kurir,
        "nama_penerima": _nama_penerima,
        "no_telpon_penerima": _no_telpon_penerima,
        "alamat_penerima": _alamat_penerima,
        "lokasi_pengiriman": _lokasi_pengirman,
        "kelurahan_desa_pengiriman": _kelurahan_desa_pengiriman,
        "foto_path": _foto_path,
        "lokasi_permulaan": _lokasi_permulaan,
        "biaya": {
          "biaya_per_kilo": _selectedKurirPengaturanBiaya?.biayaPerKilo,
          "biaya_minimal":
              _selectedKurirPengaturanBiaya?.minimalBiayaPengiriman,
          "biaya_maksimal":
              _selectedKurirPengaturanBiaya?.maksimalBiayaPengiriman,
        }
      };

      Map<String, dynamic> _result =
          await PengirimApi.createPengirimanBarang(_data);

      if (_result['status'] == 200) {
        _cek_and_delete();
        await EasyLoading.dismiss();
        Get.snackbar(
          'Info',
          'Pengiriman Berhasil Ditambahkan',
          icon: const Icon(
            Icons.check,
            color: Colors.green,
          ),
          backgroundColor: Colors.white,
          colorText: Colors.black,
          borderRadius: 10,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        // await 1 second
        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(
          'pengirimIndex',
          arguments: {
            "tap": 1,
            // "history": _historyIndex.value,
          },
        );
      } else {
        await EasyLoading.dismiss();
        Get.snackbar(
          'Info',
          'Pengiriman Gagal Ditambahkan\n${_result['message']}',
          icon: const Icon(
            Icons.error,
            color: Colors.orange,
          ),
          backgroundColor: Colors.white,
          colorText: Colors.black,
          borderRadius: 10,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }
}
