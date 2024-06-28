import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/common/data/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/data/api/api_client.dart';

class LoginRepository extends GetxService {
  ApiClient apiClient;
  SharedPreferences sharedPreferences;

  LoginRepository({required this.apiClient, required this.sharedPreferences});

  Future<Response> getLoginData() async {
    return await apiClient.getData(AppUrls.loginUrl);
  }

  Future<Response> postLoginData(dynamic body) async {
    return await apiClient.postData(AppUrls.loginUrl, body);
  }

  Future<void> saveLoginInfo(String username, String password) async {
    try {
      await sharedPreferences.setString("username", username);
      await sharedPreferences.setString("password", password);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        colorText: AppColor.white,
        backgroundColor: AppColor.red,
        duration: const Duration(seconds: 1),
      );
    }
  }

  Future<void> isLogin(bool isLogin) async {
    try {
      await sharedPreferences.setBool("isLogin", isLogin);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        colorText: AppColor.white,
        backgroundColor: AppColor.red,
        duration: const Duration(seconds: 1),
      );
    }
  }

  Future<void> clearUserInfo() async {
    try {
      await sharedPreferences.remove('USERNAME');
      await sharedPreferences.remove('PASSCODE');
      await sharedPreferences.setBool('isLogin', false);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        colorText: AppColor.white,
        backgroundColor: AppColor.red,
        duration: const Duration(seconds: 1),
      );
    }
  }
}
