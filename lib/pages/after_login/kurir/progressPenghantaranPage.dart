// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/after_login/kurir/progressPenghantaranController.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/boxBackgroundDecoration.dart';

class ProgressPenghantaranPage
    extends GetView<ProgressPenghantaranControllerKurir> {
  const ProgressPenghantaranPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: const AppBarWidget(
          header: "Progress Penghantaran",
          autoLeading: true,
        ),
      ),
      body: BoxBackgroundDecoration(
        child: Obx(() => controller.enhanceStepContainer.value),
      ),
    );
  }
}
