import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/button.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:getx_constants/constants/current_date.dart';
import 'package:getx_constants/constants/textfield.dart';
import 'package:getx_constants/controller/admin/Invoice/invoice_data_controller.dart';

class CustomInputDialog extends StatelessWidget {
  final InvoiceDataController invoiceDataController = Get.find();

   CustomInputDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: AppColor.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Are You Sure?",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              Column(
                children: [
                  CustomTextField(
                    prefixIcon: Icons.attach_money,
                    controller: invoiceDataController.amountController,
                    labelText: "Enter Amount",
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 10.0),
                  CustomTextField(
                    prefixIcon: Icons.note,
                    controller: invoiceDataController.remarksController,
                    labelText: "Remarks",
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10.0),
                  CustomTextFieldWithDatePicker(
                    controller: invoiceDataController.currentdateController,
                    labelText: "Date",
                    prefixIcon: Icons.date_range,
                    keyboardType: TextInputType.datetime,
                    fillColor: AppColor.white,
                  ),
                  const SizedBox(height: 10.0),
                  Obx(() {
                    return DropdownSearch<String>(
                      // ignore: invalid_use_of_protected_member
                      items: invoiceDataController.paymentTypesList.value,
                      selectedItem: "Select Payment Type",
                      onChanged: (value) {
                        invoiceDataController.selectedPaymentType.value = value ?? '';
                      },
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search for a Payment Type',
                          ),
                        ),
                      ),
                      dropdownBuilder: (context, item) => Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(item ?? ""),
                      ),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.white,
                          labelText: 'Select Payment Type',
                          hintText: 'Search for a Payment Type',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                        width: Get.width * 0.2,
                        height: Get.height * 0.06,
                        color: AppColor.red,
                        title: "No",
                        onPressed: () {
                          invoiceDataController.amountController.clear();
                          invoiceDataController.remarksController.clear();
                          Get.back();
                        },
                        isLoading: false,
                      ),
                      CustomButton(
                        width: Get.width * 0.2,
                        height: Get.height * 0.06,
                        color: AppColor.green,
                        title: "Yes",
                        onPressed: () {
                          int selectedIndex = 0; // Replace with your logic for index
                          String selectedPaymentType = invoiceDataController.selectedPaymentType.value;

                          if (selectedPaymentType.isNotEmpty && selectedPaymentType != "Select Payment Type") {
                            invoiceDataController.postUpdateUnPaidStatus(
                              selectedIndex,
                              amount: invoiceDataController.amountController.text,
                              remarks: invoiceDataController.remarksController.text,
                              currentdate: invoiceDataController.currentdateController,
                              paymentType: selectedPaymentType,
                            );
                            invoiceDataController.postInvoiceStatus("UNPAID");
                            invoiceDataController.amountController.clear();
                            invoiceDataController.remarksController.clear();
                            Get.back();
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please select a payment type',
                              backgroundColor: AppColor.red,
                              colorText: AppColor.white,
                            );
                          }
                        },
                        isLoading: invoiceDataController.isLoading.value,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
