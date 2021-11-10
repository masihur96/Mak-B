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

class AuthController extends GetxController{
  final UserController userController=Get.find<UserController>();
  final _codeController = TextEditingController();
  String? id;
  String? _verificationId;
  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
      id = preferences.get('id') as String? ;
  }
  @override // called when you use Get.put before running app
  void onInit() {
    super.onInit();
    _checkPreferences();
  }


  //var loading=false.obs;
  //FirebaseAuth _auth = FirebaseAuth.instance;
  // Rxn<User?> _firebaseUser = Rxn<User>();
  // String get user => _firebaseUser.value!.phoneNumber!;
  // @override
  // void onInit() {
  //   _firebaseUser.bindStream(_auth.authStateChanges());
  // }
  //
  Future<bool> isRegistered(String phone)async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Users')
        .where('phone', isEqualTo: phone).get();
    final List<QueryDocumentSnapshot> user = snapshot.docs;
    if(user.isEmpty){
      return false;
    }else{
      return true;
    }
  }
  Future<void> createUser(String name,String address,String phone,String password,String nbp,String referCode) async {
    int year =DateTime.now().year+5;
    String insuranceEndingDate='$year-${DateTime.now().month}-${DateTime.now().day}';
    var newString = phone.substring(phone.length - 6);
    final String monthYear =DateFormat('MM-yy').format(DateTime(DateTime.now().month,DateTime.now().year));
    String myReferCode='MakB$monthYear$newString';
    showLoadingDialog(Get.context!);
    bool isReg= await isRegistered(phone);
    if(!isReg){
     create(name,address,phone,password,nbp,referCode,myReferCode,insuranceEndingDate);
    }else{
      Get.back();
      showToast('Phone Number already exist');
    }

     //loading(true);
  }

  Future<void> create(String name,String address,String phone,String password,String nbp,String myReferCode,String referCode,String insuranceEndingDate) async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: '+88'+phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async{
          // Navigator.of(context).pop();
          //Get.back();

          UserCredential result = await _auth.signInWithCredential(credential);

          User? user = result.user;

          if(user != null){
            try{
              // String id = phone.trim();
              // await FirebaseFirestore.instance.collection('Users').doc(id).set({
              //   'id': id,
              //   "name": name,
              //   "address": address,
              //   "phone":phone,
              //   "password":password,
              //   "nbp":nbp,
              //   "email": '',
              //   "zip": '',
              //   "referCode": myReferCode,
              //   "timeStamp": DateTime.now().millisecondsSinceEpoch,
              //   "referDate": '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
              //   "imageUrl": '',
              //   //"referredList": '',
              //   "numberOfReferred": '0',
              //   "insuranceEndingDate": insuranceEndingDate,
              //   "depositBalance": '0',
              //   //"depositHistory": '',
              //   //"withdrawHistory": '',
              //   "insuranceBalance": '0',
              //   "lastInsurancePaymentDate": '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
              //   "level": '0',
              //   "mainBalance": '0',
              //   "videoWatched": '0',
              //   "watchDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
              //   "myStore": '',
              //   "myOrder": '',
              //   //"cartList": '',
              //   "referLimit": '100',
              //
              // });
            }finally{
              Get.back();
              // SharedPreferences pref = await SharedPreferences.getInstance();
              // pref.setString('id', phone);
              // showToast('Registration Succeed');
              //loading(false);
              Get.offAll(PaymentPage(referCode, name,address,phone,password,
                  nbp,myReferCode,insuranceEndingDate));
            }
          }else{
            print("Error");
          }

          //This callback would gets called when verification is done automatically
        },
        verificationFailed: (FirebaseAuthException exception){
          print(exception);
        },
        codeSent: (String verificationId, [int? forceResendingToken]){
          _verificationId=verificationId;
          //Get.back();
          showOtp(name, address, phone, password, nbp,myReferCode,referCode,insuranceEndingDate, verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId)async{
          _verificationId=verificationId;
          Get.back();
          //showOtp(name,address,phone,password,nbp,verificationId);
          //showToast('OTP resent');
        }
    );
  }

  void showOtp(String name,String address,String phone,String password,String nbp,String myReferCode,String referCode,String insuranceEndingDate,String verificationId){
    FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
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
                  TextButton(
                    child: Text("Confirm"),
                    style: TextButton.styleFrom(
                    primary: Colors.white,
                      backgroundColor: Colors.blue
                    ),
                    onPressed: () async{
                      //_loading(true);
                      final code = _codeController.text.trim();
                      AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);

                      UserCredential result = await _auth.signInWithCredential(credential);

                      User? user = result.user;

                      if(user != null){
                        try{
                          // String id = phone.trim();
                          // await FirebaseFirestore.instance.collection('Users').doc(id).set({
                          //   'id': id,
                          //   "name": name,
                          //   "address": address,
                          //   "phone":phone,
                          //   "password":password,
                          //   "nbp":nbp,
                          //   "email": '',
                          //   "zip": '',
                          //   "referCode": myReferCode,
                          //   "timeStamp": DateTime.now().millisecondsSinceEpoch,
                          //   "referDate": '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                          //   "imageUrl": '',
                          //   //"referredList": '',
                          //   "numberOfReferred": '0',
                          //   "insuranceEndingDate": insuranceEndingDate,
                          //   "depositBalance": '0',
                          //   //"depositHistory": '',
                          //   //"withdrawHistory": '',
                          //   "insuranceBalance": '0',
                          //   "lastInsurancePaymentDate": '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                          //   "level": '0',
                          //   "mainBalance": '0',
                          //   "videoWatched": '0',
                          //   "watchDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          //   "myStore": '',
                          //   "myOrder": '',
                          //   //"cartList": '',
                          //   "referLimit": '100',
                          // });
                        }finally{
                          //_loading(false);
                          // SharedPreferences pref = await SharedPreferences.getInstance();
                          // pref.setString('id', phone);
                          // showToast('Registration Succeed');
                          //loading(false);
                          Get.offAll(PaymentPage(referCode, name,address,phone,password,
                              nbp,myReferCode,insuranceEndingDate));
                        }
                      }else{
                        print("Error");
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  Text('OTP will expired after 1 minute ',style: TextStyle(fontSize: 14,color: Colors.grey[600]))
                ],
              ),
            ),
          );
        }
    );
  }

  Future<void> updatePhoto(File imageFile)async {
    showLoadingDialog(Get.context!);
    try{
      firebase_storage.Reference storageReference =
      firebase_storage.FirebaseStorage.instance.ref().child('User Photo').child(id!);

      firebase_storage.UploadTask storageUploadTask = storageReference.putFile(imageFile);

      firebase_storage.TaskSnapshot taskSnapshot;
      storageUploadTask.then((value) {
        taskSnapshot = value;
        taskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl) {
          final photoUrl = newImageDownloadUrl;
          FirebaseFirestore.instance.collection('Users').doc(id).update({
            "imageUrl": photoUrl,
          });
        }).then((value)async{
          await userController.getUser(id!);
          Get.back();
          showToast('Photo Updated');
        });
      });
    }catch(e){
      Get.back();
      print(e.toString());
      showToast('Something went wrong');
    }
  }

  Future<void> updateProfile(String name,String address,String phone,String nbp,String email,String zip)async {
    showLoadingDialog(Get.context!);
    await FirebaseFirestore.instance.collection('Users').doc(id).update({
      "name": name,
      "address": address,
      "phone":phone,
      "nbp":nbp,
      "email": email,
      "zip": zip,
    }).then((value)async{
      await userController.getUser(id!);
      Get.back();
      Get.back();
      showToast('Profile Updated');
    });
  }

  Future<void> changePassword(String newPass)async {
    try{
      showLoadingDialog(Get.context!);
      await FirebaseFirestore.instance.collection('Users').doc(id).update({
        "password": newPass,
      }).then((value)async{
        await userController.getUser(id!);
        Get.back();
        Get.back();
        showToast('Password Changed');
      });
    }catch(e){
      print(e);
    }
  }

  Future<void> recoverPassword(String newPass,String phone)async {
    try{
      showLoadingDialog(Get.context!);
      await FirebaseFirestore.instance.collection('Users').doc(phone).update({
        "password": newPass,
      }).then((value){
        Get.back();
        Get.offAll(()=>LoginPage());
        showToast('Password Recovered');
      });
    }catch(e){
      print(e);
    }
  }

  Future<void> withdrawHistory(String amount,String name,dynamic due,String image)async {
   try{
     showLoadingDialog(Get.context!);
     await userController.getUser(id!);
     await FirebaseFirestore.instance.collection('Users').doc(id).collection('WithdrawHistory').doc('${DateTime.now().millisecondsSinceEpoch}').set({
       "id": '$id',
       "date":'${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
       "phone":id,
       "name":name,
       "imageUrl":image,
       "amount":amount,
       "status":'pending'
     }).then((value)async{
       await FirebaseFirestore.instance.collection('WithdrawRequests').doc('${DateTime.now().millisecondsSinceEpoch}').set({
         "id": '$id',
         "phone":id,
         "name":name,
         "imageUrl":image,
         "date":'${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
         "amount":amount,
         "status":'pending'
       }).then((value)async{
         await FirebaseFirestore.instance.collection('Users').doc(id).update({
           "lastInsurancePaymentDate":'${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
           "insuranceBalance":int.parse(userController.user.insuranceBalance!)+due,
         }).then((value)async{
         await userController.getWithDrawHistory(id!);
         Get.back();
         showToast('Request Sent  for withdraw');
       });
     });
     });
   }catch(e){
     print(e.toString());
   }
  }

  Future<void> depositBalance(String amount,dynamic depositBalance,dynamic mainBalance,String name,String phone)async {
    try{
      showLoadingDialog(Get.context!);
      await FirebaseFirestore.instance.collection('Users').doc(id).collection('DepositHistory').doc('${DateTime.now().millisecondsSinceEpoch}').set({
        "id": DateTime.now().millisecondsSinceEpoch,
        "name": name,
        "phone":phone,
        "date":'${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
        "amount":amount,
        "status":"transferred"
      }).then((value)async{
        await FirebaseFirestore.instance.collection('Users').doc(id).update({
          "depositBalance":'$depositBalance',
          "mainBalance":'$mainBalance'
        }).then((value)async{
          await userController.getDepositHistory(id!);
          Get.back();
          showToast('Balance deposited');
        });
      });
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> depositRequest(String name,String phone)async {
    try{
      showLoadingDialog(Get.context!);
      await FirebaseFirestore.instance.collection('Users').doc(id).collection('DepositHistory').doc('${DateTime.now().millisecondsSinceEpoch}').set({
        "id": DateTime.now().millisecondsSinceEpoch,
        "name": name,
        "phone":phone,
        "date":'${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
        "amount":'',
        "status":'pending'
      }).then((value)async{
          await userController.getDepositHistory(id!);
          Get.back();
          //showToast('Balance deposited');
        });
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> register(String name,String address,String phone,String password,
      String nbp,String myReferCode,String insuranceEndingDate,String mainBalance)async {
    await FirebaseFirestore.instance.collection('Users').doc(id).set({
      'id': id,
      "name": name,
      "address": address,
      "phone":phone,
      "password":password,
      "nbp":nbp,
      "email": '',
      "zip": '',
      "referCode": myReferCode,
      "timeStamp": DateTime.now().millisecondsSinceEpoch,
      "referDate": '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
      "imageUrl": '',
      //"referredList": '',
      "numberOfReferred": '0',
      "insuranceEndingDate": insuranceEndingDate,
      "depositBalance": '0',
      //"depositHistory": '',
      //"withdrawHistory": '',
      "insuranceBalance": '0',
      "lastInsurancePaymentDate": '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
      "level": '0',
      "mainBalance": mainBalance,
      "videoWatched": '0',
      "watchDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "myStore": '',
      "myOrder": '',
      //"cartList": '',
      "referLimit": '100',
    });
  }

  Future<void> updateReferUser(String phone,String profit)async {
    await FirebaseFirestore.instance.collection('Users').doc(phone).update({
      "mainBalance": profit,
    });
  }

  Future<void> addReferUserReferList(String referPhone,String referCode,String name,String profit,String userPhone)async{
    await FirebaseFirestore.instance.collection('Users').doc(referPhone).collection('referredList').
    doc('${DateTime.now().millisecondsSinceEpoch}').set({
      "id": referPhone,
      "date":'${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      "phone":userPhone,
      "name":name,
      "referCode":referCode,
      "profit":profit
    });
  }
}