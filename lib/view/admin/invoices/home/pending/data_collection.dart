import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/button.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/due_end_date.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/constants/textfield.dart';
import 'package:getx_constants/controller/admin/Invoice/invoice_controller.dart';

Widget collectedDataForInvoice(
    BuildContext? context, Map<String, dynamic> selectedInvoice) {
  final InvoiceController invoiceController =
      Get.put(InvoiceController(invoiceRepo: Get.find()));

  invoiceController.selectedInvoiceData.value = selectedInvoice;

  Get.dialog(
    transitionDuration: const Duration(milliseconds: 500),
    barrierColor: AppColor.primaryTheme.withOpacity(0.5),
    transitionCurve: Curves.easeIn,
    barrierDismissible: false,
    Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () {
                  if (invoiceController.serviceNames.isEmpty) {
                    return const Text('Service Type Not Found');
                  } else {
                    return DropdownSearch<String>(
                      items: invoiceController.serviceNames.toList(),
                      selectedItem: "Select Service Type",
                      onChanged: (value) {
                        invoiceController.serviceName.value = value!;
                        int index =
                            invoiceController.serviceNames.indexOf(value);
                        invoiceController.serviceCode.value = invoiceController
                            .serviceCodes[index]["SCODE"]
                            .toString();
                      },
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.white,
                          labelText: 'Select Service',
                          hintText: 'Search for Services',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search for Services',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      dropdownBuilder: (context, item) => Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(item ?? ""),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              CustomDateTimePickerTextField(
                startDateController: TextEditingController(),
                endDateController: TextEditingController(),
                controller: invoiceController.selectedStartDate,
                hintText: 'Select Start Date Time',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: invoiceController.descriptionController,
                labelText: 'Service',
                keyboardType: TextInputType.text,
                prefixIcon: Icons.description,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: invoiceController.amountController,
                labelText: 'Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Icons.attach_money,
              ),
              const SizedBox(height: 20),
              Center(
                child: CustomButton(
                  width: Get.width / 2,
                  height: Get.height / 15,
                  color: AppColor.primaryThemeLight,
                  title: "Add Service",
                  onPressed: () {
                    if (invoiceController.amountController.text.isNotEmpty &&
                        invoiceController
                            .descriptionController.text.isNotEmpty) {
                      double amount =
                          double.parse(invoiceController.amountController.text);
                      invoiceController.addToTable(
                        invoiceController.descriptionController.text,
                        amount,
                      );
                      invoiceController.amountController.clear();
                      invoiceController.descriptionController.clear();
                      invoiceController.isButtonClicked.value = true;
                    }
                  },
                  isLoading: false,
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () {
                  if (invoiceController.isButtonClicked.value) {
                    return DataTable(
                      columns: const [
                        DataColumn(label: Text('Serial')),
                        DataColumn(label: Text('Service')),
                        DataColumn(label: Text('Amount')),
                      ],
                      rows: invoiceController.tableData
                          .map(
                            (rowData) => DataRow(
                              cells: [
                                DataCell(Text(rowData.serial.toString())),
                                DataCell(Text(rowData.description)),
                                DataCell(
                                    Text(rowData.amount.toStringAsFixed(2))),
                              ],
                            ),
                          )
                          .toList(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 20),
              Obx(
                () => Center(
                  child: Text(
                    'Total Amount: Rs: ${invoiceController.totalAmount.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: CustomFontSize.extraLarge(context!),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: "Close",
                      color: AppColor.red,
                      width: Get.width / 2.5,
                      height: Get.height / 15,
                      onPressed: () {
                        invoiceController.clearAllFields();
                        invoiceController.tableData.clear();
                        invoiceController.totalAmount.value = 0.0;
                        Get.back();
                      },
                      isLoading: false,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Obx(
                      () => CustomButton(
                        title: "Generate Invoice",
                        color: AppColor.green,
                        width: Get.width / 2.5,
                        height: Get.height / 15,
                        onPressed: () async {
                          if (invoiceController.tableData.isNotEmpty) {
                            invoiceController.postInvoiceDataForTicket();
                            try {
                              Get.snackbar(
                                  'Success', 'Invoice generated successfully',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.green);
                              Get.back();
                            } catch (e) {
                              Get.snackbar(
                                  'Error', 'Failed to generate invoice',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.red);
                            }
                          } else {
                            Get.snackbar(
                                'Error', 'Add service to generate invoice',
                                colorText: Colors.white,
                                backgroundColor: Colors.red);
                          }
                        },
                        isLoading: invoiceController.isLoading.value,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  return Container();
}
