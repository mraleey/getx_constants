import 'dart:async';

import 'package:get/get.dart';
import 'package:getx_constants/controller/admin/Invoice/invoice_controller.dart';
import 'package:getx_constants/controller/admin/Invoice/invoice_data_controller.dart';
import 'package:getx_constants/controller/admin/dashboard/dashboard_controller.dart';
import 'package:getx_constants/controller/party/dashboard/party_dashboard_controller.dart';
import 'package:getx_constants/view/party/party_home_view.dart';
import 'package:getx_constants/view/admin/home_view.dart';
import 'package:getx_constants/view/commen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashServices {
  final DashboardController dashboardController =
      Get.put(DashboardController());
  final PartyDashboardController partyDashboardController =
      Get.put(PartyDashboardController());
  final InvoiceDataController invoiceDataController =
      Get.put(InvoiceDataController());
  final InvoiceController invoiceController =
      Get.put(InvoiceController(invoiceRepo: Get.find()));

  Future<void> isLogIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool('isLogin') ?? false) {
      Timer(const Duration(seconds: 5), () {
        String? username = sharedPreferences.getString('USERNAME');
        int? type = sharedPreferences.getInt('TYPE');

        if (type == 2 || type == 0) {
          // Dashboard Data
          dashboardController.ticketPendingData(username!);
          dashboardController.ticketPreviousData(username);
          dashboardController.ticketNewData(username);
          dashboardController.ticketClosedData(username);
          invoiceDataController.postInvoiceStatus("ALL");
          invoiceController.fetchMaxNoFromApi();
          invoiceController.fetchServiceType();
          invoiceController.fetchPartyData();
          invoiceController.postbillingtickets('Yes');

          Get.to(() => const HomeView());
        } else if (type == 3) {
          partyDashboardController.ticketPendingData(username!);
          partyDashboardController.ticketClosedData(username);

          Get.off(() => const PartyHomeView());
        } else {
          Get.off(() => LogInView());
        }
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Get.off(() => LogInView());
      });
    }
  }
}
