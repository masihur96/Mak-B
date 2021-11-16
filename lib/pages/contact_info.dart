import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactInfo extends StatefulWidget {
  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
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
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('MakB',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),),
            ),
          ],
        ),
      ),
    );
  }
}
