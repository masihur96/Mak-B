import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mak_b/models/Product.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/variables/size_config.dart';
import 'package:mak_b/widgets/search_field.dart';
import 'cart_page.dart';
import 'package:mak_b/widgets/icon_btn_with_counter.dart';
import 'package:mak_b/widgets/product_card.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
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

            InkWell(
              onTap: ()async{
                // SharedPreferences pref = await SharedPreferences.getInstance();
                // // pref.setString('userId', '');
                // // pref.setString('api_token', '');
                // pref.clear();
                // Navigator.pushNamedAndRemoveUntil(context, MainPage.routeName,(Route<dynamic> route) => false);
                //_showToast('Logged Out', kPrimaryColor);
              },
              child: ListTile(
                title: Text('Log In'),
                leading: Icon(Icons.login, color: Colors.grey,),
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
              numOfitem: 3,
              press: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()))
            ),
          ),
          SizedBox(width: 3),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: getProportionateScreenWidth(context,10)),
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: new ClampingScrollPhysics(),
              itemCount: demoProducts.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisSpacing: 15,childAspectRatio: 6/9),
              itemBuilder: (BuildContext context, int index) {
                // if (demoProducts[index].isPopular)
                return ProductCard(product: demoProducts[index]);
                // return SizedBox
                //     .shrink(); // here by default width and height is 0
              },
            ),
          ),
          //SizedBox(width: getProportionateScreenWidth(20)),
        ],
      ), //CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
