// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/repository/login_repository.dart';
import 'package:getx_constants/view/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final isPasswordVisible = true.obs;
  final isLoading = false.obs;
  final username = ''.obs;
  final deviceToken = ''.obs;
  final deviceId = ''.obs;
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
      Response response = await loginRepository.postLoginData(jsonData);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        name.value = responseBody['LOGINDATA']['NAME'].toString();
        username.value = responseBody['LOGINDATA']['USERNAME'].toString();
        int type = responseBody['LOGINDATA']['TYPE'] as int;

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString("NAME", name.value);
        sharedPreferences.setString("USERNAME", username.value);
        sharedPreferences.setInt("TYPE", type);
        sharedPreferences.setString("token", deviceToken.toString());

        emailController.clear();
        passwordController.clear();
        if (type == 2 || type == 0) {
          Get.to(const HomeView());
        }

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

  void generateTicket() {}
}
