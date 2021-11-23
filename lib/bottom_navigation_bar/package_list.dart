import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mak_b/controller/product_controller.dart';
import 'package:mak_b/variables/size_config.dart';
import 'package:mak_b/widgets/package_card.dart';

import '../home_nav.dart';

class PackageListPage extends StatefulWidget {
  const PackageListPage({Key? key}) : super(key: key);

  @override
  _PackageListPageState createState() => _PackageListPageState();
}

class _PackageListPageState extends State<PackageListPage> {
  final ProductController productController=Get.find<ProductController>();

  @override

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "All Packages",
            style: TextStyle(color: Colors.black),
          ),
        ),

        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: ()async{
              await productController.getPackage();
              print('Refresh');
            },
            child: ListView(
              physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: getProportionateScreenWidth(context,10)),
              Padding(
                padding:  EdgeInsets.only(top: size.width*.02,left: size.width*.02,right: size.width*.02,bottom:size.width*.02 ),

                child: Text('Regular Package',style: TextStyle(color: Colors.black,fontSize: size.width*.05 ),),
              ),

              Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: new ClampingScrollPhysics(),
                  itemCount:productController.packageList.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      childAspectRatio: 5/9),
                  itemBuilder: (BuildContext context, int index) {
                    // if (demoProducts[index].isPopular)
                    return PackageCard(product: productController.packageList[index], sold: false,);
                    // return SizedBox
                    //     .shrink(); // here by default width and height is 0
                  },
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
  Future<bool> _onBackPressed() {
    Get.offAll(HomeNav());
    return Future<bool>.value(true);
  }
}
