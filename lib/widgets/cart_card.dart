import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mak_b/models/Cart.dart';

class CartCard extends StatelessWidget {
  final Cart cartItem;

  const CartCard({ required this.cartItem});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Container(
      color: Color(0xFF19B52B).withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
            const EdgeInsets.all(8.0),
            child: Image.asset(
              cartItem.product.images[0],
              width: 80,
            ),
          ),
          Expanded(
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 14),
                      child: Text(
                        cartItem.product.title,
                      )
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 14),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.minus,
                          size: 20,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.all(
                              8.0),
                          child: Text(
                             '2',style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.plus,
                          size: 20,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  )
                ],
              )),
          Padding(
            padding:
            const EdgeInsets.all(14),
            child: Text(
               "\$${cartItem.product.price}",
              style: TextStyle(fontSize: size.width*.045,
                fontWeight: FontWeight.bold,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: Icon(
              FontAwesomeIcons.trash,
              size: 20,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}