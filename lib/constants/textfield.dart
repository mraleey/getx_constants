import 'package:flutter/material.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final bool obscureText;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final Color? prefixIconColor;
  final Color? borderColor;
  final Color? labelColor;
  final double? borderWidth;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.obscureText = false,
    this.focusNode,
    this.readOnly,
    this.keyboardType,
    this.fillColor,
    this.prefixIconColor,
    this.borderColor,
    this.labelColor,
    this.borderWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      readOnly: readOnly ?? false,
      style: TextStyle(
        fontSize: CustomFontSize.large(context),
        color: AppColor.black,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: CustomFontSize.large(context),
          color: labelColor ?? AppColor.loginButtonColor,
        ),
        prefixIcon: Icon(prefixIcon,
            color: prefixIconColor ?? AppColor.loginButtonColor),
        suffixIcon: suffixIcon,
        suffixIconColor: AppColor.loginButtonColorLight,
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
          borderSide: BorderSide(color: borderColor ?? AppColor.darkGrey),
        ),
        filled: true,
        fillColor: fillColor ?? Colors.white,
      ),
    );
  }
}
