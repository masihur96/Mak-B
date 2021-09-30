import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mak_b/pages/details/add_deposite.dart';
import 'package:mak_b/pages/payment_page.dart';
import 'package:mak_b/widgets/gradient_button.dart';
class DepositePage extends StatefulWidget {
  @override
  _DepositePageState createState() => _DepositePageState();
}

class _DepositePageState extends State<DepositePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Deposite",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              Align(
                alignment: Alignment.center,
                child: Card(
                  color: Colors.green.shade50,
                  shape: RoundedRectangleBorder(
                    // side: BorderSide(color:Color(0xFF19B52B), width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 5,
                  shadowColor: Colors.grey,
                  child: Container(

                    height:size.width*.5,
                    width:size.width,
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Text('MAKb-2021',style: TextStyle(color: Color(0xFF19B52B),fontSize: size.width*.05),),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0,bottom: 15),
                          child: Text('Deposit Balance: 50000',style: TextStyle(color: Colors.black,fontSize: size.width*.04),),
                        ),
                        GradientButton(child: Text('Add Deposit',style: TextStyle(fontSize: size.width*.04),), onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>AddDeposit()));
                        }, borderRadius: 10, height:size.width*.1, width:size.width*.5,
                            gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),



                    ],),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Card(
                  elevation: 5,


                  shadowColor: Colors.grey,
                  child: Container(
                    color: Colors.white,

                    width:size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('History',style: TextStyle(color: Color(0xFF19B52B),fontSize: size.width*.05),),
                        ),

                        Divider(height: 1,color: Colors.green,),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: size.width * .02),
                                child: Card(
                                  elevation: 1,
                                  child: ListTile(
                                      leading:Text('29/09/2021'),
                                      title: Center(
                                        child: Text(
                                          'Manually',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: size.width * .04,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                  trailing: Text(
                                    '50000',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.width * .04,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  ),
                                ),
                              );
                            })

                      ],),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
