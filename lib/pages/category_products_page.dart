import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mak_b/controller/product_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mak_b/widgets/product_card.dart';

class CategoryProductsPage extends StatefulWidget {
  String? category;


  CategoryProductsPage(this.category);

  @override
  _CategoryProductsPageState createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  int count=0;
  bool _isLoading =true;

  Future<void> fetch(ProductController productController)async {
    setState(() {
      count++;
    });
    await productController.getCategoryProducts(widget.category!).then((value){
      setState(() {
        _isLoading=false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProductController productController=Get.find<ProductController>();
    if(count==0){
      fetch(productController);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category!,style: TextStyle(color: Colors.black),),
      ),
      body: _isLoading?Center(child: CupertinoActivityIndicator()):Padding(
        padding: const EdgeInsets.only(right:12.0,top: 8.0),
        child:  StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: new ClampingScrollPhysics(),
          itemCount: productController.categoryProductList.length,
          crossAxisCount: 3,
          itemBuilder: (BuildContext context, int index) {
            // if (demoProducts[index].isPopular)
            return ProductCard(product: productController.categoryProductList[index]);
            // return SizedBox
            //     .shrink(); // here by default width and height is 0
          },
          staggeredTileBuilder: (int index) =>
          new StaggeredTile.fit(1),
          mainAxisSpacing: 15.0,

        ),
      ), //CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
