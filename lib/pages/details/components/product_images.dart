import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:mak_b/models/Product.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/variables/size_config.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({

    required this.product,
  });

  final Product product;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return ImageSlideshow(
      width: double.infinity,
      height: 200,
      initialPage: 0,
      indicatorColor: kPrimaryColor,
      indicatorBackgroundColor: Colors.grey,
      autoPlayInterval: 3000,
      isLoop: true,
      children: [
        Image.asset(
          'assets/images/ps4_console_white_1.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/ps4_console_white_2.png',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/ps4_console_white_4.png',
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
