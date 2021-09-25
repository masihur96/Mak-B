import 'package:flutter/material.dart';
import '../../models/Product.dart';
import 'components/body.dart';

class DetailsScreen extends StatelessWidget {
  final Product product;
  DetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color(0xFFF5F6F9),
      body: Body(product: product),
    );
  }
}
