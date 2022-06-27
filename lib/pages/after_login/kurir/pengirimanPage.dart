// ignore_for_file: file_names
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kurir/function/allFunction.dart';

import '../../../controller/after_login/kurir/pengirimanController.dart';
import '../../../models/pengirimimanModel.dart';
import '../../../widgets/bounce_scroller.dart';
import '../../../widgets/boxBackgroundDecoration.dart';
import '../../../widgets/load_data.dart';

class PengirimanKurirPage extends GetView<PengirimanKurirController> {
  const PengirimanKurirPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: unnecessary_const
      body: BoxBackgroundDecoration(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity * 0.9,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                    _MainWidget(controller: controller),
                  ],
                ),
              ),
            ),
            const TopSeachInput(),
          ],
        ),
      ),
    );
  }
}

class _MainWidget extends StatelessWidget {
  const _MainWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final PengirimanKurirController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.height * 0.03,
          right: MediaQuery.of(context).size.height * 0.03),
      child: Obx(
        () => BounceScrollerWidget(
          children: [
            if (controller.loadPengiriman.value == 0) const LoadingDataWidget(),
            if (controller.loadPengiriman.value == 1 &&
                controller.pengirimanModelList.isNotEmpty)
              for (var data in controller.pengirimanModelList)
                _SlidableWidget(data: data, controller: controller),
            if (controller.loadPengiriman.value == 1 &&
                controller.pengirimanModelList.isEmpty)
              const Center(
                  child: TiadaDataWIdget(
                      text: "Tiada data pengiriman\ndalam proses pengesahan")),
            if (controller.loadPengiriman.value == 2)
              const ErrorLoadDataWidget(),
          ],
        ),
      ),
    );
  }
}

class _SlidableWidget extends StatelessWidget {
  const _SlidableWidget({
    Key? key,
    required this.data,
    required this.controller,
  }) : super(key: key);

  final PengirimanModel data;
  final PengirimanKurirController controller;

  @override
  Widget build(BuildContext context) {
    late String _text;
    late IconData _icon;

    switch (data.statusPengiriman) {
      case "Dalam Pengesahan Kurir":
        _text = "Terima Pengiriman";
        _icon = Icons.check_box;
        break;
      case "Disahkan Kurir":
        _text = "Mengambil Paket\nKiriman";
        _icon = Icons.motorcycle_outlined;
        break;
      case "Mengambil Paket Pengiriman Dari Pengirim":
        _text = "Paket Diterima\nDari Pengirim";
        _icon = Icons.handshake_outlined;
        break;
      default:
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Slidable(
        key: const ValueKey(1),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.90,
          // dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              flex: 5,
              onPressed: (context) {
                if (data.statusPengiriman == "Dalam Pengesahan Kurir") {
                  controller.terimaPengiriman(data.sId);
                } else if (data.statusPengiriman == "Disahkan Kurir") {
                  controller.mengambilPaket(data.sId);
                }
              },
              backgroundColor: const Color.fromARGB(255, 104, 164, 164),
              foregroundColor: Colors.white,
              icon: _icon,
              label: _text,
            ),
            SlidableAction(
              flex: 5,
              onPressed: (context) {
                controller.lihatFotoKiriman(context, data.fotoPengiriman!);
              },
              backgroundColor: const Color.fromARGB(255, 4, 103, 103),
              foregroundColor: Colors.white,
              icon: Icons.photo_rounded,
              label: 'Barang Kiriman',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio:
              (data.statusPengiriman == "Dalam Pengesahan Kurir") ? 0.5 : 0.01,
          children: [
            if (data.statusPengiriman == 'Dalam Pengesahan Kurir')
              SlidableAction(
                onPressed: (context) {
                  controller.batalkanPengiriman(data.sId);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.cancel_rounded,
                label: "Batalkan Permintaan\nPengirim",
              ),
          ],
        ),
        child: _MainChild(data: data, controller: controller),
      ),
    );
  }
}

class _MainChild extends StatelessWidget {
  const _MainChild({
    Key? key,
    required this.data,
    required this.controller,
  }) : super(key: key);

  final PengirimanModel data;
  final PengirimanKurirController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 132,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 165, 163, 163).withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 165, 163, 163)
                        .withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage('assets/loading.gif'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 30.0,
                  // backgroundImage: NetworkImage(
                  //   data.pengirim!.photoUrl ?? 'https://via.placeholder.com/150',
                  //   scale: 0.5,
                  // ),
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image.network(
                      data.pengirim!.photoUrl ??
                          'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
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
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    AllFunction.timeZoneAdd8(data.createdAt),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    data.pengirim!.nama!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                // Coba(data:data,controller:controller)
                FittedBox(
                  child: _FutureBuilderHargaJarak(
                    controller: controller,
                    data: data,
                  ),
                ),
                FittedBox(
                  child: Text(
                    data.statusPengiriman!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                _IconContainer(
                  icon: const Icon(
                    Icons.turn_sharp_right_outlined,
                    color: Color.fromARGB(255, 199, 214, 234),
                  ),
                  color: const Color.fromARGB(255, 2, 72, 72),
                  shadowColor: const Color.fromARGB(255, 104, 164, 164),
                  onPressed: () {
                    controller.showMapDialog(context, data);
                    // dev.log("ini ditekan");
                  },
                ),
                if (data.statusPengiriman != "Dalam Pengesahan Kurir")
                  _IconContainer(
                    icon: const Icon(
                      Icons.info_outlined,
                      color: Colors.white,
                    ),
                    color: const Color.fromARGB(255, 104, 164, 164),
                    shadowColor: const Color.fromARGB(255, 199, 214, 234),
                    onPressed: () {
                      // controller.showMapDialog(context, data);
                      Get.toNamed('/kurirIndex/progressPenghantaran',
                          arguments: data.sId);
                      dev.log("ini ditekan");
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconContainer extends StatelessWidget {
  const _IconContainer({
    Key? key,
    required this.icon,
    required this.color,
    required this.shadowColor,
    required this.onPressed,
  }) : super(key: key);

  final Icon icon;
  final Color color;
  final Color shadowColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}

class TopSeachInput extends StatelessWidget {
  const TopSeachInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.05,
      right: MediaQuery.of(context).size.width * 0.05,
      left: MediaQuery.of(context).size.width * 0.05,
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: TextFormField(
          decoration: InputDecoration(
            hintText: 'Cari Pengiriman',
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            suffixIcon: const Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
            filled: true,
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
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
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _FutureBuilderHargaJarak extends StatelessWidget {
  const _FutureBuilderHargaJarak(
      {Key? key, required this.controller, required this.data})
      : super(key: key);

  final PengirimanKurirController controller;
  final PengirimanModel data;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: controller.cekDistance(
          LatLng(double.parse(data.kordinatPengiriman!.lat!),
              double.parse(data.kordinatPengiriman!.lng!)),
          LatLng(double.parse(data.kordinatPermulaan!.lat!),
              double.parse(data.kordinatPermulaan!.lng!))),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.cekHarga(snapshot.data, data.biaya!.biayaMinimal!,
                    data.biaya!.biayaMaksimal!, data.biaya!.biayaPerKilo!),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                snapshot.data.toString() + " km",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const Text(
            "Error mengambil data",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              overflow: TextOverflow.ellipsis,
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(
                  255,
                  4,
                  103,
                  103,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
