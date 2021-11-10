import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mak_b/variables/constants.dart';

Widget loadingWidget = SpinKitSpinningLines(color: Colors.green, size: 40.0);

void showLoadingDialog(BuildContext context) {
  showGeneralDialog(
    //barrierLabel: _title,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: SpinKitSpinningLines(color: Colors.green.shade300, size: 60.0),
        );
      });
}
closeLoadingDialog(BuildContext context) => Navigator.pop(context);
void showToast(String? message) {
  Fluttertoast.showToast(
      msg: message!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black.withOpacity(0.75),
      textColor: Colors.white,
      fontSize: 16.0);
}