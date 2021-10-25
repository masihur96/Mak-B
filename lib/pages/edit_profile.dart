import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:mak_b/controller/auth_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/widgets/gradient_button.dart';
import 'package:mak_b/widgets/notification_widget.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  int count=0;
  final UserController userController=Get.find<UserController>();
  final AuthController authController=Get.find<AuthController>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _nbp = TextEditingController();
  final TextEditingController _zip = TextEditingController();

  void _initialize(){
    _name.text=userController.user.name??'';
    _email.text=userController.user.email??'';
    _phone.text=userController.user.phone??'';
    _address.text=userController.user.address??'';
    _nbp.text=userController.user.nbp??'';
    _zip.text=userController.user.zip??'';
    setState(() => count++);
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if(count==0){
      _initialize();
    }
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Update Profile',style: TextStyle(color: Colors.black)),
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
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
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
                            controller: _name,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Name",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _address,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Address",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                          ),
                        ),
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
                            controller: _email,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email address",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[100]!))
                          ),
                          child: TextField(
                            controller: _nbp,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nid/BirthCertificate/Passport",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[100]!))
                          ),
                          child: TextField(
                            controller: _zip,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Zip",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: GradientButton(
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if(_name.text.isNotEmpty&& _address.text.isNotEmpty&&
                              _phone.text.isNotEmpty&&_nbp.text.isNotEmpty){
                            authController.updateProfile(_name.text, _address.text, _phone.text, _nbp.text, _email.text, _zip.text);
                          }else{
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
