import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:mak_b/controller/product_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/pages/login_page.dart';
import 'package:mak_b/pages/payment_page.dart';
import 'package:mak_b/variables/size_config.dart';
import 'package:mak_b/widgets/gradient_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_nav.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ProductController productController=Get.find<ProductController>();
  final UserController userController=Get.find<UserController>();
  int count=0;
  String? id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }
  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.get('id') as String?;
      //pass = preferences.get('pass');
    });
  }

  @override
  Widget build(BuildContext context) {
    if(id!=null){
      productController.getCart();
    }
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Obx(()=>Scaffold(
          appBar: AppBar(
            title: Column(
              children: [
                Text(
                  "Your Cart",
                  style: TextStyle(color: Colors.black),
                ),
                productController.cartList==null?Text(
                  "0 items",
                  style: Theme.of(context).textTheme.caption,
                ):Text(
                  "${productController.cartList.length} items",
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(context, 20)),
            child: ListView.builder(
                itemCount: productController.cartList==null?0:productController.cartList.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Dismissible(
                        key: Key(productController.cartList[index].id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            productController.cartList.removeAt(index);
                          });
                        },
                        background: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Spacer(),
                              Icon(
                                FontAwesomeIcons.removeFormat,
                                size: 10,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                        child: Container(
                          color: Color(0xFF19B52B).withOpacity(0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding:
                                  const EdgeInsets.all(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: productController.cartList[index].productImage!,
                                    imageBuilder: (context, imageProvider) => Container(
                                      width: size.width*.25,
                                      height: size.width*.2,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider, fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) => CircleAvatar(
                                        backgroundColor: Colors.grey.shade200,
                                        radius: size.width * .08,
                                        backgroundImage: AssetImage(
                                            'assets/images/placeholder.png')),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  )
                                // Image.network(
                                //   productController.cartList[index].productImage!,
                                //   width: 80,
                                // ),
                              ),
                              Expanded(
                                  child: Wrap(
                                    direction: Axis.vertical,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(left: 14),
                                          child: Text(
                                            productController.cartList[index].productName!,
                                          )
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 14),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                if(productController.cartList[index].quantity!=1){
                                                  int qnty=productController.cartList[index].quantity-1;
                                                  productController.updateCart(productController.cartList[index].productId,qnty);
                                                  setState(() {
                                                    productController.total=productController.total-int.parse(productController.cartList[index].price);
                                                  });
                                                }
                                              },
                                              child: Icon(
                                                FontAwesomeIcons.minus,
                                                size: 20,
                                                color: Colors.black.withOpacity(0.5),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  8.0),
                                              child: Text(
                                                '${productController.cartList[index].quantity}',style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            InkWell(
                                              onTap: (){
                                                int qnty=productController.cartList[index].quantity+1;
                                                productController.updateCart(productController.cartList[index].productId,qnty);
                                                setState(() {
                                                  productController.total=productController.total+int.parse(productController.cartList[index].price);
                                                });
                                              },
                                              child: Icon(
                                                FontAwesomeIcons.plus,
                                                size: 20,
                                                color: Colors.black.withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                              Padding(
                                padding:
                                const EdgeInsets.all(14),
                                child: Text(
                                  "\৳${productController.cartList[index].price}",
                                  style: TextStyle(fontSize: size.width*.045,
                                    fontWeight: FontWeight.bold,),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right:8.0),
                                child: InkWell(
                                  onTap: (){
                                    productController.deleteCartItem(productController.cartList[index].productId);
                                  },
                                  child: Icon(
                                    FontAwesomeIcons.trash,
                                    size: 20,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  );
                }
            ),
          ),
          bottomNavigationBar: Obx(()=>Container(
            padding: EdgeInsets.symmetric(
              //vertical: getProportionateScreenWidth(context,15),
              horizontal: getProportionateScreenWidth(context, 30),
            ),
            height: size.height * .11,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -15),
                  blurRadius: 20,
                  color: Color(0xFFDADADA).withOpacity(0.15),
                )
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getProportionateScreenHeight(context, 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Total:\n",
                          children: [
                            TextSpan(
                              text: '\৳${productController.total}',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      GradientButton(
                          child: Text(
                            'Buy Now',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            //id==null?Get.to(()=>LoginPage()):
                            Get.to(()=>PaymentPage('',userController.user.name,userController.user.phone));
                          },
                          borderRadius: 5.0,
                          height: size.width * .1,
                          width: size.width * .25,
                          gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)])
                    ],
                  ),
                ],
              ),
            ),
          ))
      )),
    );
  }

  Future<bool> _onBackPressed(){
    Get.offAll(HomeNav());
    return Future<bool>.value(true);
  }
}
