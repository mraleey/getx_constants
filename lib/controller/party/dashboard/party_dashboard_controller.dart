import 'dart:convert';

import 'package:get/get.dart';
import 'package:getx_constants/repository/dashboard_repository.dart';

class PartyDashboardController extends GetxController {
  final DashboardRepository dashboardRepo =
      Get.put(DashboardRepository(apiClient: Get.find()));

  RxInt ticketPendingCount = 0.obs;
  RxInt ticketClosedCount = 0.obs;

  List<Map<String, dynamic>> ticketData = [];

  RxList<Map<String, dynamic>> ticketPending = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> ticketClosed = <Map<String, dynamic>>[].obs;

  Future<void> fetchAllTicketsData(String username) async {
    await ticketPendingData(username);
    await ticketClosedData(username);
  }

  Future<void> ticketClosedData(String username) async {
    try {
      ticketClosed.clear();
      Map<String, dynamic> postData = {
        'USERNAME': username,
        'STATUS': "Closed"
      };
      String jsonData = jsonEncode(postData);
      Response response = await dashboardRepo.postPartyTicketStatus(jsonData);
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        if (responseData.isNotEmpty) {
          List<Map<String, dynamic>> ticketList =
              responseData.cast<Map<String, dynamic>>();
          ticketClosedCount.value = responseData[0]['COUNT'];
          ticketClosed.assignAll(ticketList);
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Error occurred while fetching data");
    }
  }

  Future<void> ticketPendingData(String username) async {
    try {
      ticketPending.clear();
      Map<String, dynamic> postData = {
        'USERNAME': username,
        'STATUS': "Pending"
      };
      String jsonData = jsonEncode(postData);
      Response response = await dashboardRepo.postPartyTicketStatus(jsonData);
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        if (responseData.isNotEmpty) {
          List<Map<String, dynamic>> ticketList =
              responseData.cast<Map<String, dynamic>>();
          ticketPendingCount.value = responseData[0]['COUNT'];
          ticketPending.assignAll(ticketList);
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Error occurred while fetching data");
    }
  }
}
