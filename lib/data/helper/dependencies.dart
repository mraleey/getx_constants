import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_constants/controller/login_controller.dart';
import 'package:getx_constants/data/app_urls.dart';
import 'package:getx_constants/repository/login_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences);

  // ApiClient
  Get.put(ApiClient(appBaseUrl: AppUrls.baseUrl));
  Get.put(
      LoginRepository(apiClient: Get.find(), sharedPreferences: Get.find()));
  //Controllers
  Get.put(LoginController(loginRepository: Get.find()));
}
