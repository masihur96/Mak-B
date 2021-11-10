import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:mak_b/pages/splash_screen_page.dart';
import 'package:mak_b/variables/theme.dart';
import 'controller/auth_controller.dart';
import 'controller/user_controller.dart';
import 'home_nav.dart';

Future<void> main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  // DevicePreview(
  //
  //    enabled: !kReleaseMode,
  //   builder: (context) => MyApp(), // Wrap your app
  // );
    runApp(MyApp());
}
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // locale: DevicePreview.locale(context), // Add the locale here
      // builder: DevicePreview.appBuilder, // Ad
      debugShowCheckedModeBanner: false,
      title: 'Mak B',
      theme: theme(),
      home: SplashScreen(),
    );
  }
}
