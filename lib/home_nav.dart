import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:mak_b/bottom_navigation_bar/account_nav.dart';
import 'package:mak_b/bottom_navigation_bar/cart_page.dart';
import 'package:mak_b/bottom_navigation_bar/package_list.dart';
import 'package:mak_b/bottom_navigation_bar/product_page.dart';
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
  final AuthController authController=Get.put(AuthController());
  final UserController userController=Get.put(UserController());
  final ProductController productController=Get.put(ProductController());

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
      //pass = preferences.get('pass');
    });
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

  Future<void> updateUserDetails()async {
    // to convert from "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" to 'MM/dd/yyyy hh:mm a'
    //
    // date = '2021-01-26T03:17:00.000000Z';
    // DateTime parseDate =
    // new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    // var inputDate = DateTime.parse(parseDate.toString());
    // var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
    // var outputDate = outputFormat.format(inputDate);
    // print(outputDate)

    setState(() {
      _counter++;
    });
    await userController.getUser(id!);
    await userController.getWithDrawHistory(id!);
    await userController.getDepositHistory(id!);
    await FirebaseFirestore.instance.collection('Users').where('id',isEqualTo: id).get().then((querySnapshots)async{
      querySnapshots.docChanges.forEach((document) {
        if(watchDt!=document.doc['watchDate']){
          FirebaseFirestore.instance.collection('Users').doc(id).update({
            "watchDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
          });
        }
        setState(() {
          currentReferDate = DateTime.parse('${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}');

          lastReferDate = DateTime.parse(document.doc['referDate']);
        });
        var days = currentReferDate!.difference(lastReferDate!).inDays;

        if(days>180){
          var date = new DateTime.fromMicrosecondsSinceEpoch(document.doc['timeStamp'] * 1000);
          int referLimit = int.parse(document.doc['referLimit'])+100;
          print(date.month);
          int newMonth=date.month+6;
          if(newMonth>12){
            setState(() {
              newReferYear=date.year+1;
              newReferMonth=newMonth-12;
            });
          }
          var newYear = '$newReferYear'.substring('$newReferYear'.length - 2);
          var newString = document.doc['phone'].substring(document.doc['phone'].length - 6);
          FirebaseFirestore.instance.collection('Users').doc(id).update({
            // 'id': id,
            // "name": name,
            // "address": address,
            // "phone":phone,
            // "password":password,
            // "nbp":nbp,
            // "email": '',
            // "zip": '',
            "referCode": 'MakB$newReferMonth$newYear$newString',
            "timeStamp": DateTime.now().millisecondsSinceEpoch,
            "referDate": '$newReferYear-$newReferMonth-${date.day}',
            "imageUrl": '',
            "referredList": '',
            "numberOfReferred": '0',
            //"insuranceEndingDate": insuranceEndingDate,
            "depositBalance": '0',
            "depositHistory": '',
            "withdrawHistory": '',
            "insuranceBalance": '0',
            "lastInsurancePayment": '',
            "level": '0',
            "mainBalance": '0',
            "videoWatched": '0',
            "watchDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
            "myStore": '',
            "myOrder": '',
            "cartList": '',
            "referLimit": '$referLimit',
          });
        }else{
          print(document.doc['referDate']);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if(_counter==0){
      productController.getArea();
      productController.getProducts();
      productController.getCart();
      productController.getAreaHub(productController.areaList[0].id);
      if(id!=null){
        updateUserDetails();
      }
    }
    return Scaffold(
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
    );
  }
}
