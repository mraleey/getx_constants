import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/button.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/controller/login_controller.dart';
import 'package:getx_constants/view/login.dart';

class PageOne extends StatelessWidget {
  final LoginController loginController =
      Get.put(LoginController(loginRepository: Get.find()));
  PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: Get.width * 0.3,
            height: Get.height * 0.15,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Image(
              image: AssetImage('images/user.png'),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome to Getx Constants',
            style: TextStyle(
              fontSize: CustomFontSize.extraExtraLarge(context),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Page One',
            style: TextStyle(
              fontSize: CustomFontSize.extraExtraLarge(context),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            title: "Log Out",
            onPressed: () {
              loginController.isLogin(false);
              Get.offAll(LogInView());
            },
            isLoading: false,
            width: Get.width * 0.3,
            height: Get.height * 0.05,
          ),
        ],
      ),
    );
  }
}
