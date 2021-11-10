import 'package:flutter/material.dart';
import 'package:mak_b/models/package_model.dart';
import 'components/body.dart';

class PackageDetailsScreen extends StatefulWidget {
  final PackageModel product;
  
  final bool sold;
  PackageDetailsScreen({required this.product,required this.sold});

  @override
  State<PackageDetailsScreen> createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color(0xFFF5F6F9),
      body: Body(product: widget.product,sold: widget.sold,),
    );
  }
}
