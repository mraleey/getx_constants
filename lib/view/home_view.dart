import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/button.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/controller/home_controller.dart';
import 'package:getx_constants/view/home/page_one.dart';
import 'package:getx_constants/view/home/page_two.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController _controller = Get.put(HomeController());

  static final List<Widget> _widgetOptions = <Widget>[
    PageOne(),
    const PageTwo()
  ];

  Future<bool> showExitConfirmationSnackbar() async {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.primaryTheme.withOpacity(0.8),
      colorText: Colors.white,
      titleText: Column(
        children: [
          Text(
            "Are you sure you want to exit the app?",
            style: TextStyle(
              color: Colors.white,
              fontSize: CustomFontSize.large(Get.context!),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Get.height * 0.03),
          CustomButton(
              width: Get.width * 0.3,
              height: Get.height * 0.05,
              color: AppColor.red,
              title: "Yes",
              onPressed: () {
                SystemNavigator.pop();
              },
              isLoading: false),
          SizedBox(height: Get.height * 0.01),
          CustomButton(
            width: Get.width * 0.3,
            height: Get.height * 0.05,
            color: AppColor.green,
            title: "No",
            onPressed: () {
              Get.back();
            },
            isLoading: false,
          ),
        ],
      ),
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      duration: const Duration(minutes: 5),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await showExitConfirmationSnackbar();
        return shouldExit;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.primaryTheme,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Getx Constants',
                style: TextStyle(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                  fontSize: CustomFontSize.extraLarge(context),
                ),
              ),
              Row(
                children: [
                  Image(
                    image: const AssetImage("images/logo.png"),
                    height: Get.height * 0.05,
                    width: Get.width * 0.05,
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Powered By",
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
        body: Obx(() => _widgetOptions[_controller.selectedIndex.value]),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              backgroundColor: AppColor.primaryTheme,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColor.white,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Page One',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'Page Two',
                ),
              ],
              currentIndex: _controller.selectedIndex.value,
              onTap: _controller.onItemTapped,
            )),
      ),
    );
  }
}
