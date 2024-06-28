import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/controller/party/ticket/party_ticket_home_controller.dart';
import 'package:getx_constants/repository/client_info_repo.dart';

class PartyTicketInfoController extends GetxController {
  final PartyTicketController ticketController = Get.put(PartyTicketController());

  TextEditingController subjectController = TextEditingController();
  TextEditingController queryDetailController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController queryCallController = TextEditingController();

  RxList<String> teamUserNames = <String>[].obs;
  RxList<String> teamNames = <String>[].obs;
  List<Map<String, String>> teamNameList = <Map<String, String>>[];

  RxString teamName = ''.obs;
  RxString teamUsername = ''.obs;

  final TicketRepo clientInfoRepo;

  RxList<String> priorityTypeList = <String>[].obs;
  RxString selectedPriorityType = "".obs;

  RxList<String> errorTypeList = <String>[].obs;
  RxString selectedErrorType = "".obs;
  RxInt errorNumber = RxInt(0);

  RxList<String> billingTypeList = <String>[].obs;
  RxString selectedBillingType = "".obs;

  RxList<String> categoryTypeList = <String>[].obs;
  RxString selectedCategoryType = "".obs;

  PartyTicketInfoController({required this.clientInfoRepo});

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<DateTime> selectedQueryTime = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    priorityTypes();
    categoryTypes();
    errorTypes();
    billingTypes();
  }


  void priorityTypes() {
    List<String> priorityTypes = [
      'Select Priority',
      'Low',
      'Medium',
      'High',
      'Critical',
    ];
    priorityTypeList.value = priorityTypes;
  }

  void categoryTypes() {
    List<String> categoryTypes = [
      'Select Category',
      'Support',
      'Development',
    ];
    categoryTypeList.value = categoryTypes;
  }

  void errorTypes() {
    List<String> errorTypes = [
      'Select Error Type',
      'Database',
      'Development',
      'None',
      'Support',
      'Voucher',
      'Voucher Export',
      'Report',
      'Report Export',
    ];
    errorTypeList.value = errorTypes;
  }

  void billingTypes() {
    List<String> billingTypes = [
      'Select Billing Type',
      'Yes',
      'No',
    ];
    billingTypeList.value = billingTypes;
  }

  void collectedData() {
    ticketController.nextStep();

  }

  void updateErrorNumber() {
    switch (selectedErrorType.value) {
      case 'Database':
        errorNumber.value = 1;
        break;
      case 'Report Export':
        errorNumber.value = 2;
        break;
      case 'Support':
        errorNumber.value = 3;
        break;
      case 'Development':
        errorNumber.value = 4;
        break;
      case 'Voucher Export':
        errorNumber.value = 5;
        break;
      case 'Voucher':
        errorNumber.value = 6;
        break;
      case 'Report':
        errorNumber.value = 7;
        break;
      case 'None':
        errorNumber.value = 8;
        break;
      default:
        errorNumber.value = 0;
    }
  }
}
