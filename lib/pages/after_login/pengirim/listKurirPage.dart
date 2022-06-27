// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/after_login/pengirim/listKurirController.dart';
import '../../../models/usersModel.dart';
import '../../../widgets/bounce_scroller.dart';
import '../../../widgets/boxBackgroundDecoration.dart';
import '../../../widgets/load_data.dart';

class ListKurirPage extends GetView<ListKurirController> {
  const ListKurirPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BoxBackgroundDecoration(
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
                  _MainDetail(controller: controller),
                ],
              ),
            ),
          ),
          const _TopSearchInputField(),
        ],
      ),
    );
  }
}

class _TopSearchInputField extends StatelessWidget {
  const _TopSearchInputField({
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
            hintText: 'Cari Kurir',
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

class _MainDetail extends StatelessWidget {
  const _MainDetail({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ListKurirController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.height * 0.03,
          right: MediaQuery.of(context).size.height * 0.03),
      child: Obx(
        () => BounceScrollerWidget(
          children: [
            if (controller.loadKurir.value == 0) const LoadingDataWidget(),
            if (controller.loadKurir.value == 1 &&
                controller.kurirModelList.isNotEmpty)
              for (var data in controller.kurirModelList)
                _KurirDetailBox(data: data)
            else if (controller.loadKurir.value == 1 &&
                controller.kurirModelList.isEmpty)
              const TiadaDataWIdget(text: "Tidak ada data"),
            if (controller.loadKurir.value == 2) const ErrorLoadDataWidget(),
          ],
        ),
      ),
    );
  }
}

class _KurirDetailBox extends StatelessWidget {
  const _KurirDetailBox({
    Key? key,
    required this.data,
  }) : super(key: key);

  final KurirModel data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        height: 90,
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
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 50.0,
                    // backgroundImage: NetworkImage(
                    //     pengirimanModel.kurir!.photo_url ??
                    //         'https://via.placeholder.com/150'),
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.network(
                        data.photo_url ?? 'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        errorBuilder: (context, url, error) {
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    data.nama ?? 'Nama Belum Terisi',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    data.no_telp ?? 'No Telp Belum Terisi',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    data.email ?? 'Email Belum Terisi',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 1,
              child: Text("Rating"),
            ),
          ],
        ),
      ),
    );
  }
}
