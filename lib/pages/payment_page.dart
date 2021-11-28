import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_sslcommerz/model/SSLCAdditionalInitializer.dart';
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
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:mak_b/controller/auth_controller.dart';
import 'package:mak_b/controller/product_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/models/area_hub_model.dart';
import 'package:mak_b/widgets/form_decoration.dart';
import 'package:mak_b/widgets/gradient_button.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_nav.dart';
import 'order_list_page.dart';

class PaymentPage extends StatefulWidget {
  String? referenceCode;
  //String? referMobileNo;
  String? customerName;
  String? customerPhone;
  String? address;
  String? password;
  String? nbp;
  String? myReferCode;
  //String? insuranceEndingDate;


  PaymentPage(this.referenceCode, this.customerName,this.customerPhone,this.address,
      this.password,this.nbp,this.myReferCode);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final ProductController productController=Get.find<ProductController>();
  final AuthController authController=Get.find<AuthController>();
  final UserController userController=Get.find<UserController>();
  dynamic userProfitAmount;
  dynamic referUserProfitAmount;
  dynamic referBalance;
  int count=0;
  String? referredBy;
  String? districtsValue;
  String? hubValue;
  List<AreaHubModel> _list=[];
  List<AreaHubModel> _hubList=[];
  List cartItemList = [];
  bool _isLoading=false;

  var tempList =[];
  TextEditingController _nameTextFieldController = TextEditingController();
  TextEditingController _addressFieldController = TextEditingController();
  TextEditingController _phoneFieldController = TextEditingController();
  TextEditingController _descriptionFieldController = TextEditingController();

