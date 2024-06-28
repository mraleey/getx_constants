import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/textfield.dart';
import 'package:intl/intl.dart';

class CustomDateTimePickerTextField extends StatelessWidget {
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final Rx<DateTime> controller;
  final String hintText;

  const CustomDateTimePickerTextField({
    super.key,
    required this.startDateController,
    required this.endDateController,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColor.primaryThemeLight,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              startDateController.text = formattedDate;
              controller.value = pickedDate;
            }
          },
          child: AbsorbPointer(
            child: CustomTextField(
              controller: startDateController,
              labelText: "Select Start Date",
              prefixIcon: Icons.event,
            ),
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColor.primaryThemeLight,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              endDateController.text = formattedDate;
            }
          },
          child: AbsorbPointer(
            child: CustomTextField(
              controller: endDateController,
              labelText: "Select End Date",
              prefixIcon: Icons.event,
            ),
          ),
        ),
      ],
    );
  }
}
