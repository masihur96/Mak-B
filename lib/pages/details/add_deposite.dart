import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/widgets/form_decoration.dart';
import 'package:mak_b/widgets/gradient_button.dart';
class AddDeposit extends StatefulWidget {
  @override
  _AddDepositState createState() => _AddDepositState();
}
enum SingingCharacter { Account, Manually }
class _AddDepositState extends State<AddDeposit> {
  SingingCharacter? _character = SingingCharacter.Account;
   var amountController = TextEditingController();
   var passwordController = TextEditingController();

  @override
  void initState() {
    _character = SingingCharacter.Account;
    amountController.text = 5000.toString();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Deposit",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Card(
                color: Colors.green.shade50,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color:Color(0xFF19B52B), width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                shadowColor: Colors.grey,
                elevation: 5,
                child: Container(
                  height: size.width*.5,
                  width: size.width*.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('A/C: Mak-B2021',style: TextStyle(color: Color(0xFF19B52B),fontSize: size.width*.05),),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Current Balance ; 50,000',style: TextStyle(color: Color(0xFF19B52B),fontSize: size.width*.05),),
                      ),
                      Text('Available Balance  To Deposit; 45,000',style: TextStyle(color: Colors.black,fontSize: size.width*.04),),
                  ],),
                ),
              ),

              SizedBox(height: 10,),
              Card(
                elevation: 4,
                shadowColor: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Deposit From',style: TextStyle(color: Color(0xFF19B52B),fontSize: size.width*.05),),
                        )),

                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text('From A/C Balance'),
                            leading: Radio<SingingCharacter>(
                              value: SingingCharacter.Account,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                          ),
                        ),

                        Expanded(
                          child: ListTile(
                            title: const Text('Manually'),
                            leading: Radio<SingingCharacter>(
                              value: SingingCharacter.Manually,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                });


                              },
                              activeColor: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Visibility(
                      visible: _character ==SingingCharacter.Account,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Colors.green.shade100,width: 2),

                              ),

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [

                                    Align(
                                      alignment: Alignment.center,
                                        child: Padding(
                                          padding:  EdgeInsets.only(left: size.width*.02,top:size.width*.03,bottom:size.width*.02  ),
                                          child: Text('A/C Name: Makb2021',style: TextStyle(color: Color(0xFF19B52B),fontSize: size.width*.05,fontWeight: FontWeight.normal),),
                                        )),


                                    TextField(

                                      controller: passwordController,
                                      decoration: textFieldFormDecoration(size).copyWith(
                                        suffixText: 'TK',suffixStyle: TextStyle(color: Colors.black,fontSize: size.width*.04),
                                        labelText: 'Amount',
                                        hintText: '500000',
                                      ),
                                    ),
                                    SizedBox(height: size.width*.03,),
                                    TextField(

                                      controller: passwordController,
                                      decoration: textFieldFormDecoration(size).copyWith(

                                        labelText: 'Password',
                                        hintText: '********',
                                      ),
                                    ),
                                    SizedBox(height: size.width*.02,),

                                ],),
                              ),
                            ),
                            SizedBox(height: size.width*.05,),
                            GradientButton(

                                child:Text('Confirm',style: TextStyle(fontSize: size.width*.03),),

                                onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>AddDeposit()));},
                                borderRadius: 10,
                                height: size.width*.1,
                                width: size.width*.5,
                                gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
                            SizedBox(height: size.width*.05,),
                          ],
                        ),
                      ),
                    ),

                    Visibility(
                      visible: _character ==SingingCharacter.Manually,
                      child: Container(

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.green.shade100,width: 1),

                        ),


                        height: size.width*.5,
                        width: size.width,

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Padding(
                                padding:  EdgeInsets.only(left: size.width*.02),
                                child: Text('To Deposit Amount',style: TextStyle(color: Colors.black,fontSize: size.width*.045),),
                              ),

                              Padding(
                                padding:  EdgeInsets.only(left: size.width*.02),
                                child: Text('Mak-B : 014458697',style: TextStyle(color: Colors.black,fontSize: size.width*.045),),
                              ),
                            ],),
                        ),
                      ),
                    ),


                  ],),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
