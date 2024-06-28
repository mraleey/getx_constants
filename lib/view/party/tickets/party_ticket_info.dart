import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/dropdown.dart';
import 'package:getx_constants/constants/due_date.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/controller/party/ticket/party_ticket_info_controller.dart';
import 'package:getx_constants/constants/button.dart';
import 'package:getx_constants/constants/textfield.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';

class PartyTicketInfoView extends StatelessWidget {
  final PartyTicketInfoController ticketInfoController =
      Get.put(PartyTicketInfoController(clientInfoRepo: Get.find()));
  PartyTicketInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Ticket Info',
            style: TextStyle(
                color: AppColor.partyprimaryColor,
                fontSize: CustomFontSize.large(context) * 1.5,
                fontWeight: FontWeight.bold),
          ),
          Container(
            width: Get.width * 0.9,
            decoration: BoxDecoration(
                border:
                    Border.all(color: AppColor.partyprimaryColor, width: 3.0),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: Get.height / 30),
                  CustomTextField(
                    controller: ticketInfoController.subjectController,
                    labelText: 'Subject',
                    prefixIcon: Icons.subject,
                    prefixIconColor: AppColor.partyprimaryColorDark,
                    labelColor: AppColor.partyprimaryColorDark,
                    borderColor: AppColor.partyprimaryColorDark,
                  ),
                  SizedBox(height: Get.height / 30),
                  CustomTextField(
                    controller: ticketInfoController.queryDetailController,
                    labelText: 'Query Details',
                    prefixIcon: Icons.query_stats,
                    prefixIconColor: AppColor.partyprimaryColorDark,
                    labelColor: AppColor.partyprimaryColorDark,
                    borderColor: AppColor.partyprimaryColorDark,
                  ),
                  SizedBox(height: Get.height / 30),
                  Obx(
                    () => CustomDropdownMenu(
                      items: ticketInfoController.priorityTypeList,
                      selectedItem:
                          ticketInfoController.selectedPriorityType.value,
                      onChanged: (newValue) {
                        ticketInfoController.selectedPriorityType.value =
                            newValue!;
                      },
                    ),
                  ),
                  SizedBox(height: Get.height / 30),
                  Obx(
                    () => CustomDropdownMenu(
                      items: ticketInfoController.categoryTypeList,
                      selectedItem:
                          ticketInfoController.selectedCategoryType.value,
                      onChanged: (newValue) {
                        ticketInfoController.selectedCategoryType.value =
                            newValue!;
                      },
                    ),
                  ),
                  SizedBox(height: Get.height / 30),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: ticketInfoController
                              .selectedErrorType.value.isNotEmpty
                          ? ticketInfoController.selectedErrorType.value
                          : 'Select Error Type',
                      items: ticketInfoController.errorTypeList
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          ticketInfoController.selectedErrorType.value =
                              newValue;
                          ticketInfoController.updateErrorNumber();
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Error Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: AppColor.white,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value == 'Select Error Type') {
                          return 'Please select an error type';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: Get.height / 30),
                  CustomDueDatePicker(
                    controller: ticketInfoController.selectedDate,
                    dateController: ticketInfoController.dueDateController,
                    hintText: 'Due Date',
                  ),
                  SizedBox(height: Get.height / 30),
                  GestureDetector(
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppColor.partyprimaryColor,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedTime != null) {
                        DateTime combinedDateTime = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        String formattedTime =
                            DateFormat('HH:mm:ss').format(combinedDateTime);
                        ticketInfoController.queryCallController.text =
                            formattedTime;
                        ticketInfoController.selectedQueryTime.value =
                            combinedDateTime;
                      }
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                        controller: ticketInfoController.queryCallController,
                        labelText: 'Query Call',
                        prefixIcon: Icons.watch_later_outlined,
                        readOnly: true,
                        prefixIconColor: AppColor.partyprimaryColorDark,
                        labelColor: AppColor.partyprimaryColorDark,
                        borderColor: AppColor.partyprimaryColorDark,
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height / 30),
                  Obx(
                    () => CustomDropdownMenu(
                      items: ticketInfoController.billingTypeList,
                      selectedItem:
                          ticketInfoController.selectedBillingType.value,
                      onChanged: (newValue) {
                        ticketInfoController.selectedBillingType.value =
                            newValue!;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: Get.height / 30),
          CustomButton(
            color: AppColor.green,
            width: Get.width * 0.3,
            height: Get.height * 0.06,
            title: 'Next',
            isLoading: false,
            onPressed: () {
              ticketInfoController.collectedData();
            },
          ),
        ],
      ),
    );
  }
}
