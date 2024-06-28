import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/dropdown.dart';
import 'package:getx_constants/constants/due_date.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/controller/admin/ticket/ticket_info_controller.dart';
import 'package:getx_constants/constants/button.dart';
import 'package:getx_constants/constants/textfield.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';

class TicketInfoView extends StatelessWidget {
  final TicketInfoController ticketInfoController =
      Get.put(TicketInfoController(clientInfoRepo: Get.find()));
  TicketInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Ticket Info',
            style: TextStyle(
                color: AppColor.primaryThemeLight,
                fontSize: CustomFontSize.large(context) * 1.5,
                fontWeight: FontWeight.bold),
          ),
          Container(
            width: Get.width * 0.9,
            decoration: BoxDecoration(
                border:
                    Border.all(color: AppColor.primaryThemeLight, width: 3.0),
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
                  ),
                  SizedBox(height: Get.height / 30),
                  CustomTextField(
                    controller: ticketInfoController.queryDetailController,
                    labelText: 'Query Details',
                    prefixIcon: Icons.query_stats,
                  ),
                  SizedBox(height: Get.height / 30),
                  FutureBuilder(
                    future: ticketInfoController.getTeamMember(),
                    builder: (context, snapshot) {
                      return Obx(
                        () {
                          if (ticketInfoController.teamUserNames.isEmpty) {
                            return const Text('Team Name Not Found');
                          } else {
                            return DropdownSearch<String>(
                              items:
                                  ticketInfoController.teamUserNames.toList(),
                              selectedItem: "Selected Index",
                              onChanged: (value) {
                                ticketInfoController.teamName.value = value!;
                              },
                              dropdownDecoratorProps: const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColor.white,
                                  labelText: 'Select Team Member',
                                  hintText: 'Search for a team member',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    hintText: 'Search for a team member',
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
                      );
                    },
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
                      decoration: const InputDecoration(
                        labelText: 'Error Type',
                        border: OutlineInputBorder(),
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
