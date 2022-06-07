import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kurir/widgets/focusToTextFormField.dart';
import 'package:kurir/widgets/ourContainer.dart';

import '../../controller/before_login/loginController.dart';
import '../../widgets/boxBackgroundDecoration.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => controller.willPopScopeWidget(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: BoxBackgroundDecoration(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    // set logo.png on top center of screen
                    Image.asset(
                      'assets/logo.png',
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width * 0.30,
                    ),
                    OurContainer(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Obx(
                              () => DropdownButtonFormField(
                                decoration: InputDecoration(
                                  labelText: 'Login Sebagai',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                value: controller.selectedRole.value,
                                items: controller.role.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (item) {
                                  // log(item.toString() + " ini item");
                                  controller.selectedRole.value =
                                      item.toString();
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          EnsureVisibleWhenFocused(
                            focusNode: controller.usernameFocusNode,
                            child: TextFormField(
                              //focus node
                              focusNode: controller.usernameFocusNode,
                              controller: controller.usernameController,
                              decoration: InputDecoration(
                                hintText: 'Masukkan Username',
                                labelText: 'Username',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  controller.usernameFocusNode.requestFocus();
                                  return 'Masukkan Username';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(
                            () => EnsureVisibleWhenFocused(
                              focusNode: controller.passwordFocusNode,
                              child: TextFormField(
                                //focus node
                                focusNode: controller.passwordFocusNode,
                                controller: controller.passwordController,
                                obscureText: !controller.passwordVisible.value,
                                decoration: InputDecoration(
                                  hintText: 'Masukkan Password',
                                  labelText: 'Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: controller.passwordVisible.value
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      controller.passwordVisible.value =
                                          !controller.passwordVisible.value;
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    controller.passwordFocusNode.requestFocus();
                                    return 'Masukkan Password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: ElevatedButton(
                              onPressed: () {
                                log(controller.selectedRole.value +
                                    " ini selected role di login");
                                FocusScope.of(context).unfocus();
                                if (controller.formKey.currentState!
                                    .validate()) {
                                  // controller.wrongPassword.value = true;
                                  controller.login();
                                }
                              },
                              child: const Text('Login'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Obx(() => controller.bottomNavigationBar()),
      ),
    );
  }
}
