import 'package:flutter/material.dart';
import 'package:getx_constants/constants/colors.dart';

class CustomDropdownMenu extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final void Function(String?)? onChanged;
  // final Color? fillColor;

  const CustomDropdownMenu({
    super.key,
    required this.items,
    required this.selectedItem,
    this.onChanged,
    // this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(
          color: AppColor.primaryTheme,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(selectedItem) ? selectedItem : items[0],
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
