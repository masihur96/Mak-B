import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mak_b/variables/constants.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Insurance',
          style: TextStyle(color: Colors.black, fontSize: size.width * .04),
        ),
      ),
      body: _bodyUI(size),
    );
  }

  Widget _bodyUI(Size size) {
    return ListView(
      children: [
        SizedBox(
          height: size.width * .04,
        ),
        Container(
            width: size.width * .4,
            height: size.width * .4,
            child: Image.asset('assets/images/life_insaurance.png')),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Life Insurance',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * .06,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: size.width * .1,
        ),
        Container(
          width: size.width,
          padding:
              EdgeInsets.only(left: size.width * .04, right: size.width * .04),
          child: LinearProgressIndicator(
            value: 0.1,
            minHeight: 10,
          ),
        ),
        SizedBox(
          height: size.width * .04,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '5 Years',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * .04,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(
          height: size.width * .1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            insuranceCard(size, Color(0xFF19B52B), 250, 'Balance'),
            insuranceCard(size, Color(0xFF0861AF), 250, 'Due'),
            insuranceCard(size, Color(0xFF0198DD), 4500, 'Remaining'),
          ],
        ),
        SizedBox(
          height: size.width * .1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'About Life Insurance',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * .05,
                  fontWeight: FontWeight.w500),
            ),
          ],
        )
      ],
    );
  }

  Widget insuranceCard(Size size, Color color, int amount, String title) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * .04),
      ),
      child: Container(
        width: size.width * .28,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size.width * .04),
        ),
        child: Column(
          children: [
            Text(
              amount.toString(),
              style: TextStyle(color: Colors.white, fontSize: size.width * .08),
            ),
            SizedBox(
              height: size.width * .02,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * .04,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        padding: EdgeInsets.all(size.width * .04),
      ),
      elevation: 4,
    );
  }
}
