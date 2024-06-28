import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/controller/admin/ticket/ticket_home_controller.dart';
import 'package:getx_constants/controller/admin/ticket/ticket_info_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../repository/client_info_repo.dart';

class ClientInfoController extends GetxController {
  final TicketController ticketController = Get.put(TicketController());
  final TicketInfoController ticketInfoController =
      Get.put(TicketInfoController(clientInfoRepo: Get.find()));
  final SharedPreferences sharedPreferences = Get.find<SharedPreferences>();

  RxList<String> partyNames = <String>[].obs;

  List<Map<String, String>> partyCodes = <Map<String, String>>[];
  List<Map<String, String>> ownerNames = <Map<String, String>>[];

  RxString partyName = ''.obs;
  RxString partyCode = ''.obs;

  RxBool isLoading = false.obs;

  void toggleLoading(bool value) {
    isLoading.value = value;
  }

  TextEditingController ownerController = TextEditingController();
  TextEditingController softwareLinkController = TextEditingController();
  TextEditingController contactPerson1Controller = TextEditingController();
  TextEditingController contactPerson2Controller = TextEditingController();
  TextEditingController contactPerson3Controller = TextEditingController();
  TextEditingController contactPerson4Controller = TextEditingController();
  TextEditingController mobile1Controller = TextEditingController();
  TextEditingController mobile2Controller = TextEditingController();

  final TextEditingController tContactController = TextEditingController();
  final TextEditingController tMobileController = TextEditingController();
  final TextEditingController tEmailController = TextEditingController();
  final TextEditingController tSoftwareLinkController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getClientInfo();
  }

  TicketRepo ticketRepo;

  ClientInfoController({required this.ticketRepo});

  Future<void> getClientInfo() async {
    try {
      Response response = await ticketRepo.getClientInfo();
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body) as List<dynamic>;
        partyNames.assignAll(responseData.map((e) => e['VNAME'].toString()));
        partyCodes.addAll(responseData.map((e) => {
              'VCODE': e['VCODE'].toString(),
              'VNAME': e['VNAME'].toString(),
            }));

        ownerNames.addAll(responseData.map((e) => {
              'VCODE': e['VCODE'].toString(),
              'OWNERNAME': e['OWNERNAME'].toString(),
              'SOFTWARELINK': e['SOFTWARELINK'].toString(),
              'CONTACTPERSON1': e['CONTACTPERSON1'].toString(),
              'CONTACTPERSON2': e['CONTACTPERSON2'].toString(),
              'CONTACTPERSON3': e['CONTACTPERSON3'].toString(),
              'CONTACTPERSON4': e['CONTACTPERSON4'].toString(),
              'MOBILE1': e['MOBILE1'].toString(),
              'MOBILE2': e['MOBILE2'].toString(),
            }));

        if (responseData.isNotEmpty) {
          partyName.value = responseData[0]['VNAME'].toString();
          partyCode.value = responseData[0]['VCODE'].toString();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Error fetching party data: $e',
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  Map<String, dynamic> collectedTicketData() {
    Map<String, dynamic> clientData = {
      'vname': partyName.value,
      'vcode': partyCode.value,
      'ownername': ownerController.text,
      'softwarelink': softwareLinkController.text,
      'contactperson1': contactPerson1Controller.text,
      'contactperson2': contactPerson2Controller.text,
      'contactperson3': contactPerson3Controller.text,
      'contactperson4': contactPerson4Controller.text,
      'mobile1': mobile1Controller.text,
      'mobile2': mobile2Controller.text,
      'tcontactperson': tContactController.text,
      'tmobile': tMobileController.text,
      'email': tEmailController.text,
      'tsoftwarelink': tSoftwareLinkController.text,
      'subject': ticketInfoController.subjectController.text,
      'querydetail': ticketInfoController.queryDetailController.text,
      'username': ticketInfoController.teamName.value,
      'priority': ticketInfoController.selectedPriorityType.value,
      'category': ticketInfoController.selectedCategoryType.value,
      'errortype': ticketInfoController.errorNumber.value,
      'duedate': ticketInfoController.dueDateController.text,
      'querytime': ticketInfoController.queryCallController.text,
      'billing': ticketInfoController.selectedBillingType.value,
      'enterby': sharedPreferences.getString('USERNAME'),
      'IMAGES': ""
    };
    return clientData;
  }

  Future<void> generateTicket() async {
    try {
      toggleLoading(true);

      Map<String, dynamic> collectedData = collectedTicketData();

      String postData = jsonEncode(collectedData);
      Response response = await ticketRepo.generateTicket(postData);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Voucher updated successfully',
            colorText: Colors.black, backgroundColor: Colors.green);
        clearAllFields();
        ticketController.previousStep();
        toggleLoading(false);
      } else {
        Get.snackbar('Error', 'Error updating voucher',
            colorText: Colors.white, backgroundColor: Colors.red);
      }
    } catch (e) {
      toggleLoading(false);

      Get.snackbar('Error', 'Error updating voucher: ${e.toString()}',
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  void clearAllFields() {
    partyName.value = '';
    partyCode.value = '';
    ownerController.clear();
    softwareLinkController.clear();
    contactPerson1Controller.clear();
    contactPerson2Controller.clear();
    contactPerson3Controller.clear();
    contactPerson4Controller.clear();
    mobile1Controller.clear();
    mobile2Controller.clear();
    tContactController.clear();
    tMobileController.clear();
    tEmailController.clear();
    tSoftwareLinkController.clear();
    ticketInfoController.subjectController.clear();
    ticketInfoController.queryDetailController.clear();
    ticketInfoController.teamName.value = '';
    ticketInfoController.selectedPriorityType.value = '';
    ticketInfoController.selectedCategoryType.value = '';
    ticketInfoController.errorNumber.value = 0;
    ticketInfoController.dueDateController.clear();
    ticketInfoController.queryCallController.clear();
    ticketInfoController.selectedBillingType.value = '';
  }
}
