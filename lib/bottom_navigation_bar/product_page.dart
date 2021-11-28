import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mak_b/controller/product_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/pages/category_products_page.dart';
import 'package:mak_b/pages/contact_info.dart';
import 'package:mak_b/pages/details/details_screen.dart';
import 'package:mak_b/pages/login_page.dart';
import 'package:mak_b/pages/watch_video_page.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mak_b/variables/size_config.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import 'package:mak_b/widgets/search_field.dart';
import 'package:mak_b/widgets/solid_color_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_nav.dart';
import 'cart_page.dart';
import 'package:mak_b/widgets/icon_btn_with_counter.dart';
import 'package:mak_b/widgets/product_card.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final UserController userController=Get.find<UserController>();
  final ProductController productController=Get.find<ProductController>();
  String? id;

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.get('id') as String?;
      //pass = preferences.get('pass');
    });
  }
  @override
  void initState() {
    super.initState();
    _checkPreferences();
  }

  Future<void> fetch()async{
    await productController.getProducts();
    await productController.getArea();
    await productController.getPackage();
    await userController.getProductOrder();
    await userController.getRate();
    await productController.getCategory();
    await productController.getAreaHub(productController.areaList[0].id);
    await productController.getCategory();
    await productController.getSubCategory(productController.categoryList[0].category);
    //await productController.getSubCategoryProducts(productController.subCategoryList[0].subCategory);
  }
  Future<void> fetch1()async{
    if(productController.categoryList.isEmpty) await productController.getCategory();
    if(productController.subCategoryList.isEmpty) await productController.getSubCategory(productController.categoryList[0].category);
    //if(productController.categoryProductList.isEmpty) await productController.getSubCategoryProducts(productController.subCategoryList[0].subCategory);
    if(userController.storePackageList.isEmpty)await userController.getMyStore();
    if(userController.productOrderList.isEmpty)await userController.getProductOrder();
    if(productController.packageList.isEmpty)await productController.getPackage();
    if(userController.infoList.isEmpty)await userController.getContactInfo();
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    fetch1();
    return Obx(()=>Scaffold(
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            SizedBox(height: 20,),
            Container(
              height: 80,width: 80,
              decoration: BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
              ),
              child: Image.asset("assets/icons/deub.png"),
            ),
            SizedBox(height: 20),
            Divider(),
            // ListView.builder(
            //   shrinkWrap: true,
            //   itemCount: productController.categoryList.length,
            //     itemBuilder:(_,index){
            //   return InkWell(
            //     onTap: (){
            //         Get.to(()=>CategoryProductsPage(productController.categoryList[index].category));
            //     },
            //     child: ListTile(
            //       title: Text(productController.categoryList[index].category),
            //     ),
            //   );
            // }),

            // ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: productController.categoryList.length,
            //     itemBuilder:(_,index){
            //       return InkWell(
            //         onTap: (){
            //           Get.to(()=>CategoryProductsPage(productController.categoryList[index].category));
            //         },
            //         child: ExpansionTile(
            //           expandedAlignment: Alignment.topLeft,
            //           title: Text(productController.categoryList[index].category),
            //           children: <Widget>[
            //             Row(
            //               children: [
            //                 SizedBox(width: 30,),
            //                 Text("children 1",style: TextStyle(color: Colors.black),),
            //               ],
            //             ),
            //             SizedBox(height: 20,),
            //             Row(
            //               children: [
            //                 SizedBox(width: 30,),
            //                 Text("children 2",style: TextStyle(color: Colors.black),),
            //               ],
            //             ),
            //             SizedBox(height: 10,),],
            //         )
            //       );
            //     }),
            InkWell(
              onTap: ()async{
                Get.to(()=>CategoryProductsPage());
              },
              child: ListTile(
                title: Text('Categories'),
                leading: Icon(Icons.category_outlined, color: Colors.grey),
              ),
            ),
            Divider(),

            InkWell(
              onTap: ()async{
                Get.to(()=>ContactInfo());
              },
              child: ListTile(
                title: Text('Contact Info'),
                leading: Icon(Icons.contact_support_outlined, color: Colors.grey),
              ),
            ),
            Divider(),

            id == null?InkWell(
              onTap: ()async{
                Get.to(()=>LoginPage());
              },
              child: ListTile(
                title: Text('Log In'),
                leading: Icon(Icons.login, color: Colors.grey),
              ),
            ): InkWell(
              onTap: ()async{
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.clear();
                userController.clear();
                Get.offAll(()=>HomeNav());
                showToast('Logged Out');
              },
              child: ListTile(
                title: Text('Log Out'),
                leading: Icon(Icons.logout, color: Colors.grey,),
              ),
            ),

          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        actions: [
          Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchField(),
          )),
          SizedBox(width: 1),
          Center(
            child: IconBtnWithCounter(
                svgSrc: "icons/Cart Icon.svg",
                numOfitem: id==null?productController.cartList==null?0:productController.cartList.length:userController.cartList==null?0:userController.cartList.length,
                press: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()))
            ),
          ),
          SizedBox(width: 3),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          return fetch();
        },
        child: ListView(
          physics:ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          shrinkWrap: true,
          children: [
            //SizedBox(height: getProportionateScreenWidth(context,10)),
            GestureDetector(
              onTap:()=> id==null?showToast('Please log in first'):userController.userModel.value.videoWatched=='5'?_showDialog():Navigator.push(context, MaterialPageRoute(builder: (context)=>WatchVideo())),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    height: 170,
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        image: DecorationImage(
                            image: AssetImage('assets/images/watch_1.png'),
                            fit: BoxFit.fill
                        )
                    ),
                  ),
                  Positioned(
                    bottom: 10.0,
                    right: 20.0,
                    child: SolidColorButton(
                        child: Text('Watch Now',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                        onPressed: ()=>id==null?showToast('Please log in first'):
                        userController.userModel.value.videoWatched=='5'?_showDialog():
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>WatchVideo())),
                        borderRadius: 5.0,
                        height: size.width*.06,
                        width: size.width*.3,
                        bgColor: Colors.amber),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child:  StaggeredGridView.countBuilder(
                shrinkWrap: true,
                physics: new ClampingScrollPhysics(),
                itemCount: productController.productList.length,
                crossAxisCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  // if (demoProducts[index].isPopular)
                  return Padding(
                    padding: EdgeInsets.only(left: getProportionateScreenWidth(context, 8)),
                    child: SizedBox(
                      width: getProportionateScreenWidth(context, 140),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsScreen(product: productController.productList[index])));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF19B52B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                          getProportionateScreenWidth(context, 20)),
                                      decoration: BoxDecoration(
                                        color: kSecondaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: productController.productList[index].image!=null?Hero(
                                          tag: productController.productList[index].id.toString(),
                                          child: CachedNetworkImage(
                                            imageUrl: productController.productList[index].thumbNail,
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
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 2.0, right: 2.0),
                                    //   child: Icon(
                                    //     Icons.add_circle_outline,
                                    //     color: kPrimaryColor,
                                    //   ),
                                    // )
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0, left: 3),
                                  child: Text(
                                    productController.productList[index].title!,
                                    style: TextStyle(color: Colors.black),
                                    maxLines: 2,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0, left: 3),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "\৳${productController.productList[index].price}",
                                        style: TextStyle(
                                          fontSize:
                                          getProportionateScreenWidth(context, 15),
                                          fontWeight: FontWeight.w500,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      // Text(
                                      //   "\$${productController.productList[index].price}",
                                      //   style: TextStyle(
                                      //     decoration: TextDecoration.lineThrough,
                                      //     fontSize:
                                      //     getProportionateScreenWidth(context, 12),
                                      //     fontWeight: FontWeight.w300,
                                      //     color: Colors.grey[600],
                                      //   ),
                                      // ),
                                      const SizedBox(height: 6),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                  // return SizedBox
                  //     .shrink(); // here by default width and height is 0
                },
                staggeredTileBuilder: (int index) =>
                new StaggeredTile.fit(1),
                mainAxisSpacing: 15.0,

              ),
            ),
            //SizedBox(width: getProportionateScreenWidth(20)),
          ],
        ),
      ), //CustomBottomNavBar(selectedMenu: MenuState.home),
    ));
  }

  _showDialog() {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {

          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: Colors.white,
              scrollable: true,
              contentPadding: EdgeInsets.all(20),
              title: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .030,
                  ),
                  Text(
                    'Your video watching limit is over for today.\n'
                        'Please wait for the next day.\nThank you!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .050,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          Get.back();
                          //Navigator.of(context).pop();
                        },
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
