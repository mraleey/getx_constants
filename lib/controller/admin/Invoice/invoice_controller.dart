import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/controller/admin/Invoice/sevice_table.dart';
import 'package:getx_constants/repository/invoice_repository.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceController extends GetxController {
  final InvoiceRepository invoiceRepo;
  InvoiceController({required this.invoiceRepo});

  final SharedPreferences sharedPreferences = Get.find<SharedPreferences>();
  RxList<String> partyNames = <String>[].obs;
  RxList<String> serviceNames = <String>[].obs;
  RxList<TableRowData> tableData = <TableRowData>[].obs;
  RxList<Map<String, dynamic>> allInvoices = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> paidInvoices = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> unpaidInvoices = <Map<String, dynamic>>[].obs;
  List<Map<String, String>> serviceCodes = <Map<String, String>>[];
  List<Map<String, String>> partyCodes = <Map<String, String>>[];

  Rx<DateTime> selectedStartDate = DateTime.now().obs;
  Rx<DateTime> selectedEndDate = DateTime.now().obs;

  RxDouble totalAmount = 0.0.obs;
  RxBool isButtonClicked = false.obs;
  RxBool isLoading = false.obs;
  RxString partyName = ''.obs;
  RxString partyCode = ''.obs;
  RxString serviceName = ''.obs;
  RxString serviceCode = ''.obs;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController invoiceNoController = TextEditingController();
  final TextEditingController currentdateController = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );

  Rx<String> selectedPaymentType = "".obs;
  Rx<Map<String, dynamic>> selectedInvoiceData = Rx<Map<String, dynamic>>({});
  RxList<String> paymentTypesList = <String>[
    'Cash',
    'Jazz Cash',
    'Easy Paisa',
    'Bank Transfer',
    'Cheque'
  ].obs;

  var billingTicketsInvoices = <Map<String, dynamic>>[].obs;
  var ticketNos = <Map<String, String>>[].obs;

  void updateSelectedInvoiceData(Map<String, dynamic> invoiceData) {
    selectedInvoiceData.value = invoiceData;
  }

  void toggleLoading(bool value) {
    isLoading.value = value;
  }

  void setStartDate(DateTime date) {
    selectedStartDate.value = date;
  }

  void setEndDate(DateTime date) {
    selectedEndDate.value = date;
  }

  void addToTable(String description, double amount) {
    tableData.add(
      TableRowData(
        serial: tableData.length + 1,
        description: description,
        amount: amount,
      ),
    );
    totalAmount.value += amount;
  }

  void clearTable() {
    tableData.clear();
    totalAmount.value = 0.0;
  }

  void clearAllFields() {
    partyName.value = '';
    partyCode.value = '';
    serviceName.value = '';
    serviceCode.value = '';
    descriptionController.clear();
    amountController.clear();
    remarksController.clear();
    selectedStartDate.value = DateTime.now();
    selectedEndDate.value = DateTime.now();
    invoiceNoController.clear();
  }

  Future<void> fetchMaxNoFromApi() async {
    try {
      Response response = await invoiceRepo.getInvoiceMaxNo();
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body) as List<dynamic>;
        invoiceNoController.text = responseData[0]['NO'].toString();
      }
    } catch (e) {
      Get.snackbar('Error', 'Error fetching max no: $e',
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  Future<void> fetchPartyData() async {
    try {
      Response response = await invoiceRepo.getPartyData();
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body) as List<dynamic>;
        partyNames.assignAll(responseData.map((e) => e['VNAME'].toString()));
        partyCodes.addAll(responseData.map((e) => {
              'VCODE': e['VCODE'].toString(),
              'VNAME': e['VNAME'].toString(),
            }));
        partyName.value = responseData[0]['VNAME'].toString();
        partyCode.value = responseData[0]['VCODE'].toString();
      }
    } catch (e) {
      Get.snackbar('Error', 'Error fetching party data: $e',
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  Future<void> fetchServiceType() async {
    try {
      Response response = await invoiceRepo.getServices();
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body) as List<dynamic>;
        serviceNames.assignAll(responseData.map((e) => e['SNAME'].toString()));
        serviceCodes.addAll(responseData.map((e) => {
              'SCODE': e['SCODE'].toString(),
              'SNAME': e['SNAME'].toString(),
            }));
        serviceName.value = responseData[0]['SNAME'].toString();
        serviceCode.value = responseData[0]['SCODE'].toString();
      }
    } catch (e) {
      Get.snackbar('Error', 'Error fetching service data: $e',
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  Map<String, dynamic> collectInvoiceData() {
    String startDate = DateFormat('yyyy-MM-dd').format(selectedStartDate.value);
    String endDate = DateFormat('yyyy-MM-dd').format(selectedEndDate.value);
    String remarks = remarksController.text;
    List<Map<String, dynamic>> serviceData = [];

    for (int index = 0; index < tableData.length; index++) {
      Map<String, dynamic> entry = {
        'SERVICE${index + 1}': tableData[index].description,
        'AMOUNT${index + 1}': tableData[index].amount,
      };
      serviceData.add(entry);
    }

    Map<String, dynamic> jsonData = {
      'NO': invoiceNoController.text,
      'VDATE': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'VCODE': partyCode.value,
      'VNAME': partyName.value,
      'TICKETNO': '',
      'SNAME': serviceName.value,
      'SCODE': serviceCode.value,
      'PERIOD': [startDate, endDate],
      'REMARKS': remarks.trim(),
      'ServiceEntries': serviceData,
      'TAMOUNT': totalAmount.value.toStringAsFixed(2),
      'SERIAL': tableData.length - 1,
      'SERIALCOUNT': tableData.length,
      'USERNAME': sharedPreferences.getString('USERNAME'),
    };
    return jsonData;
  }

  Future<void> postInvoiceData() async {
    try {
      toggleLoading(true);

      collectInvoiceData();

      Map<String, dynamic> collectedData = collectInvoiceData();
      String postData = jsonEncode(collectedData);
      Response response = await invoiceRepo.postInvoiceData(postData);
      toggleLoading(false);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Voucher updated successfully',
            colorText: Colors.black, backgroundColor: Colors.green);
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

  Map<String, dynamic> collectInvoiceDataForTicket(
      Map<String, dynamic> selectedInvoice) {
    String startDate = DateFormat('yyyy-MM-dd').format(selectedStartDate.value);
    String endDate = DateFormat('yyyy-MM-dd').format(selectedEndDate.value);
    List<Map<String, dynamic>> serviceData = [];

    for (int index = 0; index < tableData.length; index++) {
      Map<String, dynamic> entry = {
        'SERVICE${index + 1}': tableData[index].description,
        'AMOUNT${index + 1}': tableData[index].amount,
      };
      serviceData.add(entry);
    }

    Map<String, dynamic> jsonData = {
      'NO': invoiceNoController.text,
      'VDATE': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'VCODE': selectedInvoice['VCODE'],
      'VNAME': selectedInvoice['VNAME'],
      'TICKETNO': selectedInvoice['TICKETNO'],
      'SNAME': serviceName.value,
      'SCODE': serviceCode.value,
      'PERIOD': [startDate, endDate],
      'REMARKS': selectedInvoice['SUBJECT'],
      'ServiceEntries': serviceData,
      'TAMOUNT': totalAmount.value.toStringAsFixed(2),
      'SERIAL': tableData.length - 1,
      'SERIALCOUNT': tableData.length,
      'USERNAME': sharedPreferences.getString('USERNAME'),
    };
    return jsonData;
  }

  Future<void> postInvoiceDataForTicket() async {
    try {
      toggleLoading(true);

      collectInvoiceDataForTicket(selectedInvoiceData.value);

      Map<String, dynamic> collectedData =
          collectInvoiceDataForTicket(selectedInvoiceData.value);
      String postData = jsonEncode(collectedData);
      Response response = await invoiceRepo.postInvoiceData(postData);
      toggleLoading(false);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'invoice Generated successfully',
            colorText: Colors.black, backgroundColor: Colors.green);
        clearTable();
        clearAllFields();
        Get.back();
      } else {
        Get.snackbar('Error', 'Error generating invoice',
            colorText: Colors.white, backgroundColor: Colors.red);
      }
    } catch (e) {
      toggleLoading(false);

      Get.snackbar('Error', 'Error generating invoice: ${e.toString()}',
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  Future<void> postbillingtickets(String invoice) async {
    billingTicketsInvoices.clear();
    try {
      Map<String, dynamic> postData = {
        'BILLING': "Yes",
      };
      Response response =
          await invoiceRepo.postbillingtickets(jsonEncode(postData));
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        for (var data in responseData) {
          billingTicketsInvoices.add(data);
        }
        List<Map<String, String>> tickets = [];
        for (var data in responseData) {
          if (data is Map<String, dynamic> &&
              data.containsKey('TICKETNO') &&
              data.containsKey('VNAME') &&
              data.containsKey('VCODE')) {
            tickets.add({
              'TICKETNO': data['TICKETNO'].toString(),
              'VNAME': data['VNAME'].toString(),
              'VCODE': data['VCODE'].toString(),
              'QUERYDETAIL': data['QUERYDETAIL'].toString(),
              'SUBJECT': data['SUBJECT'].toString()
            });
          }
        }
        ticketNos.assignAll(tickets);
      } else {
        Get.snackbar('Error', 'Error fetching billing tickets',
            colorText: Colors.white, backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error fetching billing tickets: $e',
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }
}
