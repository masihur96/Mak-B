import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mak_b/controller/product_controller.dart';
import 'package:mak_b/models/product_model.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/variables/size_config.dart';
import 'details/details_screen.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ProductModel> filteredProducts = [];
  List<ProductModel> productList = [];
  int _counterProduct = 0;
  int count = 0;
  String? text='Search Products';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    final size = MediaQuery
        .of(context)
        .size;
    if (_counterProduct == 0) {
      productController.getProducts().then((value) {
        setState(() {
          _counterProduct++;
          productList = productController.productList;
        });
      });
    }
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back), onPressed: () {
                Get.back();
              },),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: size.width * 0.85,
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        text='No Products';
                        setState(() {
                          filteredProducts = productList
                              .where((u) =>
                          (u.title!
                              .toLowerCase()
                              .contains(value.toLowerCase())))
                              .toList();
                        });
                        if(value==''){
                          filteredProducts=[];
                          text='Search Products';
                        }
                      },
                      onSubmitted: (value) async {
                        filteredProducts = productList
                            .where((u) =>
                        (u.title!
                            .toLowerCase()
                            .contains(value.toLowerCase())))
                            .toList();
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(
                                  context, 20),
                              vertical: getProportionateScreenWidth(
                                  context, 6)),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "What would you like to buy",
                          hintStyle: TextStyle(fontSize: size.width * .037),
                          prefixIcon: Icon(Icons.search)),
                    ),

                  ),
                ),
              ],
            ),
            body: Container(
              height: size.height,width: size.width,
              child: filteredProducts.length==0?Center(child: Text(text!)):ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            Get.to(()=>DetailsScreen(product: filteredProducts[index]));
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * .25,
                                    child: AspectRatio(
                                      aspectRatio: 0.88,
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            getProportionateScreenWidth(context, 20)),
                                        decoration: BoxDecoration(
                                          color: kSecondaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: filteredProducts[index].image!=null?Hero(
                                            tag: filteredProducts[index].id.toString(),
                                            child: CachedNetworkImage(
                                              imageUrl: filteredProducts[index].image![0],
                                              placeholder: (context, url) => CircleAvatar(
                                                  backgroundColor: Colors.grey.shade200,
                                                  radius: size.width * .08,
                                                  backgroundImage: AssetImage(
                                                      'assets/images/placeholder.png')),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            )
                                        ):Container(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: size.width * .35,
                                        child: Text(
                                          filteredProducts[index].title!,
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 16),
                                          maxLines: 2,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        width: size.width * .35,
                                        child: Text(
                                          "${filteredProducts[index].price}",
                                          style: TextStyle(
                                              color: kPrimaryColor, fontSize: 16),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10)
                            ],
                          ),
                        )
                    );
                  }),
            )
        ),
        _isLoading ? Center(child: CircularProgressIndicator()) : Container()
      ],
    );
  }

}