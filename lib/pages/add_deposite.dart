import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:mak_b/controller/auth_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/widgets/form_decoration.dart';
import 'package:mak_b/widgets/gradient_button.dart';
import 'package:mak_b/widgets/notification_widget.dart';

class AddDeposit extends StatefulWidget {
  @override
  _AddDepositState createState() => _AddDepositState();
}

enum SingingCharacter { Account, Manually }

class _AddDepositState extends State<AddDeposit> {
  SingingCharacter? _character = SingingCharacter.Account;
  var amountController = TextEditingController();
  var passwordController = TextEditingController();
  bool _isVisible = false;

  @override
  void initState() {
    _character = SingingCharacter.Account;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Deposit",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Card(
                color: Colors.green.shade50,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(color:Color(0xFF19B52B), width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                shadowColor: Colors.grey,
                elevation: 5,
                child: Container(
                  height: size.width * .5,
                  width: size.width * .8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'A/C: ${userController.userModel.value.name ?? ''}',
                        style: TextStyle(
                            color: Color(0xFF19B52B),
                            fontSize: size.width * .05),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Deposit Balance : ${userController.userModel.value.depositBalance ?? ''}',
                          style: TextStyle(
                              color: Color(0xFF19B52B),
                              fontSize: size.width * .05),
                        ),
                      ),
                      Text(
                        'Available Balance To Deposit: ${userController.userModel.value.mainBalance ?? ''}',
                        style: TextStyle(
                            color: Colors.black, fontSize: size.width * .04),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 4,
                shadowColor: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Deposit From',
                            style: TextStyle(
                                color: Color(0xFF19B52B),
                                fontSize: size.width * .05),
                          ),
                        )),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text('From Wallet'),
                            leading: Radio<SingingCharacter>(
                              value: SingingCharacter.Account,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Manually'),
                            leading: Radio<SingingCharacter>(
                              value: SingingCharacter.Manually,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _character == SingingCharacter.Account,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                    color: Colors.green.shade100, width: 2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: size.width * .02,
                                              top: size.width * .03,
                                              bottom: size.width * .02),
                                          child: Text(
                                            'A/C Name: ${userController.userModel.value.name ?? ''}',
                                            style: TextStyle(
                                                color: Color(0xFF19B52B),
                                                fontSize: size.width * .05,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        )),
                                    TextField(
                                      controller: amountController,
                                      decoration: textFieldFormDecoration(size)
                                          .copyWith(
                                        suffixText: 'TK',
                                        suffixStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: size.width * .04),
                                        labelText: 'Amount',
                                        hintText: 'Write Amount',
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: size.width * .04),
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.width * .03,
                                    ),
                                    TextField(
                                      obscureText: _isVisible,
                                      controller: passwordController,
                                      decoration: textFieldFormDecoration(size)
                                          .copyWith(
                                              labelText: 'Password',
                                              hintText: '********',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: size.width * .04),
                                              suffixIcon: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _isVisible = !_isVisible;
                                                    });
                                                  },
                                                  child: Icon(_isVisible == true
                                                      ? Icons.visibility
                                                      : Icons.visibility_off))),
                                    ),
                                    SizedBox(
                                      height: size.width * .02,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.width * .05,
                            ),
                            GradientButton(
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(fontSize: size.width * .03),
                                ),
                                onPressed: () {
                                  if (amountController.text != '' &&
                                      passwordController.text != '') {
                                    dynamic balance = int.parse(userController
                                            .userModel.value.mainBalance!) -
                                        int.parse(amountController.text);
                                    if (balance < 0) {
                                      showToast(
                                          'Not enough balance to deposit!');
                                    } else {
                                      if (passwordController.text ==
                                          userController
                                              .userModel.value.password) {
                                        dynamic depositBalance = int.parse(
                                                userController.userModel.value
                                                    .depositBalance!) +
                                            int.parse(amountController.text);
                                        dynamic mainBalance = int.parse(
                                                userController.userModel.value
                                                    .mainBalance!) -
                                            int.parse(amountController.text);

                                        userController
                                            .depositBalance(
                                                amountController.text,
                                                depositBalance,
                                                mainBalance,
                                                userController
                                                    .userModel.value.name!,
                                                userController
                                                    .userModel.value.phone!)
                                            .then((value) {
                                          amountController.clear();
                                          passwordController.clear();
                                        });
                                      } else {
                                        showToast('Wrong Password!');
                                      }
                                    }
                                  } else {
                                    showToast('Fill up the required fields');
                                  }
                                },
                                borderRadius: 10,
                                height: size.width * .1,
                                width: size.width * .5,
                                gradientColors: [
                                  Color(0xFF0198DD),
                                  Color(0xFF19B52B)
                                ]),
                            SizedBox(
                              height: size.width * .05,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _character == SingingCharacter.Manually,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              color: Colors.green.shade100, width: 1),
                        ),
                        height: size.width * .5,
                        width: size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(left: size.width * .02),
                                child: Text(
                                  'To Deposit Amount',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.width * .045),
                                ),
                              ),
                              SizedBox(height: 5),
                              GradientButton(
                                  child: Text(
                                    'Sent Request',
                                    style:
                                        TextStyle(fontSize: size.width * .04),
                                  ),
                                  onPressed: () async {
                                    await userController
                                        .depositRequest(
                                            userController
                                                .userModel.value.name!,
                                            userController
                                                .userModel.value.phone!)
                                        .then((value) {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              scrollable: true,
                                              contentPadding:
                                                  EdgeInsets.all(20),
                                              title: Column(
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .030,
                                                  ),
                                                  Text(
                                                    'Your deposit request has been sent to admin.\nAdmin will contact you soon.',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: kPrimaryColor),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .050,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: Text(
                                                          "Ok",
                                                          style: TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    });
                                  },
                                  borderRadius: 10,
                                  height: size.width * .1,
                                  width: size.width * .35,
                                  gradientColors: [
                                    Color(0xFF0198DD),
                                    Color(0xFF19B52B)
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