  var _key = GlobalKey<FormState>();
  dynamic formData = {};
  void getData() {
    for (int i = 0; i < productController.cartList.length; i++) {
      cartItemList.add({
        "productId": productController.cartList[i].productId,
        "productName": productController.cartList[i].productName,
        "quantity": productController.cartList[i].quantity,
        "productImage": productController.cartList[i].productImage,
        "price": productController.cartList[i].price,
        "color": productController.cartList[i].color,
        "size": productController.cartList[i].size,
        "profitAmount": productController.cartList[i].profitAmount
      });
    }
    print(cartItemList[0]['productName']);
  }
  void getUserData() {
    for (int i = 0; i < userController.cartList.length; i++) {
      cartItemList.add({
        "productId": userController.cartList[i].productId,
        "productName": userController.cartList[i].productName,
        "quantity": userController.cartList[i].quantity,
        "productImage": userController.cartList[i].productImage,
        "price": userController.cartList[i].price,
        "color": userController.cartList[i].color,
        "size": userController.cartList[i].size,
        "profitAmount": userController.cartList[i].profitAmount
      });
    }
    print(cartItemList[0]['productName']);
  }
  String? id;
  @override
  void initState() {
    super.initState();
    _checkPreferences();
  }
  Future <void> _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.get('id') as String?;
      //pass = preferences.get('pass');
    });
  }
  Future<void> operate()async{
    districtsValue = productController.areaList[0].id;
    hubValue=productController.areaHubList[0].hub[0];
    _list=productController.areaList;
    _hubList=productController.areaHubList;
    await _checkPreferences();
    // String profit;
    // id==null?profit='${productController.totalProfitAmount}':profit='${userController.totalProfitAmount}';
    setState(() {
      count++;
      referredBy=widget.referenceCode==''?'None':widget.referenceCode;
      id==null?userProfitAmount=int.parse('${productController.totalProfitAmount}') *.3:userProfitAmount=int.parse('${userController.totalProfitAmount}') *.3;
    });
    print(id);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(id);
    if(count==0){
      operate();
    }
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            title: Text('Payment',style: TextStyle(color: Colors.black)),
          )
      ),
      body: Container(
        height: size.height,
        child: ListView(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Buying details',
                        style: TextStyle(
                            fontFamily: 'taviraj',
                            color: Color(0xFF19B52B),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            fontSize: size.width * .04)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Card(
                    elevation: 5,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.customerName!,
                                  style: TextStyle(

                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: size.width * .04)),
                              SizedBox(height: 5),
                              Text(widget.customerPhone!,
                                  style: TextStyle(

                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: size.width * .04)),
                              SizedBox(height: 5,),
                              Text('Referred By:  $referredBy',
                                  style: TextStyle(

                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                      fontSize: size.width * .04)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Card(
                    elevation: 5,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              id==null?Text('Total Items: ${productController.cartList.length}',
                                  style: TextStyle(

                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: size.width * .04)):
                              Text('Total Items: ${userController.cartList.length}',
                                  style: TextStyle(

                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: size.width * .04)),
                              SizedBox(height: 5,),
                              Text('My Profit:  $userProfitAmount\৳',
                                  style: TextStyle(

                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: size.width * .04)),
                              SizedBox(height: 5,),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0,top: 15,bottom: 10),
                    child: Text('Select Hub',
                        style: TextStyle(
                            fontFamily: 'taviraj',
                            color: Color(0xFF19B52B),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            fontSize: size.width * .04)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 8),
                  child: Card(
                    shadowColor: Colors.grey,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('Division: ' ,  style: TextStyle(

                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: size.width * .04)),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: districtsValue,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      items:_list.map((items) {
                                        return DropdownMenuItem(
                                            value: items.id,
                                            child: Text(items.id!)
                                        );
                                      }).toList(),

                                      onChanged: (newValue)async{
                                        setState(() {
                                          _isLoading=true;
                                        });
                                        await productController.getAreaHub(newValue.toString());
                                        setState(() {
                                          districtsValue = newValue.toString();
                                          _hubList=productController.areaHubList;
                                          hubValue=productController.areaHubList[0].hub[0];
                                          _isLoading=false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              _isLoading
                                  ?CircularProgressIndicator()
                                  :Row(
                                children: [
                                  Text('HUB: ',   style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: size.width * .04)),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: hubValue,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      items:_hubList[0].hub!.map((items) {
                                        return DropdownMenuItem(
                                            value: items,
                                            child: Text(items)
                                        );
                                      }
                                      ).toList(),

                                      onChanged: (newValue){
                                        setState(() {
                                          hubValue = newValue.toString();
                                        });
                                      },


                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0,top: 15,bottom: 10),
                    child: Text('Total Amount',
                        style: TextStyle(
                            fontFamily: 'taviraj',
                            color: Color(0xFF19B52B),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            fontSize: size.width * .04)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 8),
                  child: Card(
                      shadowColor: Colors.grey,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                      child: Column(
                        children: [
                          // Padding(
                          //   padding:
                          //   const EdgeInsets.only(left: 10, top: 10, right: 10),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text('Total Product',
                          //           style: TextStyle(
                          //               color: Colors.black,
                          //               fontStyle: FontStyle.normal,
                          //               fontSize: size.width * .04)),
                          //       Row(
                          //         children: [
                          //
                          //           Text('20',
                          //               style: TextStyle(
                          //
                          //                   color: Colors.black,
                          //                   fontStyle: FontStyle.normal,
                          //                   fontSize: size.width * .04)),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   //child:
                          //   // Row(
                          //   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   //   children: [
                          //   //     Text('Per Product',
                          //   //         style: TextStyle(
                          //   //
                          //   //             color: Colors.black,
                          //   //             fontStyle: FontStyle.normal,
                          //   //             fontSize: size.width * .04)),
                          //   //     Row(
                          //   //       children: [
                          //   //         Icon(Icons.attach_money_outlined),
                          //   //         Text('79.95',
                          //   //             style: TextStyle(
                          //   //
                          //   //                 color: Colors.black,
                          //   //                 fontStyle: FontStyle.normal,
                          //   //                 fontSize: size.width * .04)),
                          //   //       ],
                          //   //     ),
                          //   //   ],
                          //   // ),
                          // ),
                          // Divider(
                          //   height: 1,
                          //   color: Color(0xFF19B52B),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total',
                                    style: TextStyle(

                                        color: Color(0xFF19B52B),
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        fontSize: size.width * .04)),
                                id==null?Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${productController.total}\৳',
                                      style: TextStyle(

                                          color: Color(0xFF19B52B),
                                          fontStyle: FontStyle.normal,
                                          fontSize: size.width * .045)),
                                ):Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${userController.total}\৳',
                                      style: TextStyle(

                                          color: Color(0xFF19B52B),
                                          fontStyle: FontStyle.normal,
                                          fontSize: size.width * .045)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                GradientButton(child: Text('Payment'),
                    onPressed: ()async{
                  String unique='${DateTime.now().millisecondsSinceEpoch}';
                  if(id==null){
                    showLoadingDialog(Get.context!);
                    String profit1='${productController.totalProfitAmount}';
                    setState(() {
                      referUserProfitAmount=int.parse(profit1) *.2;
                      referBalance=double.parse(userController.referUserModel.value.mainBalance!)+referUserProfitAmount;
                    });
                    getData();
                    productController.createOrder(widget.customerName!, widget.customerPhone!,
                        unique, districtsValue!, hubValue!, '${productController.cartList.length}',
                        '${productController.total}', cartItemList,userController).then((value){
                      authController.createUser(widget.customerName!, widget.address!, widget.customerPhone!,
                          widget.password!, widget.nbp!, widget.referenceCode!, '$userProfitAmount',widget.myReferCode!).then((value){
                        userController.updateReferUser(userController.referUserModel.value.phone!, '$referBalance').then((value){
                          userController.addReferUserReferList(userController.referUserModel.value.phone!,widget.myReferCode!,
                           widget.customerName!,'$referUserProfitAmount',widget.customerPhone!);
                        });
                      });
                    });
                  }else{
                    showLoadingDialog(Get.context!);
                    getUserData();
                    productController.createOrder(widget.customerName!, widget.customerPhone!,
                        unique, districtsValue!, hubValue!, '${productController.cartList.length}',
                        '${productController.total}', cartItemList,userController).then((value)async{
                       await   userController.updateBalance('$userProfitAmount').then((value){
                            Get.back();
                            Get.back();
                            Get.to(()=>HomeNav());
                            showToast('Order Placed');
                          });
                    });
                  }

                  //_paySSLCommerz();
                },
                    borderRadius: 10, height: size.width*.1, width: size.width*.5, gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),


              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _displayTextInputDialog(BuildContext context,Size size) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Data',style: TextStyle(color: Color(0xFF19B52B)),),
            content: Container(
              height: size.width*.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _nameTextFieldController,
                    decoration: textFieldFormDecoration(size).copyWith(
                      labelText: 'Name',
                      hintText: 'Mak-B',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: TextField(
                      controller: _addressFieldController,
                      decoration: textFieldFormDecoration(size).copyWith(
                        labelText: 'Address',
                        hintText: 'House-16, Sonargaon, Dhaka',
                      ),
                    ),
                  ),
                  TextField(

                    controller: _phoneFieldController,
                    decoration: textFieldFormDecoration(size).copyWith(

                      labelText: 'Phone',
                      hintText: '0147582369',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: TextField(
                      controller: _descriptionFieldController,
                      decoration: textFieldFormDecoration(size).copyWith(
                        labelText: 'Description',
                        hintText: 'I Need this Product Urgently',
                      ),
                    ),
                  ),
                  GradientButton(child: Text('Update'), onPressed: (){}, borderRadius: 10, height: size.width*.1, width: size.width*.3, gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)])

                ],
              ),
            ),
          );
        });
  }

  Future<void> _paySSLCommerz() async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          //Use the ipn if you have valid one, or it will fail the transaction.
          //ipn_url: "www.ipnurl.com",
            multi_card_name: '',
            currency: SSLCurrencyType.BDT,
            product_category: "Food",
            sdkType: SSLCSdkType.LIVE,
            store_id: "demotest",
            store_passwd: "qwerty",
            total_amount: double.parse('${productController.total}'),
            tran_id: DateTime.now().millisecondsSinceEpoch.toString()));
    sslcommerz
        .addEMITransactionInitializer(
        sslcemiTransactionInitializer: SSLCEMITransactionInitializer(
            emi_options: 1, emi_max_list_options: 3, emi_selected_inst: 2))
        .addShipmentInfoInitializer(
        sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
            shipmentMethod: "yes",
            numOfItems: productController.cartList.length,
            shipmentDetails: ShipmentDetails(
                shipAddress1: hubValue!,
                shipCity: districtsValue!,
                shipCountry: "Bangladesh",
                shipName: "From hub",
                shipPostCode: '')))
        .addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerState: "Uttara",
            customerName: "Mak bro",
            customerEmail: "makbro@gmail.com",
            customerAddress1: "Uttara",
            customerCity: "Dhaka",
            customerPostCode:'1230',
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
                productProfile: "Product Profile")))
        .addAdditionalInitializer(
        sslcAdditionalInitializer:
        SSLCAdditionalInitializer(valueA: "SSL_VERIFYPEER_FALSE"));
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
        if(id==null){

        }else{

        }
      } else {
        showToast('Transaction failed');
      }
    }
  }

}





