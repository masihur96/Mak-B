import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCEMITransactionInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCShipmentInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/General.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mak_b/bottom_navigation_bar/cart_page.dart';
import 'package:get/get.dart';
import 'package:mak_b/controller/product_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/models/package_model.dart';
import 'package:mak_b/models/product_model.dart';
import 'package:mak_b/pages/login_page.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/variables/size_config.dart';
import 'package:mak_b/widgets/gradient_button.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../package_payment_page.dart';
import '../../payment_page.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatefulWidget {
  final PackageModel product;
  final bool sold;

  const Body({required this.product,required this.sold});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final ProductController productController=Get.find<ProductController>();
  final UserController userController=Get.find<UserController>();
  List selectedColor=[];
  List selectedSize=[];
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
                    ],
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(context,20)),
                    child: Row(
                      children: [
                        Text('Discount: '),
                        Text(
                          "${widget.product.discountAmount}%",
                          style: TextStyle(
                            fontSize: size.width*.036,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(context,20)),
                    child: Row(
                      children: [
                        Text('Quantity: '),
                        Text(
                          "${widget.product.quantity}",
                          style: TextStyle(
                            fontSize: size.width*.036,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(context,20)),
                    child: Row(
                      children: [
                        Text('Size:  '),
                        Container(
                          width: size.width*.7,
                          height: size.height*.04,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.product.size!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: (){
                                  // if(selectedSize.contains(index)){
                                  //   setState(() {
                                  //     selectedSize.remove(index);
                                  //   });
                                  //
                                  // }else {
                                  //   setState(() {
                                  //     selectedSize.add(index);
                                  //   });
                                  // }
                                },
                                child: Row(
                                  children: [
                                    Text(widget.product.size![index]),
                                    SizedBox(width: 5,)
                                  ],
                                ),
                              );

                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(context,20)),
                    child: Row(
                      children: [
                        Text('Color: '),
                        Container(
                          width: size.width*.7,
                          height: size.height*.04,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount:widget.product.colors!.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return InkWell(
                                    // onTap: (){
                                    //
                                    //   if(selectedColor.contains(index)){
                                    //     setState(() {
                                    //       selectedColor.remove(index);
                                    //     });
                                    //
                                    //   }else {
                                    //     setState(() {
                                    //       selectedColor.add(index);
                                    //     });
                                    //
                                    //
                                    //   }
                                    //
                                    // },
                                    child:
                                    // selectedColor.contains(index)? Icon(Icons.circle_outlined,color: Colors.pink,)
                                    //     :
                                    Icon(Icons.circle_outlined,color: Color(int.parse(widget.product.colors![index]))));
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  widget.sold==false?Container():Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          padding:  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(context,20)),
                          child: Text(widget.product.status!,style: TextStyle(color: kPrimaryColor),)),
                    ],
                  ),
                  SizedBox(height: 5),


                ],
              ),
              TopRoundedContainer(
                color: Colors.white,
                child: widget.sold==false?Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: getProportionateScreenWidth(context,15),
                        top: getProportionateScreenWidth(context,10),
                      ),
                      child: GradientButton(
                          child: Text(
                            'Add to MyStore',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            id == null
                                ? Get.to(() => LoginPage()):userController.addStoreProduct(widget.product.id!, widget.product.title!, widget.product.price!, widget.product.image!, widget.product.colors!,
                                widget.product.size!, widget.product.description!,widget.product.thumbNail!, widget.product.discountAmount!, widget.product.quantity!);
                           // _paySSLCommerz(userController);
                          },
                          borderRadius: 5.0,
                          height: size.width * .12,
                          width: size.width * .4,
                          gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
                    ),
                  ],
                ):widget.product.status=='stored'?Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: getProportionateScreenWidth(context,15),
                        top: getProportionateScreenWidth(context,10),
                      ),
                      child: GradientButton(
                          child: Text(
                            'Collect Package',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Get.to(() => PackagePaymentPage(widget.product.documentId,widget.product.id,widget.product.title!, widget.product.price!,widget.product.discountAmount,widget.product.quantity,
                                widget.product.size!,widget.product.colors!,widget.product.image!,widget.product.thumbNail));
                          },
                          borderRadius: 5.0,
                          height: size.width * .12,
                          width: size.width * .4,
                          gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
                    ),
                  ],
                ):Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _paySSLCommerz(UserController userController) async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          //Use the ipn if you have valid one, or it will fail the transaction.
          //ipn_url: "www.ipnurl.com",
            multi_card_name: '',
            currency: SSLCurrencyType.BDT,
            product_category: "Product",
            sdkType: SSLCSdkType.LIVE,
            store_id: "demotest",
            store_passwd: "qwerty",
            total_amount: 100.0,
            tran_id: DateTime.now().millisecondsSinceEpoch.toString()));
    sslcommerz
        .addEMITransactionInitializer(
        sslcemiTransactionInitializer: SSLCEMITransactionInitializer(
            emi_options: 1, emi_max_list_options: 3, emi_selected_inst: 2))
        .addShipmentInfoInitializer(
        sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
            shipmentMethod: "yes",
            numOfItems: 5,
            shipmentDetails: ShipmentDetails(
                shipAddress1: 'Gazipur, Dhaka',
                shipCity: 'Dhaka',
                shipCountry: "Bangladesh",
                shipName: "From hub",
                shipPostCode: '1700')))
        .addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerState: "Uttara",
            customerName: "Mak bro",
            customerEmail: "makbro@gmail.com",
            customerAddress1: "Uttara",
            customerCity: "Dhaka",
            customerPostCode: '1230',
            customerCountry: "Bangladesh",
            customerPhone: "01610000016"))
        .addProductInitializer(
        sslcProductInitializer:
        // ***** ssl product initializer for general product STARTS*****
        SSLCProductInitializer(
            productName: "T-Shirt",
            productCategory: "All",
            general: General(
                general: "General Purpose",
                productProfile: "Product Profile")));
    var result = await sslcommerz.payNow();
    if (result is PlatformException) {
      print("the response is: " +
          result.message.toString() +
          " code: " +
          result.code);
    } else {
      SSLCTransactionInfoModel model = result;
      //print('Payment Status: ${model.status}');
      //showSuccessMgs('"Transaction Status: ${model.status}"');
      if (model.status == 'VALID') {
        userController.addStoreProduct(widget.product.id!, widget.product.title!, widget.product.price!, widget.product.image!, widget.product.colors!,
            widget.product.size!, widget.product.description!,widget.product.thumbNail!, widget.product.discountAmount!, widget.product.quantity!);

      } else {
        print(model.status);
      }
    }
  }
}
