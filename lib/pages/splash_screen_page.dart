import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mak_b/controller/advertisement_controller.dart';
import 'package:mak_b/controller/auth_controller.dart';
import 'package:mak_b/controller/product_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/variables/size_config.dart';

import '../home_nav.dart';
import 'first_user_register_page.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserController userController=Get.put(UserController());
  int count=0;

  Future<void> fetch()async{
    final AdvertisementController advertisementController=Get.put(AdvertisementController());
    final AuthController authController=Get.put(AuthController());
    final ProductController productController=Get.put(ProductController());

    await userController.getFirstUser();
    await productController.getProducts(100);
    await productController.getArea();
    await productController.getCart();
    await userController.getRate();
    await productController.getCategory();
    await productController.getSubCategory(productController.categoryList[0].category);
    //await productController.getSubCategoryProducts(productController.subCategoryList[0].subCategory);
    await productController.getCart();
    await productController.getAreaHub(productController.areaList[0].id);

    if(userController.checkUserModel.value.count!='0'){
      Timer(
          Duration(seconds: 1),
              () =>Get.offAll(()=>HomeNav()));
    }else{
      Timer(
          Duration(seconds: 1),
              () =>Get.offAll(()=>FirstUserRegisterPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SizeConfig().init(context);

    if(count==0){
      fetch();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: size.height*.4,
              width: size.width*.8,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/icons/deub.png"),
                      fit: BoxFit.contain),
                  borderRadius: BorderRadius.circular(5)),
            ),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Powered by Mak B',
                  textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width*.05,
                    fontWeight: FontWeight.bold,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 20,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
          ],
        ),
      ),
    );
  }
}
