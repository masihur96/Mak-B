import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mak_b/bottom_navigation_bar/account_nav.dart';
import 'package:mak_b/bottom_navigation_bar/cart_page.dart';
import 'package:mak_b/bottom_navigation_bar/package_list.dart';
import 'package:mak_b/bottom_navigation_bar/product_page.dart';
import 'package:mak_b/controller/advertisement_controller.dart';
import 'package:mak_b/pages/login_page.dart';
import 'package:intl/intl.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/auth_controller.dart';
import 'controller/product_controller.dart';
import 'controller/user_controller.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({Key? key}) : super(key: key);

  @override
  _HomeNavState createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> with TickerProviderStateMixin {

  DateTime? currentReferDate;
  DateTime? lastReferDate;
  int _counter=0;
  int? newReferYear;
  int? newReferMonth;
  String watchDt=DateFormat('yyyy-MM-dd').format(DateTime.now());

  TabController? _tabController;
  // String _pageTitle = '';

  String? id;
  String? _deviceId;
  String? deviceId;
  Future<void> initDeviceId() async {
    String deviceid;

    deviceid = (await PlatformDeviceId.getDeviceId)!;

    if (!mounted) return;

    setState(() {
      _deviceId = '$deviceid';
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('deviceId', _deviceId!);
  }

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.get('id') as String?;
      deviceId = preferences.get('deviceId') as String? ;
    });
    print(id);
  }

  @override
  void initState() {
    super.initState();
    initDeviceId();
    _checkPreferences();

    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  Future<void> updateUserDetails(UserController userController)async {
    // to convert from "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" to 'MM/dd/yyyy hh:mm a'
    //
    // date = '2021-01-26T03:17:00.000000Z';
    // DateTime parseDate =
    // new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    // var inputDate = DateTime.parse(parseDate.toString());
    // var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
    // var outputDate = outputFormat.format(inputDate);
    // print(outputDate)


      _counter++;
    await userController.getUser(id!);
    await userController.getUserCart();
    await userController.getWithDrawHistory(id!);
    await userController.getDepositHistory(id!);
    await userController.getReferUserReferList(id!);
    await userController.getWatchedHistory();
    await FirebaseFirestore.instance.collection('Users').where('id',isEqualTo: id).get().then((querySnapshots)async{
      querySnapshots.docChanges.forEach((document) {
        if(watchDt!=document.doc['watchDate']){
          FirebaseFirestore.instance.collection('Users').doc(id).update({
            "watchDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
            "videoWatched": '0',
          });
        }
        setState(() {
          currentReferDate = DateTime.parse('${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}');

          var date = new DateTime.fromMicrosecondsSinceEpoch(int.parse(document.doc['referDate']) * 1000);
          lastReferDate = DateTime.parse('${date.year}-${date.month}-${date.day}');
        });
        var days = currentReferDate!.difference(lastReferDate!).inDays;

        if(days>180){
          var date = new DateTime.fromMicrosecondsSinceEpoch(int.parse(document.doc['timeStamp']) * 1000);
          int referLimit = int.parse(document.doc['referLimit'])+100;
          print(date.month);
          int newMonth=date.month+6;
          if(newMonth>12){
            setState(() {
              newReferYear=date.year+1;
              newReferMonth=newMonth-12;
            });
          }else{
            setState(() {
              newReferYear=date.year;
            });
          }
          var newString = document.doc['phone'].substring(document.doc['phone'].length - 6);
          final String monthYear = DateFormat("MMyy").format(DateTime.parse("$newReferYear-$newReferMonth-${date.day}"));
          String myReferCode = 'MakB$monthYear$newString';
          //var newYear = '$newReferYear'.substring('$newReferYear'.length - 2);
          //var newString = document.doc['phone'].substring(document.doc['phone'].length - 6);
          FirebaseFirestore.instance.collection('Users').doc(id).update({
            // 'id': id,
            // "name": name,
            // "address": address,
            // "phone":phone,
            // "password":password,
            // "nbp":nbp,
            // "email": '',
            // "zip": '',
            "referCode": myReferCode,
            "timeStamp": DateTime.now().millisecondsSinceEpoch,
            "referDate": '$newReferYear-$newReferMonth-${date.day}',
            // "imageUrl": '',
            // "referredList": '',
            // //"numberOfReferred": '0',
            // //"insuranceEndingDate": insuranceEndingDate,
            // "depositBalance": '0',
            // "depositHistory": '',
            // "withdrawHistory": '',
            // //"insuranceBalance": '0',
            // "lastInsurancePayment": '',
            // "level": '0',
            // //"mainBalance": '0',
            // "videoWatched": '0',
            "watchDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
            // "myStore": '',
            // "myOrder": '',
            // "cartList": '',
            "referLimit": '$referLimit',
          });
        }else{
          print(document.doc['referDate']);
        }
      });
    });
  }
  Future<void> fetch(UserController userController,ProductController productController)async{
    await userController.getMyStore();
    await userController.getProductOrder();
    await userController.getRate();
    await userController.getContactInfo();
    await productController.getPackage();
  }
  Future<bool> _onBackPressed() async {
    _showDialog();
    return true;
  }
  @override
  Widget build(BuildContext context) {
    final UserController userController=Get.find<UserController>();
    final ProductController productController=Get.find<ProductController>();
    final Size size = MediaQuery.of(context).size;
    if(_counter==0){
      if(id!=null){
        updateUserDetails(userController);
      }
      fetch(userController,productController);
    }
    if(id!=null){
      userController.getUser(id!);
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.green[50],
        bottomNavigationBar: MotionTabBar(
          initialSelectedTab: 'Product',
          labels: const ["Product", "Package", "Cart", "Account"],
          icons: const [
            FontAwesomeIcons.tshirt,
            FontAwesomeIcons.boxOpen,
            FontAwesomeIcons.cartPlus,
            FontAwesomeIcons.userCircle
          ],
          tabSize: 50,
          tabBarHeight: AppBar().preferredSize.height,
          textStyle: TextStyle(
            fontSize: size.width * .04,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          tabIconColor: Colors.grey.shade500,
          tabIconSize: 24.0,
          tabIconSelectedSize: 24.0,
          tabSelectedColor: Color(0xFF19B52B).withOpacity(0.1),
          tabIconSelectedColor: kPrimaryColor,
          tabBarColor: Colors.white,
          onTabItemSelected: (int value) {
            setState(() {
              _tabController!.index = value;
              // value == 0
              //     ? _pageTitle = 'Product'
              //     : value == 1
              //         ? _pageTitle = 'Package'
              //         :value == 2?_pageTitle = 'Cart'
              //         : _pageTitle = 'Account';
            });
          },
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: <Widget>[
            ProductPage(),
            PackageListPage(),
            CartPage(),
            id == null?LoginPage():AccountNav()
          ],
        ),
      ),
    );

  }
  _showDialog() {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {

          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: Colors.white,
              scrollable: true,
              contentPadding: EdgeInsets.all(20),
              title: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .030,
                  ),
                  Text(
                    'Are you sure you want to exit?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .050,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: Text(
                          "No",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          SystemNavigator.pop();
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
