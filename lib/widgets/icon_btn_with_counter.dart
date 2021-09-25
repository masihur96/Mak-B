import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/variables/size_config.dart';

class IconBtnWithCounter extends StatefulWidget {
  const IconBtnWithCounter({
    required this.svgSrc,
    required this.numOfitem,
    this.press,
  });

  final String svgSrc;
  final int numOfitem;
  final GestureTapCallback? press;

  @override
  _IconBtnWithCounterState createState() => _IconBtnWithCounterState();
}

class _IconBtnWithCounterState extends State<IconBtnWithCounter> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: widget.press,
      child: Padding(
        padding: const EdgeInsets.only(right: 3.0),
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Icon(Icons.shopping_cart_rounded,size: 28,color:  kSecondaryColor.withOpacity(0.6),),
            // Container(
            //   padding: EdgeInsets.all(getProportionateScreenWidth(context,12)),
            //   height: getProportionateScreenWidth(context,42),
            //   width: getProportionateScreenWidth(context,42),
            //   decoration: BoxDecoration(
            //     color: Colors.white70,
            //     shape: BoxShape.circle,
            //   ),
            //   child: SvgPicture.asset(widget.svgSrc),
            // ),
            if (widget.numOfitem != 0)
              Positioned(
                top: -3,
                right: 0,
                child: Container(
                  height: getProportionateScreenWidth(context,16),
                  width: getProportionateScreenWidth(context,16),
                  decoration: BoxDecoration(
                    color: Color(0xFFDB3699),
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.5, color: Colors.white),
                  ),
                  child: Center(
                    child: Text(
                      "${widget.numOfitem}",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(context,10),
                        height: 1,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
