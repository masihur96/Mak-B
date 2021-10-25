import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mak_b/controller/product_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/models/Product.dart';
import 'package:mak_b/pages/login_page.dart';
import 'package:mak_b/pages/watch_video_page.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            Container(
              height: 50,
              color: kPrimaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10,),
                  Center(child: Text('Categories',style: TextStyle(color: Colors.white),)),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text('T-Shirt'),
              ),
            ),

            InkWell(
              onTap: (){

              },
              child: ListTile(
                title: Text('Shirt'),
              ),
            ),

            InkWell(
              onTap: (){

              },
              child: ListTile(
                title: Text('Coat'),
              ),
            ),

            InkWell(
              onTap: (){

              },
              child: ListTile(
                title: Text('Jersey'),
              ),
            ),

            InkWell(
              onTap: (){

              },
              child: ListTile(
                title: Text('Trouser'),
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
              numOfitem: productController.cartList==null?0:productController.cartList.length,
              press: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()))
            ),
          ),
          SizedBox(width: 3),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          //SizedBox(height: getProportionateScreenWidth(context,10)),
            GestureDetector(
              onTap:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>WatchVideo())),
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
                        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>WatchVideo())),
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
                return ProductCard(product: productController.productList[index]);
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
      ), //CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
