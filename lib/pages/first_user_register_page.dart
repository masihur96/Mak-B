import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mak_b/controller/auth_controller.dart';
import 'package:mak_b/controller/product_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/pages/payment_page.dart';
import 'package:mak_b/variables/size_config.dart';
import 'package:mak_b/widgets/gradient_button.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstUserRegisterPage extends StatefulWidget {
  @override
  _FirstUserRegisterPageState createState() => _FirstUserRegisterPageState();
}

class _FirstUserRegisterPageState extends State<FirstUserRegisterPage> {
  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  final ProductController productController = Get.find<ProductController>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _nbp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register As a First User\n Good luck for your business!', style: TextStyle(color: Colors.black)),
        toolbarHeight: AppBar().preferredSize.height,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              //padding: EdgeInsets.all(getProportionateScreenWidth(context,5)),
              height: getProportionateScreenWidth(context, 120),
              width: getProportionateScreenWidth(context, 120),
              decoration: BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
              ),
              child: Image.asset("assets/icons/logo.PNG"),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(18, 142, 104, .2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10))
                        ]),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(color: Colors.grey[100]!))),
                          child: TextField(
                            controller: _name,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Name",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _address,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Address",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(color: Colors.grey[100]!))),
                          child: TextField(
                            controller: _phone,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone number",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _password,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(color: Colors.grey[100]!))),
                          child: TextField(
                            controller: _nbp,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nid/BirthCertificate/Passport",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GradientButton(
                        child: Text(
                          'Continue',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          showLoadingDialog(Get.context!);
                          var newString = _phone.text.substring(_phone.text.length - 6);
                          final String monthYear = DateFormat('MMyy')
                              .format(DateTime(DateTime.now().month, DateTime.now().year));
                          String myReferCode = 'MakB$monthYear$newString';
                          int insuranceEndingYear = DateTime.now().year + 5;
                          String demoInsuranceEndingDate =
                              '$insuranceEndingYear-${DateTime.now().month}-${DateTime.now().day}';
                          DateTime insuranceEndingDate =
                          DateFormat("yyyy-MM-dd").parse(demoInsuranceEndingDate);
                          String insuranceEndingDateInTimeStamp =
                          insuranceEndingDate.millisecondsSinceEpoch.toString();
                          if (_name.text.isNotEmpty &&
                              _address.text.isNotEmpty &&
                              _phone.text.isNotEmpty &&
                              _password.text.isNotEmpty &&
                              _nbp.text.isNotEmpty) {
                            authController.createFirstUser(_name.text, _address.text, _phone.text,
                                _password.text, _nbp.text,myReferCode, insuranceEndingDateInTimeStamp, '0');
                          } else {
                            Get.back();
                            showToast('Complete all required fields');
                          }
                        },
                        borderRadius: 5.0,
                        height: size.width * .12,
                        width: size.width * .9,
                        gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

