import 'package:flutter/material.dart';
import 'package:mak_b/models/Product.dart';
import 'package:mak_b/pages/login_page.dart';
import 'package:mak_b/variables/size_config.dart';
import 'package:mak_b/widgets/gradient_button.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatelessWidget {
  final Product product;

  const Body({required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView(
      children: [
        ProductImages(product: product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: product,
              ),
              TopRoundedContainer(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: getProportionateScreenWidth(context,15),
                        top: getProportionateScreenWidth(context,15),
                      ),
                      child: GradientButton(
                          child: Text(
                            'Add To Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => Account()));
                          },
                          borderRadius: 5.0,
                          height: size.width * .12,
                          width: size.width * .4,
                          gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        bottom: getProportionateScreenWidth(context,15),
                        top: getProportionateScreenWidth(context,15),
                      ),
                      child: GradientButton(
                          child: Text(
                            'Buy Now',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          borderRadius: 5.0,
                          height: size.width * .12,
                          width: size.width * .4,
                          gradientColors: [Color(0xFF0198DD), Color(0xFF19B52B)]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
