import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/button.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/view/admin/dashboard/dashboard.dart';
import 'package:getx_constants/view/admin/database/database_restore.dart';
import 'package:getx_constants/view/admin/tickets/ticket_home.dart';
import 'package:getx_constants/view/admin/invoices/navigations/invoice_home.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    DashboardView(),
    TicketHomeView(),
    InvoiceBottomNavigationBar(),
    const DatabaseRestore()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
                'Team App',
                style: TextStyle(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                  fontSize: CustomFontSize.extraLarge(context),
                ),
              ),
              Row(
                children: [
                  Image(
                    image: const AssetImage("images/support.png"),
                    height: Get.height * 0.05,
                    width: Get.width * 0.05,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        "@SolutionExperts",
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
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColor.primaryTheme,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColor.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.money_off),
              label: 'Invoices',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.restore), label: 'Database')
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
