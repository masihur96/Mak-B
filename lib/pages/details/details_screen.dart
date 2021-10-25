import 'package:flutter/material.dart';
import 'package:mak_b/models/product_model.dart';
import '../../models/Product.dart';
import 'components/body.dart';

class DetailsScreen extends StatefulWidget {
  final ProductModel product;
  DetailsScreen({required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color(0xFFF5F6F9),
      body: Body(product: widget.product),
    );
  }
}
