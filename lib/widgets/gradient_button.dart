import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GradientButton extends StatelessWidget {
  Widget? child;
  Function()? onPressed;
  double? borderRadius;
  double? height;
  double? width;
  List<Color>? gradientColors;
  GradientButton({
      required this.child,required this.onPressed,required this.borderRadius,required this.height,
    required this.width, required this.gradientColors});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
          ),
        ),
        child: Ink(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors!,
            ),
            borderRadius:
            BorderRadius.all(Radius.circular(borderRadius!)),
          ),
          child: Center(
            child: child,
          ),
          ),
        );
  }
}
