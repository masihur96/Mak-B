import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mak_b/pages/login_page.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_nav.dart';

class AuthController extends GetxController{
  final _codeController = TextEditingController();
  Rx<String> id=''.obs;
  String? _verificationId;
  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
      id = (preferences.get('id') as String?)! as Rx<String>;
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
  Future<void> createUser(String name,String address,String phone,String password,String nbp) async {
    showLoadingDialog(Get.context!);
    bool isReg= await isRegistered(phone);
    if(!isReg){
     create(name,address,phone,password,nbp);
    }else{
      Get.back();
      showToast('Phone Number already exist');
    }

     //loading(true);
  }

  Future<void> create(String name,String address,String phone,String password,String nbp) async{
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: '+88'+phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async{
          // Navigator.of(context).pop();
          Get.back();

          UserCredential result = await _auth.signInWithCredential(credential);

          User? user = result.user;

          if(user != null){
            try{
              String id = phone.trim();
              await FirebaseFirestore.instance.collection('Users').doc(id).set({
                'id': id,
                "name": name,
                "address": address,
                "phone":phone,
                "password":password,
                "nbp":nbp
              });
            }finally{
              Get.back();
              showToast('Registration Succeed');
              //loading(false);
              Get.offAll(HomeNav());
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
          Get.back();
          showOtp(name, address, phone, password, nbp, verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId)async{
          _verificationId=verificationId;
          Get.back();
          //showOtp(name,address,phone,password,nbp,verificationId);
          //showToast('OTP resent');
        }
    );
  }

  void showOtp(String name,String address,String phone,String password,String nbp,String verificationId){
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
                          String id = phone.trim();
                          await FirebaseFirestore.instance.collection('Users').doc(id).set({
                            'id': id,
                            "name": name,
                            "address": address,
                            "phone":phone,
                            "password":password,
                            "nbp":nbp
                          });
                        }finally{
                          //_loading(false);
                          showToast('Registration Succeed');
                          //loading(false);
                          Get.offAll(HomeNav());
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

}