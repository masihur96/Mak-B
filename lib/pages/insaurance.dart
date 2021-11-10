import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:intl/intl.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/widgets/gradient_button.dart';
import 'package:mak_b/widgets/notification_widget.dart';

class Insaurance extends StatefulWidget {
  const Insaurance({Key? key}) : super(key: key);

  @override
  _InsauranceState createState() => _InsauranceState();
}

class _InsauranceState extends State<Insaurance> {
  final UserController userController = Get.find<UserController>();
  int counter = 0;
  dynamic insuranceToPay;
  dynamic remaining;
  dynamic due;
  String? lastDateOfInsurance;
  String? currentDateOfInsurance;
  DateTime? currentDate;
  DateTime? lastInsuranceDate;
  DateTime? insuranceEndingDate;
  var months;
  var remainingMonths;
  String? registrationDate;
  String? insuranceLastDate;
  int? remainingMonth;
  var remainingYear;
  int? remainingYears;

  void count() {
    setState(() {
      counter++;
      currentDate = DateTime.now();
      lastInsuranceDate = DateTime.fromMillisecondsSinceEpoch(int.parse(userController.userModel.value.lastInsurancePaymentDate!));
      insuranceEndingDate = DateTime.fromMillisecondsSinceEpoch(int.parse(userController.userModel.value.insuranceEndingDate!));
      months = currentDate!.difference(lastInsuranceDate!).inDays ~/ 30;
      insuranceToPay = months * 250;
      remainingMonths = currentDate!.difference(insuranceEndingDate!).inDays ~/ 30;
      due = insuranceToPay - int.parse(userController.userModel.value.insuranceBalance!);
      remaining = remainingMonths * 250 * (-1);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(userController.userModel.value.timeStamp!));
      var format = new DateFormat("yMMMd");
      registrationDate = format.format(date);
      var format2 = new DateFormat("yMMMd");
      insuranceLastDate = format2.format(insuranceEndingDate!);
      remainingYear=(remainingMonths/12)*-1;
      remainingMonth=(remainingMonths%12);
      var lastInsDate = new DateTime.fromMicrosecondsSinceEpoch(int.parse(userController.userModel.value.insuranceEndingDate!)* 1000);
      lastDateOfInsurance='${lastInsDate.day}-${lastInsDate.month}-${lastInsDate.year}';
      currentDateOfInsurance='${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';


      // var remainingSec = DateTime.fromMillisecondsSinceEpoch(int.parse(userController.userModel.value.insuranceEndingDate!)*1000)
      //     .difference(DateTime.fromMillisecondsSinceEpoch(int.parse(userController.userModel.value.timeStamp!)*1000)).inSeconds;
      // remainingYear = remainingSec~/(12*30*24*3600);
      // remainingSec = remainingSec%(12*30*24*3600);
      // remainingMonth = remainingSec~/(30*24*3600);
      // remainingSec = remainingSec%(30*24*3600);
      // var day = remainingSec~/(24*3600);
      // remainingSec = remainingSec%(24*3600);
      // var hours= remainingSec~/3600;
      // remainingSec%=3600;
      // var minute=remainingSec~/60;
      // remainingSec%=60;
      // var second = remainingSec;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (counter == 0) {
      count();
    }
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
        userController.userModel.value.insuranceWithDraw==false?currentDateOfInsurance==lastDateOfInsurance?Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
              child: GradientButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'WithDraw',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () async{
                    await userController.insuranceWithDraw(userController.userModel.value.name!, userController.userModel.value.phone!,
                        userController.userModel.value.insuranceBalance!).then((value)async{
                      await userController.updateInsuranceWithDraw();
                    });
                  },
                  borderRadius: 5.0,
                  height: size.width * .1,
                  width: size.width * .25,
                  gradientColors: [
                    Color(0xFF0198DD),
                    Color(0xFF0861AF)
                  ]),
            )
          ],
        ):Container():Container(),
        SizedBox(
          height: size.width * .03,
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
          height: size.width * .04,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * .04, vertical: size.width * .01),
          child: Card(
            elevation: 2,
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: size.width*.03, vertical: size.width*.03),
              child: Column(
                children: [
                  insuranceDetailPreview(size, "Insurance Starting date:", registrationDate!),
                  insuranceDetailPreview(size, "Insurance Ending date:", insuranceLastDate!),
                  insuranceDetailPreview(size, "Duration:", "5 years"),
                  insuranceDetailPreview(size, "Remaining time:", "$remainingYear year $remainingMonth month"),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.width * .04,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            insuranceCard(
                size,
                Color(0xFF19B52B),
                insuranceToPay.toString(),
                'Insurance to pay'),
            insuranceCard(size, Color(0xFF0861AF), userController.userModel.value.insuranceBalance!, 'Paid insurance'),
            insuranceCard(size, Color(0xFF0198DD), due.toString(), 'Due insurance'),
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

  Widget insuranceDetailPreview(Size size, String title, String value) {
    return Column(
      children: [
        Row(
          children: [
            Text(title,
                style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: size.width * .04,
                  fontWeight: FontWeight.w500
                )),
            SizedBox(width: size.width*.04,),
            Text(value,
                style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: size.width * .04)),
          ],
        ),
        SizedBox(height: size.width*.02),
      ],
    );
  }

  Widget insuranceCard(Size size, Color color, String amount, String title) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * .04),
      ),
      child: Container(
        width: size.width * .28,
        height: size.width * .28,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size.width * .04),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              amount.toString(),
              style: TextStyle(color: Colors.white, fontSize: size.width * .06, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * .035,
                  fontWeight: FontWeight.w500,
                  ),
            )
          ],
        ),
        padding: EdgeInsets.all(size.width * .03),
      ),
      elevation: 4,
    );
  }
}
