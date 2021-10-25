import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:mak_b/controller/auth_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/widgets/form_decoration.dart';
import 'package:mak_b/widgets/gradient_button.dart';
import 'package:mak_b/widgets/notification_widget.dart';

class WithDrawPage extends StatefulWidget {
  @override
  _WithDrawPageState createState() => _WithDrawPageState();
}
//enum SingingCharacter { Account, Manually,Bkash,Nagad,Others }
class _WithDrawPageState extends State<WithDrawPage> {
  final UserController userController=Get.find<UserController>();
  final AuthController authController=Get.find<AuthController>();
  // SingingCharacter? _character = SingingCharacter.Account;
  // SingingCharacter? _operator = SingingCharacter.Bkash;
  var amountController = TextEditingController(text: '');
  var mobileNoController = TextEditingController(text: '');
  var passwordController = TextEditingController(text: '');
  int counter=0;
  dynamic due;
  dynamic availableBalance;
  DateTime? currentDate;
  DateTime? lastInsuranceDate;
  var months;

  bool _isVisible=false;

  void count(){
    setState(() {
      counter++;
    });
    setState(() {
      currentDate = DateTime.parse('${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}');
      lastInsuranceDate = DateTime.parse(userController.user.lastInsurancePaymentDate!);
    });
    setState(() {
      months = currentDate!.difference(lastInsuranceDate!).inDays ~/ 30;
      due=months*250;
      availableBalance=int.parse(userController.user.mainBalance!)-due-50;
    });
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if(counter==0){
      count();
    }
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            title: Text('Withdraw'),
          )
      ),
      body: SafeArea(

        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [

                Card(
                  color: Colors.green.shade50,
                  shape: RoundedRectangleBorder(
                    // side: BorderSide(color:Color(0xFF19B52B), width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  shadowColor: Colors.grey,
                  elevation: 8,
                  child: Container(
                    width: size.width,
                    height: size.width*.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Current Balance: ${userController.user.mainBalance??''}',
                          style: TextStyle(
                              color: Color(0xFF19B52B),
                              fontSize: size.width * .05,
                              fontWeight: FontWeight.bold),),
                        Text('Insurance : $months* 250',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * .04,
                              fontWeight: FontWeight.bold),),
                        Text('Service Charge : 50',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * .04,
                              fontWeight: FontWeight.bold),),
                        Text('Available Balance : $availableBalance',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * .04,
                              fontWeight: FontWeight.bold),),

                      ],
                    ),
                  ),
                ),
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 8.0,top: 15),
                //     child: Text('WithDraw Mode',
                //       style: TextStyle(
                //           color: Color(0xFF19B52B),
                //           fontSize: size.width * .04,
                //           fontWeight: FontWeight.bold),),
                //   ),
                // ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: ListTile(
                //         title: const Text('From A/C Balance'),
                //         leading: Radio<SingingCharacter>(
                //           value: SingingCharacter.Account,
                //           groupValue: _character,
                //           onChanged: (SingingCharacter? value) {
                //             setState(() {
                //               _character = value;
                //             });
                //           },
                //           activeColor: Colors.green,
                //         ),
                //       ),
                //     ),
                //
                //     Expanded(
                //       child: ListTile(
                //         title: const Text('Manually'),
                //         leading: Radio<SingingCharacter>(
                //           value: SingingCharacter.Manually,
                //           groupValue: _character,
                //           onChanged: (SingingCharacter? value) {
                //             setState(() {
                //               _character = value;
                //             });
                //
                //
                //           },
                //           activeColor: Colors.green,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                Visibility(
                  //visible: _character ==SingingCharacter.Account,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
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
                                  child: Text('A/C Name: ${userController.user.name??''}',style: TextStyle(color: Color(0xFF19B52B),fontSize: size.width*.05,fontWeight: FontWeight.normal),),
                                )),

                            TextField(

                              controller: amountController,
                              decoration: textFieldFormDecoration(size).copyWith(

                                labelText: 'Amount',
                                hintText: 'Write Amount',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: size.width*.04),
                                suffixText:'TK' ,suffixStyle: TextStyle(color: Colors.black,fontSize: size.width*.04),
                              ),
                            ),

                            SizedBox(height: size.width*.05,),

                            TextField(
                              obscureText: _isVisible,

                              controller: passwordController,
                              decoration: textFieldFormDecoration(size).copyWith(

                                labelText: 'Password',
                                hintText: '*******',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: size.width*.04),
                                  suffixIcon: InkWell(
                                    onTap: (){
                                      setState(() {
                                        _isVisible = !_isVisible;
                                      });
                                    },
                                    child: Icon(_isVisible==false?Icons.visibility:Icons.visibility_off),
                                  )
                              ),
                            ),


                            SizedBox(height: size.width*.05,),

                          ],),
                      ),
                    ),
                  ),
                ),
                // Visibility(
                //   visible: _character ==SingingCharacter.Manually,
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Container(
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.all(Radius.circular(10)),
                //         border: Border.all(color: Colors.green.shade100,width: 2),
                //
                //       ),
                //
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Column(
                //           children: [
                //
                //             Align(
                //                 alignment: Alignment.center,
                //                 child: Padding(
                //                   padding:  EdgeInsets.only(left: size.width*.02,top:size.width*.03,bottom:size.width*.02  ),
                //                   child: Text('A/C Name: Makb2021',style: TextStyle(color: Color(0xFF19B52B),fontSize: size.width*.05,fontWeight: FontWeight.normal),),
                //                 )),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //               children: [
                //                 Expanded(
                //                   child: ListTile(
                //                     title: const Text('BKash'),
                //                     leading: Radio<SingingCharacter>(
                //                       value: SingingCharacter.Bkash,
                //                       groupValue: _operator,
                //                       onChanged: (SingingCharacter? value) {
                //                         setState(() {
                //                           _operator = value;
                //                         });
                //                       },
                //                       activeColor: Colors.green,
                //                     ),
                //                   ),
                //                 ),
                //
                //                 Expanded(
                //                   child: ListTile(
                //                     title: const Text('Nagad'),
                //                     leading: Radio<SingingCharacter>(
                //                       value: SingingCharacter.Nagad,
                //                       groupValue: _operator,
                //                       onChanged: (SingingCharacter? value) {
                //                         setState(() {
                //                           _operator = value;
                //                         });
                //
                //
                //                       },
                //                       activeColor: Colors.green,
                //                     ),
                //                   ),
                //                 ),
                //
                //
                //               ],
                //             ),
                //             Container(
                //               height: size.width*.15,
                //               child: ListTile(
                //                 title: const Text('Others'),
                //                 leading: Radio<SingingCharacter>(
                //                   value: SingingCharacter.Others,
                //                   groupValue: _operator,
                //                   onChanged: (SingingCharacter? value) {
                //                     setState(() {
                //                       _operator = value;
                //                     });
                //                   },
                //                   activeColor: Colors.green,
                //                 ),
                //               ),
                //             ),
                //
                //             TextField(
                //
                //               controller: amountController,
                //               decoration: textFieldFormDecoration(size).copyWith(
                //
                //                 labelText: 'Amount',
                //                 hintText: '50000',
                //                 suffixText:'TK' ,suffixStyle: TextStyle(color: Colors.black,fontSize: size.width*.04),
                //               ),
                //             ),
                //
                //
                //             Padding(
                //               padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                //               child: TextField(
                //
                //                 controller: mobileNoController,
                //                 decoration: textFieldFormDecoration(size).copyWith(
                //
                //                   labelText: 'Mobile No',
                //                   hintText: '01475286325',
                //                     suffixIcon: Icon(Icons.mobile_friendly_outlined)
                //                 ),
                //               ),
                //             ),
                //
                //
                //             TextField(
                //               obscureText: _isVisible,
                //               controller: passwordController,
                //               decoration: textFieldFormDecoration(size).copyWith(
                //
                //                   labelText: 'Password',
                //                   hintText: '********',
                //
                //                   suffixIcon: InkWell(
                //                       onTap: (){
                //                         setState(() {
                //                           _isVisible =!_isVisible;
                //                         });
                //                       },
                //                       child: Icon(_isVisible==true?Icons.visibility:Icons.visibility_off))
                //               ),
                //             ),
                //
                //             SizedBox(height: size.width*.05,),
                //
                //           ],),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: size.width*.03,),
                GradientButton(child: Text('Withdraw'), onPressed: (){
                  if(amountController.text!=''&&passwordController.text!=''){
                    dynamic balance=availableBalance-int.parse(amountController.text);
                    if(availableBalance<500){
                      showToast('Not enough balance!');
                    }else{
                      if(balance<0){
                        showToast('Not enough balance!');
                      }else{
                        if(passwordController.text==userController.user.password){
                          authController.withdrawHistory(amountController.text,userController.user.name!,due,userController.user.imageUrl!).then((value){
                            amountController.clear();
                            passwordController.clear();
                          });
                        }else{
                          showToast('Wrong Password!');
                        }

                      }
                    }
                  }else{
                    showToast('Fill up the required fields');
                  }

                }, borderRadius: 10, height:size.width*.1, width:size.width*.5,
                    gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),

                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0,top: 15),
                    child: Text('WithDraw History',
                      style: TextStyle(
                          color: Color(0xFF19B52B),
                          fontSize: size.width * .04,
                          fontWeight: FontWeight.bold),),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      Divider(height: 1,color: Colors.green,),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: userController.withdrawHistory.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: size.width * .02),
                              child: Card(
                                elevation: 1,
                                child: ListTile(
                                  leading:Text(userController.withdrawHistory[index].date),

                                  title: Center(
                                    child: Text(
                                      userController.withdrawHistory[index].amount,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: size.width * .04,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  trailing: Text(
                                    userController.withdrawHistory[index].status,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
