import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mak_b/widgets/form_decoration.dart';
import 'package:mak_b/widgets/gradient_button.dart';
class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String districsValue = 'Dhaka';
  String hubValue = 'HUB-1';
  var districs =  ['Dhaka','Barisal','Chittagong','Khulna','Mymensingh','Rajshahi','Rangpur','Sylhet'];
  var hubs =  ['HUB-1','HUB-2','HUB-3','HUB-4','HUB-5','HUB-6','HUB-7','HUB-8'];

  var tempList =[];
  TextEditingController _nameTextFieldController = TextEditingController();
  TextEditingController _addressFieldController = TextEditingController();
  TextEditingController _phoneFieldController = TextEditingController();
  TextEditingController _desscriptionFieldController = TextEditingController();

  var _key = GlobalKey<FormState>();
  dynamic formData = {};
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Text('Payment'),
        )
      ),
      body: Container(
        height: size.height,
        child: ListView(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Shipping to',
                        style: TextStyle(
                            fontFamily: 'taviraj',
                            color: Color(0xFF19B52B),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            fontSize: size.width * .04)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Card(
                    elevation: 5,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mak-B',
                                  style: TextStyle(

                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: size.width * .04)),

                              Text('10/B , Bashundara City ,Dhaka 1000',
                                  style: TextStyle(

                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                      fontSize: size.width * .04)),
                              Text('(+880) 1310000000',
                                  style: TextStyle(

                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: size.width * .04)),
                              Text('Description: I need this product urgently.',
                                  style: TextStyle(

                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: size.width * .04)),
                            ],
                          ),
                          InkWell(onTap: () {
                            _displayTextInputDialog(context,size);

                          }, child: Icon(Icons.edit_outlined,color: Color(0xFF19B52B),)),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0,top: 15,bottom: 10),
                    child: Text('Select Hub',
                        style: TextStyle(
                            fontFamily: 'taviraj',
                            color: Color(0xFF19B52B),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            fontSize: size.width * .04)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 8),
                  child: Card(
                    shadowColor: Colors.grey,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                      child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('Division: ' ,  style: TextStyle(

                        color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: size.width * .04)),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value: districsValue,
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        items:districs.map((String items) {
                                          return DropdownMenuItem(
                                              value: items,
                                              child: Text(items)
                                          );
                                        }
                                        ).toList(),

                                        onChanged: (newValue){
                                          setState(() {
                                            districsValue = newValue.toString();
                                          });
                                        },


                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Text('HUB: ',   style: TextStyle(
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontSize: size.width * .04)),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value: hubValue,
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        items:hubs.map((String items) {
                                          return DropdownMenuItem(
                                              value: items,
                                              child: Text(items)
                                          );
                                        }
                                        ).toList(),

                                        onChanged: (newValue){
                                          setState(() {
                                            hubValue = newValue.toString();
                                          });
                                        },


                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0,top: 15,bottom: 10),
                    child: Text('Total Amount',
                        style: TextStyle(
                            fontFamily: 'taviraj',
                            color: Color(0xFF19B52B),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            fontSize: size.width * .04)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 8),
                  child: Card(
                      shadowColor: Colors.grey,
                    elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 10, top: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Product',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontSize: size.width * .04)),
                                Row(
                                  children: [

                                    Text('20',
                                        style: TextStyle(

                                            color: Colors.black,
                                            fontStyle: FontStyle.normal,
                                            fontSize: size.width * .04)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Per Product',
                                    style: TextStyle(

                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontSize: size.width * .04)),
                                Row(
                                  children: [
                                    Icon(Icons.attach_money_outlined),
                                    Text('79.95',
                                        style: TextStyle(

                                            color: Colors.black,
                                            fontStyle: FontStyle.normal,
                                            fontSize: size.width * .04)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Color(0xFF19B52B),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total',
                                    style: TextStyle(

                                        color: Color(0xFF19B52B),
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        fontSize: size.width * .04)),
                                Row(
                                  children: [
                                    Icon(Icons.attach_money_outlined,   color: Color(0xFF19B52B),),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('99.95',
                                          style: TextStyle(

                                              color: Color(0xFF19B52B),
                                              fontStyle: FontStyle.normal,
                                              fontSize: size.width * .045)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.width * .1,),
                  child: GradientButton(child: Text('Payment'), onPressed: (){},
                      borderRadius: 10, height: size.width*.1, width: size.width*.5, gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)])
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _displayTextInputDialog(BuildContext context,Size size) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Data',style: TextStyle(color: Color(0xFF19B52B)),),
            content: Container(
              height: size.width*.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _nameTextFieldController,
                    decoration: textFieldFormDecoration(size).copyWith(
                      labelText: 'Name',
                      hintText: 'Mak-B',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: TextField(
                      controller: _addressFieldController,
                      decoration: textFieldFormDecoration(size).copyWith(
                        labelText: 'Address',
                        hintText: 'House-16, Sonargaon, Dhaka',
                      ),
                    ),
                  ),
                  TextField(

                    controller: _phoneFieldController,
                    decoration: textFieldFormDecoration(size).copyWith(

                      labelText: 'Phone',
                      hintText: '0147582369',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: TextField(
                      controller: _desscriptionFieldController,
                      decoration: textFieldFormDecoration(size).copyWith(
                        labelText: 'Description',
                        hintText: 'I Need this Product Urgently',
                      ),
                    ),
                  ),
                  GradientButton(child: Text('Update'), onPressed: (){}, borderRadius: 10, height: size.width*.1, width: size.width*.3, gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)])

                ],
              ),
            ),
          );
        });
  }

}





