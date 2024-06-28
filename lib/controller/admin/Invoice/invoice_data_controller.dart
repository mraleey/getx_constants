import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:getx_constants/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:getx_constants/repository/invoice_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceDataController extends GetxController {
  final SharedPreferences sharedPreferences = Get.find();
  final InvoiceRepository invoiceRepo = Get.put(InvoiceRepository(apiClient: Get.find()));

  RxList<Map<String, dynamic>> allInvoices = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> paidInvoices = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> unpaidInvoices = <Map<String, dynamic>>[].obs;

  TextEditingController amountController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController currentdateController = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );

  RxList<String> paymentTypesList = <String>[
    'Cash',
    'Jazz Cash',
    'Easy Paisa',
    'Bank Transfer',
    'Cheque'
  ].obs;
  Rx<String> selectedPaymentType = "".obs;

  RxBool isLoading = false.obs;

  void sortInvoices() {
    allInvoices.sort((a, b) => a['NO'].compareTo(b['NO']));
  }


  Future<Uint8List> fetchPdf(Map<String, dynamic> invoice) async {
    const String printApiUrl = 'https://solexp5.com/print.php';

    final body = jsonEncode({
      'no': invoice['NO'],
      'username': 'admin',
    });
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(printApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        final String pdfUrl = responseJson['link'];

        final pdfResponse = await http.get(Uri.parse(pdfUrl));
        if (pdfResponse.statusCode == 200) {
          final Uint8List pdfData = pdfResponse.bodyBytes;
          return pdfData;
        } else {
          throw Exception(
              'Failed to load PDF from link: ${pdfResponse.statusCode}');
        }
      } else {
        throw Exception(
            'Failed to load PDF: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> postInvoiceStatus(String voucherNumber) async {
    try {
      Map<String, dynamic> postData = {
        'STATUS': "ALL",
      };

      Response response =
          await invoiceRepo.postInvoiceStatus(jsonEncode(postData));
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        allInvoices.value = responseData
            .where((invoice) =>
                invoice['STATUS'] == 'PAID' || invoice['STATUS'] == 'UNPAID')
            .toList()
            .cast<Map<String, dynamic>>();

        paidInvoices.value = responseData
            .where((invoice) => invoice['STATUS'] == 'PAID')
            .toList()
            .cast<Map<String, dynamic>>();

        unpaidInvoices.value = responseData
            .where((invoice) => invoice['STATUS'] == 'UNPAID')
            .toList()
            .cast<Map<String, dynamic>>();

        sortInvoices();
      } else {
        Get.snackbar('Error', 'Error posting voucher number');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error posting voucher number: $e');
    }
  }

  Map<String, dynamic> collectInvoiceData(int selectedIndex) {
    String amount = amountController.text;
    String paymentType = selectedPaymentType.value;

    Map<String, dynamic> invoice = allInvoices[selectedIndex];

    Map<String, dynamic> jsonData = {
      'NO': invoice["NO"],
      'VDATE': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'VCODE': invoice["VCODE"],
      'VNAME': invoice["VNAME"],
      'AMOUNT': invoice["AMOUNT"],
      'NEWAMOUNT': amount.isNotEmpty ? double.parse(amount) : 0.0,
      'STATUS': 'PAID',
      'USERNAME': sharedPreferences.getString('USERNAME'),
      'PAYMENT_TYPE': paymentType,
    };

    json.encode(jsonData).trim();
    return jsonData;
  }

  Map<String, dynamic> collectUnPaidInvoiceData(int selectedIndex) {
    String amount = amountController.text;
    String paymentType = selectedPaymentType.value;

    if (selectedIndex >= 0 && selectedIndex < unpaidInvoices.length) {
      Map<String, dynamic> invoice = unpaidInvoices[selectedIndex];

      Map<String, dynamic> jsonData = {
        'NO': invoice["NO"],
        'VDATE': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'VCODE': invoice["VCODE"],
        'VNAME': invoice["VNAME"],
        'AMOUNT': invoice["AMOUNT"],
        'NEWAMOUNT': amount.isNotEmpty ? double.parse(amount) : 0.0,
        'STATUS': 'PAID',
        'USERNAME': sharedPreferences.getString('USERNAME'),
        'PAYMENT_TYPE': paymentType,
      };
      return jsonData;
    } else {
      throw Exception("Invalid index");
    }
  }

  void paymentTypes() {
    List<String> paymentTypes = [
      'Cash',
      'Jazz Cash',
      'Easy Paisa',
      'Bank Transfer',
      'Cheque',
    ];
    paymentTypesList.value = paymentTypes;
  }

  Future<void> postUpdateStatus(int selectedIndex) async {
    try {
      isLoading.value = true;
      if (selectedIndex >= 0 && selectedIndex < allInvoices.length) {
        Map<String, dynamic> postData = collectInvoiceData(selectedIndex);
        String postDataJson = jsonEncode(postData);
        Response response = await invoiceRepo.postUpdateStatus(postDataJson);
        if (response.statusCode == 200) {
          Get.snackbar("Success", "Invoice status updated successfully",
              backgroundColor: AppColor.green, colorText: AppColor.white);
          Get.back();
        } else {
          Get.snackbar('Error', 'Error posting voucher number',
              backgroundColor: AppColor.red, colorText: AppColor.white);
        }
      } else {
        Get.snackbar('Error', 'Invalid index');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error posting voucher number: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> postUpdateUnPaidStatus(int selectedIndex,
      {required String amount,
      required String remarks,
      required String paymentType,
      required currentdate}) async {
    try {
      isLoading.value = true;
      if (selectedIndex >= 0 && selectedIndex < unpaidInvoices.length) {
        Map<String, dynamic> postData = collectUnPaidInvoiceData(selectedIndex);

        postData['amount'] = amount;
        postData['remarks'] = remarks;
        postData['currentDate'] = currentdate;
        postData['paymentType'] = paymentType;

        String postDataJson = jsonEncode(postData);
        Response response = await invoiceRepo.postUpdateStatus(postDataJson);
        if (response.statusCode == 200) {
          Get.snackbar("Success", "Invoice status updated successfully",
              backgroundColor: AppColor.green, colorText: AppColor.white);

          amountController.clear();
          remarksController.clear();
          selectedPaymentType.value = "";
          Get.back();
        } else {
          Get.snackbar('Error', 'Error posting voucher number',
              backgroundColor: AppColor.red, colorText: AppColor.white);
        }
      } else {
        Get.snackbar('Error', 'Invalid index');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error posting voucher number: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
