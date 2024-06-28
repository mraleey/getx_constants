import 'package:flutter/material.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/view_models/splash_services.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    super.initState();
    splashServices.isLogIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(image: AssetImage('images/support.png')),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text('Loading...'),
            const SizedBox(height: 20),
            Text(
              'Welcome to Solution Experts',
              style: TextStyle(
                fontSize: CustomFontSize.extraExtraLarge(context),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
