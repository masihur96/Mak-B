import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mak_b/models/Product.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/variables/size_config.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(context,20)),
          child: Text(
            product.title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(context,20),
            right: getProportionateScreenWidth(context,64),
          ),
          child: Text(
            product.description,
            maxLines: 3,
          ),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Padding(
              padding:
              EdgeInsets.only(left: getProportionateScreenWidth(context,20)),
              child: Text(
                'Price:'+'${product.price}',style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 5,),
            Text(
              "\$${product.price}",
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontSize:
                getProportionateScreenWidth(context, 12),
                fontWeight: FontWeight.w300,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(context,20)),
          child: Text(
            'Size: M',style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
