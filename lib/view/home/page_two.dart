import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/fonts.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: Get.width * 0.3,
              height: Get.height * 0.15,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Image(
                image: AssetImage('images/user.png'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to Getx Constants Page 2',
              style: TextStyle(
                fontSize: CustomFontSize.extraExtraLarge(context),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Page Two',
              style: TextStyle(
                fontSize: CustomFontSize.extraExtraLarge(context),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ]),
    );
  }
}
