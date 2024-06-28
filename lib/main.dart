import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/common/data/helper/dependencies.dart'
    as dependencies;
import 'package:getx_constants/view/commen/splash_screen.dart';

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();

  
  await dependencies.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Team App',
      home: SplashScreen(),
    );
  }
}
