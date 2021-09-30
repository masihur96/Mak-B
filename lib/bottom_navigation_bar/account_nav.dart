import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mak_b/pages/deposite_page.dart';
import 'package:mak_b/pages/insaurance.dart';
import 'package:mak_b/pages/my_store_page.dart';
import 'package:mak_b/pages/refferred_people.dart';
import 'package:mak_b/pages/withdrow_page.dart';

class AccountNav extends StatefulWidget {
  const AccountNav({Key? key}) : super(key: key);

  @override
  _AccountNavState createState() => _AccountNavState();
}

class _AccountNavState extends State<AccountNav> {
  double _animatedContainerHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setState(() {
      _animatedContainerHeight = size.width * .26;
    });
    return SafeArea(child: Scaffold(body: _bodyUI(size)));
  }

  Widget _bodyUI(Size size) {
    return Container(
      height: size.height,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: size.width,
                height: size.height * .3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0198DD), Color(0xFF19B52B)],
                  ),
                ),

              ),
              Positioned(
                bottom: -size.width * .4,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * .04)),
                  color: Colors.white,
                  child: Container(
                    width: size.width * .85,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.width * .06,
                        ),
                        CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            radius: size.width * .18,
                            backgroundImage: AssetImage(
                                'assets/images/profile_image_demo.png')),
                        SizedBox(
                          height: size.width * .04,
                        ),
                        Container(
                          width: size.width * .85,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              left: size.width * .04, right: size.width * .04),
                          child: Text(
                            'Afridi Mahafuz',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: size.width * .07),
                          ),
                        ),
                        SizedBox(
                          height: size.width * .04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: size.width * .15,
                                height: size.width * .15,
                                child: Image.asset(
                                    'assets/images/silver_badge.jpg')),
                            SizedBox(width: size.width * .04),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rank',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width * .04),
                                ),
                                Text(
                                  'Silver place',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w400,
                                      fontSize: size.width * .04),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.width * .04,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: size.width * .38),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * .04,
                right: size.width * .04,
                top: size.width * .04),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size.width * .04)),
              color: Colors.white,
              child: Container(
                width: size.width * .85,
                padding: EdgeInsets.all(size.width * .04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'USER INFO',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * .04,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: size.width * .04,
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.passport,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: size.width * .04,
                        ),
                        Text(
                          'XN0019390',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * .04,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.width * .03,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: size.width * .04,
                        ),
                        Text(
                          '01625940678',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * .04,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.width * .03,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: size.width * .04,
                        ),
                        Text(
                          'Block-C, Pallabi, Dhaka.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * .04,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: size.width * .02),
          Container(
            width: size.width * .85,
            padding: EdgeInsets.all(size.width * .04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Refer Code',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width * .05,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: size.width * .04,
                ),
                Text(
                  'MakB234F',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * .04,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.width * .02),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RefferredPeople()));
            },
            leading: Icon(Icons.people),
            title: Text(
              'Refferred People',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * .04,
                  fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
          Container(
            width: size.width,
            child: Divider(
              color: Colors.grey.shade300,
              thickness: size.width * .001,
            ),
          ),
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>MyStorePage()));
            },
            leading: Icon(Icons.store),
            title: Text(
              'My Store',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * .04,
                  fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
          Container(
            width: size.width,
            child: Divider(
              color: Colors.grey.shade300,
              thickness: size.width * .001,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Insaurance()));
            },
            leading: Icon(Icons.account_balance_wallet),
            title: Text(
              'Insaurance',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * .04,
                  fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
          Container(
            width: size.width,
            child: Divider(
              color: Colors.grey.shade300,
              thickness: size.width * .001,
            ),
          ),
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>DepositePage()));
            },
            leading: Icon(Icons.credit_card),
            title: Text(
              'Deposit',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * .04,
                  fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
          Container(
            width: size.width,
            child: Divider(
              color: Colors.grey.shade300,
              thickness: size.width * .001,
            ),
          ),
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>WithDrowPage()));
            },
            leading: Icon(Icons.monetization_on_outlined),
            title: Text(
              'Withdraw',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * .04,
                  fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
