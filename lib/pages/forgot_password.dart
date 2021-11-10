import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mak_b/pages/recover_password.dart';
import 'package:mak_b/variables/size_config.dart';
import 'package:mak_b/widgets/gradient_button.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import 'login_page.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(context,20)),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.04),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(context,28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter your Phone Number and we will send \nyou an otp to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _codeController = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: phone,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Phone Number",
              hintText: "Enter your Phone Number",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: size.height * 0.1),
          GradientButton(
              child: Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  showLoadingDialog(Get.context!);
                  FirebaseAuth _auth = FirebaseAuth.instance;
                  _auth.verifyPhoneNumber(
                      phoneNumber: '+88'+phone.text,
                      timeout: Duration(seconds: 60),
                      verificationFailed: (FirebaseAuthException exception){
                        print(exception);
                      },
                      codeSent: (String verificationId, [int? forceResendingToken]){
                        closeLoadingDialog(Get.context!);
                        showOtp(verificationId);
                      },
                      codeAutoRetrievalTimeout: (String verificationId)async{
                        //_verificationId=verificationId;
                        Get.back();
                        //showOtp(name,address,phone,password,nbp,verificationId);
                        //showToast('OTP resent');
                      }, verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {

                  }
                  );
                }
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => LoginPage()));
              },
              borderRadius: 5.0,
              height: size.width * .12,
              width: size.width * .9,
              gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
          SizedBox(height: size.height * 0.1),
        ],
      ),
    );
  }

  void showOtp(String verificationId){
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
                          String id = phone.text;

                        }finally{
                          //loading(false);
                          Get.to(RecoverPassword(phone: phone.text,));
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
