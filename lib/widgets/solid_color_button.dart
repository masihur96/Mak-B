import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SolidColorButton extends StatelessWidget {
  Function() onPressed;
  Widget child;
  double borderRadius;
  double height;
  double width;
  Color bgColor;

  SolidColorButton(
      {required this.child,
      required this.onPressed,
      required this.borderRadius,
      required this.height,
      required this.width,
      required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: InkWell(
            onTap: onPressed,
            splashColor: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            child: Container(
              height: height,
              width: width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: child,
            )
        )
    );
  }
}
