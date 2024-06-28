import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_constants/controller/admin/Invoice/invoice_controller.dart';
import 'package:getx_constants/controller/admin/dashboard/update_ticket_status.dart';
import 'package:getx_constants/controller/admin/ticket/client_info_controller.dart';
import 'package:getx_constants/controller/admin/Invoice/invoice_data_controller.dart';
import 'package:getx_constants/controller/admin/dashboard/dashboard_controller.dart';
import 'package:getx_constants/view_models/login_controller.dart';
import 'package:getx_constants/controller/admin/ticket/ticket_info_controller.dart';
import 'package:getx_constants/common/data/app_urls.dart';
import 'package:getx_constants/controller/party/dashboard/party_dashboard_controller.dart';
import 'package:getx_constants/repository/client_info_repo.dart';
import 'package:getx_constants/repository/dashboard_repository.dart';
import 'package:getx_constants/repository/invoice_repository.dart';
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

  //Admin side

  //Dashboard
  Get.put(DashboardController());
  Get.put(DashboardRepository(apiClient: Get.find()));
  Get.put(PartyDashboardController());

  //Invoice
  Get.put(InvoiceRepository(apiClient: Get.find()));
  Get.put(InvoiceController(invoiceRepo: Get.find()));
  Get.put(InvoiceDataController());

  //Ticket
  Get.put(TicketRepo(apiClient: Get.find()));
  Get.put(UpdateTicketStatusController(statusRepo: Get.find()));

  Get.put(ClientInfoController(ticketRepo: Get.find())).getClientInfo();
  Get.put(TicketInfoController(clientInfoRepo: Get.find())..getTeamMember());
}
