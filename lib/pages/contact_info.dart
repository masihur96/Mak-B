import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfo extends StatefulWidget {
  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  final UserController userController=Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        toolbarHeight: size.height*.08,
        title: Text('Contact Info',style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Email:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
                  Text('${userController.infoList[0].email}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),

                  Text('Phone No:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
                  Text('${userController.infoList[0].phone}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),

                  Text('Address: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
                  Text('${userController.infoList[0].address}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),

                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: (){
                          print('d');
                          String url='${userController.infoList[0].fbLink}';
                          _launchURL(url);
                         },
                          child: Icon(FontAwesomeIcons.facebook)),
                      InkWell(
                          onTap: (){
                            _launchURL('${userController.infoList[0].instagram}');
                          },
                          child: Icon(FontAwesomeIcons.instagram)),
                      InkWell(
                          onTap: (){
                            _launchURL('${userController.infoList[0].linkedIn}');
                          },
                          child: Icon(FontAwesomeIcons.linkedin)),
                      InkWell(
                          onTap: (){
                            _launchURL('${userController.infoList[0].twitterLink}');
                          },
                          child: Icon(FontAwesomeIcons.twitter)),
                      InkWell(
                          onTap: (){
                            _launchURL('${userController.infoList[0].youtubeLink}');
                          },
                          child: Icon(FontAwesomeIcons.youtube)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
