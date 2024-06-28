import 'dart:async';

import 'package:get/get.dart';
import 'package:getx_constants/view/home_view.dart';
import 'package:getx_constants/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashServices {
  Future<void> isLogIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool('isLogin') ?? false) {
      Timer(const Duration(seconds: 5), () {
        Get.to(() => HomeView());
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Get.off(() => LogInView());
      });
    }
  }
}
