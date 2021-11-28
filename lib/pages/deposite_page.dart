import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'add_deposite.dart';
import 'package:get/get.dart';
import 'package:mak_b/widgets/gradient_button.dart';

class DepositePage extends StatefulWidget {
  @override
  _DepositePageState createState() => _DepositePageState();
}

class _DepositePageState extends State<DepositePage> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GetBuilder<UserController>(
      builder: (userController) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Deposit",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: ()async{
              await userController.getDepositHistory(userController.id!) ;
              print('Refresh');
            },
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                        elevation: 3,
                        shadowColor: Colors.grey,
                        child: Container(
                          height: size.width * .5,
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                userController.userModel.value.name ?? '',
                                style: TextStyle(
                                    color: Color(0xFF19B52B),
                                    fontSize: size.width * .05),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 15),
                                child: Text(
                                  'Deposit Balance: ${userController.userModel.value.depositBalance ?? ''}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.width * .04),
                                ),
                              ),
                              GradientButton(
                                  child: Text(
                                    'Add Deposit',
                                    style: TextStyle(fontSize: size.width * .04),
                                  ),
                                  onPressed: () {
                                    Get.to(() => AddDeposit());
                                  },
                                  borderRadius: 10,
                                  height: size.width * .1,
                                  width: size.width * .5,
                                  gradientColors: [
                                    Color(0xFF0198DD),
                                    Color(0xFF19B52B)
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.width*.03),
                    Align(
                      alignment: Alignment.center,
                      child: Card(
                        elevation: 3,
                        shadowColor: Colors.grey,
                        child: Container(
                          color: Colors.white,
                          width: size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'History',
                                  style: TextStyle(
                                      color: Color(0xFF19B52B),
                                      fontSize: size.width * .05),
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.green,
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: userController.depositList.length,
                                  itemBuilder: (context, index) {
                                    /// millisecond date is converting to date format
                                    DateTime date =
                                        DateTime.fromMillisecondsSinceEpoch(int.parse(
                                            userController.depositList[index].date!));
                                    var format = new DateFormat("yMMMd").add_jm();
                                    String withdrawDate = format.format(date);

                                    return Padding(
                                      padding:
                                          EdgeInsets.only(bottom: size.width * .02),
                                      child: Card(
                                        elevation: 1,
                                        child: ListTile(
                                          leading: Text(withdrawDate),
                                          title: Center(
                                            child: Text(
                                              userController
                                                  .depositList[index].status!,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: size.width * .04,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          trailing: Text(
                                            userController.depositList[index].amount!,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: size.width * .04,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
