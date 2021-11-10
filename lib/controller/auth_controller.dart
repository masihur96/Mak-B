import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/pages/login_page.dart';
import 'package:mak_b/pages/payment_page.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_nav.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthController extends GetxController {
  final _codeController = TextEditingController();
  String? id;
  String? _verificationId;

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.get('id') as String?;
  }

  @override // called when you use Get.put before running app
  void onInit() {
    super.onInit();
    _checkPreferences();
  }

  var _loading=false.obs;
  //FirebaseAuth _auth = FirebaseAuth.instance;
  // Rxn<User?> _firebaseUser = Rxn<User>();
  // String get user => _firebaseUser.value!.phoneNumber!;
  // @override
  // void onInit() {
  //   _firebaseUser.bindStream(_auth.authStateChanges());
  // }
  //
  Future<bool> isRegistered(String phone) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('phone', isEqualTo: phone)
        .get();
    final List<QueryDocumentSnapshot> user = snapshot.docs;
    if (user.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> createUser(
      String name,
      String address,
      String phone,
      String password,
      String nbp,
      String referCode,
      String profitAmount,
      String myReferCode) async {
    try {
      int insuranceEndingYear = DateTime.now().year + 5;
      String demoInsuranceEndingDate =
          '$insuranceEndingYear-${DateTime.now().month}-${DateTime.now().day}';
      DateTime insuranceEndingDate =
          DateFormat("yyyy-MM-dd").parse(demoInsuranceEndingDate);
      String insuranceEndingDateInTimeStamp =
          insuranceEndingDate.millisecondsSinceEpoch.toString();

      //showLoadingDialog(Get.context!);
      create(name, address, phone, password, nbp, myReferCode, referCode,
          insuranceEndingDateInTimeStamp, profitAmount);
    } catch (error) {
      print("create User error: $error");
    }
    //loading(true);
  }

  Future<void> create(
      String name,
      String address,
      String phone,
      String password,
      String nbp,
      String myReferCode,
      String referCode,
      String insuranceEndingDate,
      String profitAmount) async {
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: '+88' + phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          // Navigator.of(context).pop();
          //Get.back();

          UserCredential result = await _auth.signInWithCredential(credential);

          User? user = result.user;

          if (user != null) {
            try {
              String userId = phone.trim();
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(userId)
                  .set({
                'id': userId,
                "name": name,
                "address": address,
                "phone": phone,
                "password": password,
                "nbp": nbp,
                "email": '',
                "zip": '',
                "referCode": myReferCode,
                "timeStamp": date,
                "referDate": date,
                "imageUrl": '',
                "numberOfReferred": '0',
                "insuranceEndingDate": insuranceEndingDate,
                "depositBalance": '0',
                "insuranceBalance": '0',
                "lastInsurancePaymentDate": date,
                "level": '0',
                "insuranceWithDraw": false,
                "mainBalance": profitAmount,
                "videoWatched": '0',
                "watchDate": '',
                "myStore": '',
                "myOrder": '',
                "referLimit": '100',
              });
            } catch (error) {
              print("Create user failed: $error");
            } finally {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setString('id', phone);
              Get.back();
              Get.offAll(()=>HomeNav());
              showToast('Order Placed');
              showToast('Registration Succeed');
            }
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done automatically
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          _verificationId = verificationId;
          //Get.back();
          showOtp(name, address, phone, password, nbp, myReferCode, referCode,
              insuranceEndingDate, verificationId, profitAmount);
        },
        codeAutoRetrievalTimeout: (String verificationId) async {
          _verificationId = verificationId;
          Get.back();
          //showOtp(name,address,phone,password,nbp,verificationId,profitAmount);
          //showToast('OTP resent');
        });
    // /// for testing app OTP system is "commented", after app building it will be commented out
    // String date = DateTime.now().millisecondsSinceEpoch.toString();
    // String userId = phone.trim();
    // try {
    //   await FirebaseFirestore.instance.collection('Users').doc(userId).set({
    //     'id': userId,
    //     "name": name,
    //     "address": address,
    //     "phone": phone,
    //     "password": password,
    //     "nbp": nbp,
    //     "email": '',
    //     "zip": '',
    //     "referCode": myReferCode,
    //     "timeStamp": date,
    //     "referDate": date,
    //     "imageUrl": '',
    //     "numberOfReferred": '0',
    //     "insuranceEndingDate": insuranceEndingDate,
    //     "depositBalance": '0',
    //     "insuranceBalance": '0',
    //     "lastInsurancePaymentDate": date,
    //     "level": '0',
    //     "insuranceWithDraw":false,
    //     "mainBalance": profitAmount,
    //     "videoWatched": '0',
    //     "watchDate": '',
    //     "myStore": '',
    //     "myOrder": '',
    //     "referLimit": '100',
    //   });
    // } catch (error) {
    //   print("Create user failed: $error");
    // } finally {
    //   //Get.back();
    //   SharedPreferences pref = await SharedPreferences.getInstance();
    //   pref.setString('id', phone);
    //   showToast('Registration Succeed');
    //   // Get.offAll(PaymentPage(referCode, name, phone));
    // }
  }

  /// for the first user who does not have refer code
  Future<void> createFirstUser(
      String name,
      String address,
      String phone,
      String password,
      String nbp,
      String myReferCode,
      String insuranceEndingDate,
      String profitAmount) async {
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: '+88' + phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          // Navigator.of(context).pop();
          //Get.back();

          UserCredential result = await _auth.signInWithCredential(credential);

          User? user = result.user;

          if (user != null) {
            try {
              String userId = phone.trim();
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(userId)
                  .set({
                'id': userId,
                "name": name,
                "address": address,
                "phone": phone,
                "password": password,
                "nbp": nbp,
                "email": '',
                "zip": '',
                "referCode": myReferCode,
                "timeStamp": date,
                "referDate": date,
                "imageUrl": '',
                "numberOfReferred": '0',
                "insuranceEndingDate": insuranceEndingDate,
                "depositBalance": '0',
                "insuranceBalance": '0',
                "lastInsurancePaymentDate": date,
                "level": '0',
                "insuranceWithDraw": false,
                "mainBalance": '0',
                "videoWatched": '0',
                "watchDate": '',
                "myStore": '',
                "myOrder": '',
                "referLimit": '100',
              });
            } catch (error) {
              print("Create user failed: $error");
            } finally {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setString('id', phone);
              await updateFirstUserCount();
              Get.back();
              Get.offAll(()=>HomeNav());
              showToast('Registration Succeed');
            }
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done automatically
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          _verificationId = verificationId;
          //Get.back();
          showOtp(name, address, phone, password, nbp, myReferCode, '',
              insuranceEndingDate, verificationId, '0');
        },
        codeAutoRetrievalTimeout: (String verificationId) async {
          _verificationId = verificationId;
          Get.back();
          //showOtp(name,address,phone,password,nbp,verificationId,profitAmount);
          //showToast('OTP resent');
        });
  }

  void showOtp(
      String name,
      String address,
      String phone,
      String password,
      String nbp,
      String myReferCode,
      String referCode,
      String insuranceEndingDate,
      String verificationId,
      String profitAmount) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter setState){
              return AlertDialog(
                scrollable: true,
                contentPadding: EdgeInsets.all(20),
                title: Text("Phone Verification", textAlign: TextAlign.center),
                content: Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        child: Text(
                          "We've sent OTP verification code on your given number.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      SizedBox(height: 25),
                      TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Enter OTP here",
                            fillColor: Colors.grey[100],
                            prefixIcon: Icon(Icons.security)),
                      ),
                      SizedBox(height: 10),
                      _loading.isTrue?Center(child: CircularProgressIndicator()):TextButton(
                        child: Text("Confirm"),
                        style: TextButton.styleFrom(
                            primary: Colors.white, backgroundColor: Colors.blue),
                        onPressed: () async {
                          _loading(true);
                          final code = _codeController.text.trim();
                          AuthCredential credential = PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: code);

                          UserCredential result =
                          await _auth.signInWithCredential(credential);

                          User? user = result.user;

                          if (user != null) {
                            try {
                              String date =
                              DateTime.now().millisecondsSinceEpoch.toString();
                              String userId = phone.trim();
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(userId)
                                  .set({
                                'id': userId,
                                "name": name,
                                "address": address,
                                "phone": phone,
                                "password": password,
                                "nbp": nbp,
                                "email": '',
                                "zip": '',
                                "referCode": myReferCode,
                                "timeStamp": date,
                                "referDate": date,
                                "imageUrl": '',
                                "numberOfReferred": '0',
                                "insuranceEndingDate": insuranceEndingDate,
                                "depositBalance": '0',
                                "insuranceBalance": '0',
                                "lastInsurancePaymentDate": date,
                                "level": '0',
                                "insuranceWithDraw": false,
                                "mainBalance": profitAmount,
                                "videoWatched": '0',
                                "watchDate": '',
                                "myStore": '',
                                "myOrder": '',
                                "referLimit": '100',
                              });
                            } finally {
                              _loading(false);
                              _codeController.clear();
                              SharedPreferences pref =
                              await SharedPreferences.getInstance();
                              pref.setString('id', phone);
                              await updateFirstUserCount();
                              Get.back();
                              Get.offAll(()=>HomeNav());
                              showToast('Order Placed');
                              showToast('Registration Succeed');
                            }
                          } else {
                            print("Error");
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      Text('OTP will expired after 1 minute ',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]))
                    ],
                  ),
                ),
              );
            }
          );
        });
  }

  Future<void> updateFirstUserCount()async {
    await FirebaseFirestore.instance.collection('CheckFirstUser').doc('12345').update({
      "count": '1',
    });
  }
}
