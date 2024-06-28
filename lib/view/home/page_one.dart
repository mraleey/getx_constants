import 'package:flutter/material.dart';
import 'package:getx_constants/constants/fonts.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Image(image: AssetImage('images/user.png')),
        const SizedBox(height: 20),
        Text(
          'Welcome to Getx Constants',
          style: TextStyle(
            fontSize: CustomFontSize.extraExtraLarge(context),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Page One',
          style: TextStyle(
            fontSize: CustomFontSize.extraExtraLarge(context),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}