import 'package:flutter/material.dart';
import 'package:mak_b/home_nav.dart';
import 'package:mak_b/pages/login_page.dart';
import 'package:mak_b/bottom_navigation_bar/product_page.dart';
import 'package:mak_b/variables/theme.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mak B',
      theme: theme(),
      home: HomeNav(),
    );
  }
}
