import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mak_b/bottom_navigation_bar/cart_page.dart';
import 'package:get/get.dart';
import 'package:mak_b/controller/product_controller.dart';
import 'package:mak_b/models/product_model.dart';
import 'package:mak_b/pages/login_page.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/variables/size_config.dart';
import 'package:mak_b/widgets/gradient_button.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../payment_page.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatefulWidget {
  final ProductModel product;

  const Body({required this.product});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final ProductController productController=Get.find<ProductController>();
  String? _size;
  int indx=0;
  String? id;
  bool exist=false;
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
    final size = MediaQuery.of(context).size;
    if(productController.productIdList.contains(widget.product.id)) {
      setState(() {
        exist = true;
      });
    }
    return ListView(
      children: [
        ProductImages(product: widget.product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(context,20)),
                    child: Text(
                      widget.product.title!,
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: size.width*.065),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(
                      left: getProportionateScreenWidth(context,20),
                      right: getProportionateScreenWidth(context,64),
                    ),
                    child: Text(
                      widget.product.description!,
                      maxLines: 3,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Padding(
                        padding:
                        EdgeInsets.only(left: getProportionateScreenWidth(context,20)),
                        child: Text(
                          'Price: '+'\৳${widget.product.price}',
                          style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold,fontSize: size.width*.045),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Text(
                        "\৳${widget.product.price}",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: size.width*.036,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),

                  Row(
                    children: [
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(context,20)),
                        child: Container(
                          width: size.width*.25,
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: size.height*.01),
                          decoration: BoxDecoration(
                              border: Border.all(color: kPrimaryColor,width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isDense: true,
                              isExpanded: true,
                              value: _size,
                              hint: Text('Size',style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'OpenSans',
                                fontSize: size.height*.022,)),
                              items:widget.product.size!.map((sizes){
                                return DropdownMenuItem(
                                  child: Text(sizes, style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: size.height * .022,fontFamily: 'OpenSans'
                                  )),
                                  value: sizes.toString(),
                                );
                              }).toList(),
                              onChanged: (newVal){
                                setState(() {
                                  _size = newVal as String;
                                });
                              },
                              dropdownColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(context,20)),
                        child: Row(
                          children: [
                            Text('Color: '),
                            Container(
                              width: size.width*.4,
                              height: size.height*.05,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount:widget.product.colors!.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return   Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            indx=index;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              border: Border.all(color: kPrimaryColor),
                                              color: index==indx?Colors.green.withOpacity(0.5):Colors.white,
                                              shape: BoxShape.rectangle
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              height: 30,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  color: widget.product.colors!.isEmpty? Colors.white70:Color(int.parse(widget.product.colors![index])),
                                                  shape: BoxShape.rectangle
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),


                ],
              ),
              TopRoundedContainer(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: getProportionateScreenWidth(context,15),
                        top: getProportionateScreenWidth(context,15),
                      ),
                      child: GradientButton(
                          child: Text(
                            'Add To Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if(exist==false){
                              setState(() {
                                exist=true;
                              });
                              String? size=_size==null?'No Size':_size;
                              productController.addToCart(widget.product.title!, widget.product.id!, widget.product.price!, 1,
                                  widget.product.colors![indx], size!,widget.product.image![0],widget.product.profitAmount!);
                            }else{
                              showToast('This product already exist in your cart');
                            }
                          },
                          borderRadius: 5.0,
                          height: size.width * .12,
                          width: size.width * .4,
                          gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        bottom: getProportionateScreenWidth(context,15),
                        top: getProportionateScreenWidth(context,15),
                      ),
                      child: GradientButton(
                          child: Text(
                            'Buy Now',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if(exist==false){
                              setState(() {
                                exist=true;
                              });
                              String? size=_size==null?'No Size':_size;
                              productController.addToCart(
                                  widget.product.title!, widget.product.id!,
                                  widget.product.price!, 1, widget.product.colors![indx],
                                  size!,widget.product.image![0],widget.product.profitAmount!).then((value){
                                Get.to(()=>CartPage());
                              });
                            }else{
                              Get.to(()=>CartPage());
                            }
                          },
                          borderRadius: 5.0,
                          height: size.width * .12,
                          width: size.width * .4,
                          gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
