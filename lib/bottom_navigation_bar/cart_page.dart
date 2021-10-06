import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:mak_b/controller/auth_controller.dart';
import 'package:mak_b/models/Cart.dart';
import 'package:mak_b/pages/login_page.dart';
import 'package:mak_b/pages/payment_page.dart';

import 'package:mak_b/variables/size_config.dart';
import 'package:mak_b/widgets/cart_card.dart';
import 'package:mak_b/widgets/gradient_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final AuthController authController=Get.find<AuthController>();

  // String? id;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _checkPreferences();
  // }
  // void _checkPreferences() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     id = preferences.get('id') as String?;
  //     //pass = preferences.get('pass');
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                "Your Cart",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "${demoCarts.length} items",
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(context, 20)),
          child: ListView.builder(
            itemCount: demoCarts.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Dismissible(
                key: Key(demoCarts[index].product.id.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  setState(() {
                    demoCarts.removeAt(index);
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
                child: CartCard(cartItem: demoCarts[index]),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
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
                            text: "\$115.6",
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
                          authController.id.value.isEmpty?LoginPage():Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentPage()));
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
        ));
  }
}
