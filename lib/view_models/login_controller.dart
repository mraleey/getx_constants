// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/controller/admin/Invoice/invoice_controller.dart';
import 'package:getx_constants/controller/admin/Invoice/invoice_data_controller.dart';
import 'package:getx_constants/controller/admin/dashboard/dashboard_controller.dart';
import 'package:getx_constants/controller/party/dashboard/party_dashboard_controller.dart';
import 'package:getx_constants/repository/login_repository.dart';
import 'package:getx_constants/view/party/party_home_view.dart';
import 'package:getx_constants/view/admin/home_view.dart';
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

  final DashboardController dashboardController =
      Get.put(DashboardController());
  final InvoiceDataController invoiceDataController =
      Get.put(InvoiceDataController());
  final InvoiceController invoiceController =
      Get.put(InvoiceController(invoiceRepo: Get.find()));
  final PartyDashboardController partyDashboardController =
      Get.put(PartyDashboardController());

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
          dashboardController.ticketPendingData(username.value.toString());
          dashboardController.ticketPreviousData(username.value.toString());
          dashboardController.ticketNewData(username.value.toString());
          dashboardController.ticketClosedData(username.value.toString());
          invoiceDataController.postInvoiceStatus("ALL");
          invoiceController.fetchMaxNoFromApi();
          invoiceController.fetchServiceType();
          invoiceController.fetchPartyData();
          invoiceController.postbillingtickets('Yes');
          Get.to(const HomeView());
        } else if (type == 3) {
          Get.offAll(const PartyHomeView());

          partyDashboardController.ticketPendingData(username.value.toString());
          partyDashboardController.ticketClosedData(username.value.toString());
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
