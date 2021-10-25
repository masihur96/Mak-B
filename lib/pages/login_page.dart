import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mak_b/pages/register_page.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/variables/size_config.dart';
import 'package:mak_b/widgets/gradient_button.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import '../home_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isVisible=false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Log In',style: TextStyle(color: Colors.black)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            SizedBox(height: size.height*.05),
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(context,5)),
              height: getProportionateScreenWidth(context,100),
              width: getProportionateScreenWidth(context,100),
              decoration: BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
              ),
              child: Image.asset("assets/icons/logo.PNG"),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
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
                              offset: Offset(0, 10)
                          )
                        ]
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[100]!))
                          ),
                          child: TextField(
                            controller: _phone,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone number",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            obscureText: _isVisible,
                            controller: _password,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                suffixIcon: InkWell(
                                    onTap: (){
                                      setState(() {
                                        _isVisible =!_isVisible;
                                      });
                                    },
                                    child: Icon(_isVisible==false?Icons.visibility:Icons.visibility_off))
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Center(
                    child: GradientButton(
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async{
                          if(_phone.text.isNotEmpty&&_password.text.isNotEmpty){
                            showLoadingDialog(context);
                            QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Users')
                                .where('id', isEqualTo: _phone.text).get();
                            final List<QueryDocumentSnapshot> user = snapshot.docs;
                            if(user.isNotEmpty){
                              if(user[0].get('password')==_password.text){
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                pref.setString('id', _phone.text);
                                closeLoadingDialog(context);
                                showToast("Successfully logged in");
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                    HomeNav()), (Route<dynamic> route) => false);
                              }
                              else {
                                closeLoadingDialog(context);
                                showToast("Incorrect password");
                              }
                            }else{
                              closeLoadingDialog(context);
                              showToast("No User is registered with this phone");
                            }
                          }else {
                            showToast("Field can't be empty");
                          }
                        },
                        borderRadius: 5.0,
                        height: size.width * .12,
                        width: size.width * .9,
                        gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 9.0,right: 9.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            child: Text("Forgot Password?", style: TextStyle(color: kPrimaryColor)),
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()));
                            },
                            child: Text("Create New Account?", style: TextStyle(color: kPrimaryColor))),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

