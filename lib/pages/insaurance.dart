import 'package:flutter/material.dart';

class Insaurance extends StatefulWidget {
  const Insaurance({Key? key}) : super(key: key);

  @override
  _InsauranceState createState() => _InsauranceState();
}

class _InsauranceState extends State<Insaurance> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Insaurance',
          style: TextStyle(color: Colors.black, fontSize: size.width * .04),
        ),
      ),
      body: _bodyUI(size),
    );
  }

  Widget _bodyUI(Size size) {
    return ListView(
      children: [
        Container(
            width: size.width * .4,
            height: size.width * .4,
            child: Image.asset('assets/images/life_insaurance.png')),
        Text(
          'Life Insaurance',
          style: TextStyle(
              color: Colors.black,
              fontSize: size.width * .06,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
