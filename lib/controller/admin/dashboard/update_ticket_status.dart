import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/repository/dashboard_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateTicketStatusController extends GetxController {
  TextEditingController descriptionController = TextEditingController();
  final DashboardRepository statusRepo;
  final SharedPreferences sharedPreferences = Get.find();

  UpdateTicketStatusController({required this.statusRepo});

  RxList<String> statusList = <String>[].obs;
  Rx<String> selectedStatus = "".obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    statusTypes();
  }

  void statusTypes() {
    List<String> statusTypes = [
      'Closed',
      'Pending',
      'Progress',
    ];
    statusList.value = statusTypes;
  }

  Map<String, dynamic> collectedNewStatus(String ticketID, String newStatus) {
    String description = descriptionController.text;

    return {
      'ticketId': ticketID,
      'comments': description.isNotEmpty ? description : '',
      'newStatus': newStatus,
      'USERNAME': sharedPreferences.getString('USERNAME'),
    };
  }

  Future<void> postUpdateStatus(String ticketID) async {
    try {
      isLoading.value = true;

      Map<String, dynamic> postData = collectedNewStatus(
          ticketID, statusList[statusList.indexOf(selectedStatus.value)]);

      String postDataJson = jsonEncode(postData);

      Response response = await statusRepo.postUpdatedStatus(postDataJson);
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Ticket status updated successfully",
            backgroundColor: AppColor.green, colorText: AppColor.white);
        Get.back();
      } else {
        Get.snackbar('Error', 'Invalid index');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error Updating Ticket Status: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
