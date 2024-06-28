import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/due_end_date.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/constants/textfield.dart';
import 'package:getx_constants/controller/admin/Invoice/invoice_controller.dart';
import 'package:getx_constants/constants/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateInvoiceView extends StatelessWidget {
  final InvoiceController invoiceController =
      Get.put(InvoiceController(invoiceRepo: Get.find()));

  final SharedPreferences sharedPreferences = Get.find<SharedPreferences>();

  CreateInvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Text(
                'Create Invoice',
                style: TextStyle(
                  fontSize: CustomFontSize.extraExtraLarge(context) * 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Get.height / 30),
              buildTextHeader(
                "Party & Service ",
              ),
              SizedBox(height: Get.height / 30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.primaryTheme, width: 3.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                        controller: invoiceController.invoiceNoController,
                        labelText: 'Invoice No',
                        readOnly: true,
                        prefixIcon: Icons.confirmation_number,
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () {
                          if (invoiceController.partyNames.isEmpty) {
                            return const Text('Party Name Not Found');
                          } else {
                            return DropdownSearch<String>(
                              items: invoiceController.partyNames.toList(),
                              selectedItem: "Select Party Name",
                              onChanged: (value) {
                                invoiceController.partyName.value = value!;
                                int index = invoiceController.partyNames.indexOf(value);
                                invoiceController.partyCode.value = invoiceController
                                    .partyCodes[index]["VCODE"]
                                    .toString();
                              },
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColor.white,
                                  labelText: 'Select Party',
                                  hintText: 'Search for a party',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    hintText: 'Search for a party',
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
                      SizedBox(height: Get.height / 30),
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
                                int index = invoiceController.serviceNames.indexOf(value);
                                invoiceController.serviceCode.value = invoiceController
                                    .serviceCodes[index]["SCODE"]
                                    .toString();
                              },
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: Get.height / 30),
              buildTextHeader("Date & Remarks"),
              SizedBox(height: Get.height / 30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.primaryTheme, width: 3.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomDateTimePickerTextField(
                        startDateController: TextEditingController(),
                        endDateController: TextEditingController(),
                        controller: invoiceController.selectedStartDate,
                        hintText: 'Select Start Date Time',
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: invoiceController.remarksController,
                        labelText: 'Remarks',
                        keyboardType: TextInputType.text,
                        prefixIcon: Icons.receipt_long,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Get.height / 30),
              buildTextHeader("Service Details"),
              SizedBox(height: Get.height / 30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.primaryTheme, width: 3.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                        controller: invoiceController.descriptionController,
                        labelText: 'Description',
                        keyboardType: TextInputType.text,
                        prefixIcon: Icons.description,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: invoiceController.amountController,
                        labelText: 'Amount',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        prefixIcon: Icons.attach_money,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        width: Get.width / 2,
                        height: Get.height / 15,
                        color: AppColor.primaryThemeLight,
                        title: "Add Service",
                        onPressed: () {
                          if (invoiceController.amountController.text.isNotEmpty &&
                              invoiceController.descriptionController.text.isNotEmpty) {
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
                      const SizedBox(height: 20),
                      Obx(
                        () {
                          if (invoiceController.isButtonClicked.value) {
                            return DataTable(
                              columns: const [
                                DataColumn(label: Text('Serial')),
                                DataColumn(label: Text('Description')),
                                DataColumn(label: Text('Amount')),
                              ],
                              rows: invoiceController.tableData
                                  .map(
                                    (rowData) => DataRow(
                                      cells: [
                                        DataCell(
                                            Text(rowData.serial.toString())),
                                        DataCell(Text(rowData.description)),
                                        DataCell(Text(
                                            rowData.amount.toStringAsFixed(2))),
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
                        () => Text(
                          'Total Amount: \$${invoiceController.totalAmount.value.toStringAsFixed(2)}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Obx(
                  () => CustomButton(
                    color: AppColor.green,
                    width: Get.width / 2,
                    height: Get.height / 15,
                    title: "Submit",
                    onPressed: () {
                      invoiceController.postInvoiceData();
                    },
                    isLoading: invoiceController.isLoading.value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextHeader(String text, {Color? color}) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColor.primaryTheme,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppColor.white,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      width: Get.width,
      height: Get.height / 20,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.white,
          ),
        ),
      ),
    );
  }
}
