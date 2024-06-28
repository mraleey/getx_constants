// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/repository/login_repository.dart';
import 'package:getx_constants/view/home_view.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final isPasswordVisible = true.obs;
  final isLoading = false.obs;
  final name = ''.obs;

  RxList<dynamic> partyData = [].obs;

  void toggleLoading() {
    isLoading.value = !isLoading.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  final LoginRepository loginRepository;
  LoginController({required this.loginRepository});

  Future<bool> postLoginData(dynamic data) async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        colorText: AppColor.white,
        backgroundColor: AppColor.red,
      );
      return false;
    }
    try {
      toggleLoading();
      var jsonData = jsonEncode(data);
      print("jsonData: $jsonData");
      Response response = await loginRepository.postLoginData(jsonData);
      print("Link : ${response.request?.url}");
      print(
          "Response: ${response.body} statusCode: ${response.statusCode} data: $jsonData");
      if (response.statusCode == 200) {
        emailController.clear();
        passwordController.clear();
        Get.to(HomeView());

        return true;
      } else {
        Get.snackbar(
          "Error",
          "Invalid Username or Password",
          colorText: AppColor.white,
          backgroundColor: AppColor.red,
          duration: const Duration(seconds: 1),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Incorrect Username or Password",
        colorText: AppColor.white,
        backgroundColor: AppColor.red,
        duration: const Duration(seconds: 1),
      );
      return false;
    } finally {
      toggleLoading();
    }
  }

  void saveLoginInfo(String username, String password) {
    loginRepository.saveLoginInfo(username, password);
  }

  void isLogin(bool isLogin) {
    loginRepository.isLogin(isLogin);
  }

  void clearUserInfo() {
    loginRepository.clearUserInfo();
  }
}
