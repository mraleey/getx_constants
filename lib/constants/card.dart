import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';

class CustomCard extends StatelessWidget {
  final double? width;
  final Color borderColor;
  final IconData? icon;
  final String cardName;
  final String? cardContent;

  const CustomCard({
    super.key,
    this.width,
    required this.borderColor,
    required this.cardName,
    this.icon,
    this.cardContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: borderColor,
      ),
      width: width ?? Get.width,
      height: Get.height / 5,
      child: Card(
        color: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: CustomFontSize.extraExtraLarge(context) * 2,
            ),
            SizedBox(
              height: Get.height / 50,
            ),
            Text(
              cardName,
              style: TextStyle(
                fontSize: CustomFontSize.extraExtraLarge(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Get.height / 50),
            Text(
              cardContent ?? '',
              style: TextStyle(
                fontSize: CustomFontSize.extraLarge(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
