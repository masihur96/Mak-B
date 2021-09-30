import 'package:flutter/material.dart';

InputDecoration formDecoration(Size size) => InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: '',
      enabled: true,
      hintStyle: TextStyle(
        fontSize: size.width * .04,
        color: Colors.grey,
        fontFamily: 'mulish',
        //fontWeight: FontWeight.bold
      ),
      border: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.57)),
          borderSide: BorderSide.none),
      enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.57)),
          borderSide: BorderSide.none),
      disabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.57)),
          borderSide: BorderSide.none),
      focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.57)),
          borderSide: BorderSide.none),
      errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.57)),
          borderSide: BorderSide.none),
    );

InputDecoration textFieldFormDecoration(Size size) => InputDecoration(

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xFF19B52B)),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xFF19B52B)),
            borderRadius: BorderRadius.circular(10),
          ),


    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
    isDense: true,
    border: new OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: new BorderSide(color: Colors.grey)),

    hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: size.width * .05,
        fontWeight: FontWeight.w500),);
