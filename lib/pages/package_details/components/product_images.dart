import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:mak_b/models/Product.dart';
import 'package:mak_b/models/package_model.dart';
import 'package:mak_b/models/product_model.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/variables/size_config.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({

    required this.product,
  });

  final PackageModel product;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  static List<Widget>? imageSliders;
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        height: size.height*.35,
        width:  size.width*.9,
        child: Carousel(
            boxFit: BoxFit.none,
            autoplay: true,
            autoplayDuration: const Duration(seconds: 4),
            animationCurve: Curves.fastOutSlowIn,
            animationDuration: Duration(milliseconds: 1000),
            dotSize: 6.0,
            dotIncreasedColor: Colors.white,
            dotBgColor: Colors.transparent,
            dotPosition: DotPosition.bottomCenter,
            dotVerticalPadding: 10.0,
            showIndicator: true,
            indicatorBgPadding: 7.0,
            images: bannerSlider(context)
        ),
      ),
    );
    //   ImageSlideshow(
    //   width: double.infinity,
    //   height: 200,
    //   initialPage: 0,
    //   indicatorColor: kPrimaryColor,
    //   indicatorBackgroundColor: Colors.grey,
    //   autoPlayInterval: 3000,
    //   isLoop: true,
    //   children: [
    //     Image.asset(
    //       'assets/images/ps4_console_white_1.png',
    //       fit: BoxFit.cover,
    //     ),
    //     Image.asset(
    //       'assets/images/ps4_console_white_2.png',
    //       fit: BoxFit.cover,
    //     ),
    //     Image.asset(
    //       'assets/images/ps4_console_white_4.png',
    //       fit: BoxFit.cover,
    //     ),
    //   ],
    // );
  }

  List<Widget> bannerSlider(BuildContext context) {
    return imageSliders = widget.product.image!
        .map<dynamic>((item) => Container(
      child: Container(
        height: MediaQuery.of(context).size.height * .06,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: InkWell(
              onTap: () async {
              },
              child: item==null?Container():Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6)),
                  child: CachedNetworkImage(
                    imageUrl: item,
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(),
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error),
                    fit: BoxFit.fill,
                  ))//Image.network(item.photo,fit: BoxFit.fill,)),
          ),
        ),
      ),
    )).cast<Widget>()
        .toList();
  }
}
