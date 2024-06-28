import 'package:flutter/material.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:intl/intl.dart';

class CustomTextFieldWithDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final Color? fillColor;


  const CustomTextFieldWithDatePicker({super.key, 
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    required this.keyboardType,
    required this.fillColor
  });

  @override
  CustomTextFieldWithDatePickerState createState() =>
     CustomTextFieldWithDatePickerState();
}

class CustomTextFieldWithDatePickerState
    extends State<CustomTextFieldWithDatePicker> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        widget.controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            prefixIcon: const Icon(Icons.date_range),
            border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColor.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColor.black, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColor.black),
        ),
        filled: true,
        fillColor: AppColor.white,
        prefixIconColor: AppColor.loginButtonColor,
        labelStyle: const TextStyle(color: AppColor.loginButtonColor)
          ),
          
        ),
      
      ),
    );
  }
}
