import 'package:flutter/material.dart';
import 'package:mak_b/variables/size_config.dart';

class TopRoundedContainer extends StatefulWidget {
  const TopRoundedContainer({
    required this.color,
    required this.child,
  });

  final Color color;
  final Widget child;

  @override
  State<TopRoundedContainer> createState() => _TopRoundedContainerState();
}

class _TopRoundedContainerState extends State<TopRoundedContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: getProportionateScreenWidth(context,20)),
      padding: EdgeInsets.only(top: getProportionateScreenWidth(context,20)),
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: widget.child,
    );
  }
}
