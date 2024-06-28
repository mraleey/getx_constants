import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/constants/textfield.dart';
import 'package:getx_constants/controller/login_controller.dart';
import 'package:getx_constants/constants/button.dart';

class LogInView extends StatelessWidget {
  LogInView({super.key});

  final loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryTheme,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Getx Costants',
              style: TextStyle(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
                fontSize: CustomFontSize.extraLarge(context),
              ),
            ),
            Row(
              children: [
                Image(
                  image: const AssetImage('images/logo.png'),
                  height: Get.height * 0.05,
                  width: Get.width * 0.05,
                ),
                SizedBox(width: Get.width * 0.02),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Powered By:",
                      style: TextStyle(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: CustomFontSize.medium(context),
                      ),
                    ),
                    Text(
                      "@mraleey",
                      style: TextStyle(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: CustomFontSize.medium(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: Get.height * 0.1),
              Image.asset(
                'images/logo.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: Get.height * 0.1),
              CustomTextField(
                controller: loginController.emailController,
                focusNode: loginController.emailFocus,
                labelText: 'Username',
                obscureText: false,
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 20),
              Obx(
                () => CustomTextField(
                  controller: loginController.passwordController,
                  focusNode: loginController.passwordFocus,
                  labelText: "Password",
                  prefixIcon: Icons.lock,
                  obscureText: loginController.isPasswordVisible.value,
                  suffixIcon: InkWell(
                    onTap: () {
                      loginController.togglePasswordVisibility();
                    },
                    child: loginController.isPasswordVisible.value
                        ? const Icon(Icons.visibility)
                        : const Icon(
                            Icons.visibility_off,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => CustomButton(
                  color: AppColor.loginButtonColor,
                  title: "LogIn",
                  onPressed: () {
                    loginController.postLoginData({
                      "username": loginController.emailController.text.trim(),
                      "password":
                          loginController.passwordController.text.trim(),
                    }).then(
                      (value) {
                        if (value == true) {
                          loginController.isLogin(value);
                        } else {
                          loginController.isLogin(value);
                        }
                      },
                    );
                  },
                  isLoading: loginController.isLoading.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
