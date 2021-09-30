import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mak_b/variables/size_config.dart';
import 'package:mak_b/widgets/package_card.dart';

class MyStorePage extends StatefulWidget {
  @override
  _MyStorePageState createState() => _MyStorePageState();
}

class _MyStorePageState extends State<MyStorePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Store",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child:Padding(
          padding: EdgeInsets.only(left: 5.0,right: 5.0),
          child:   ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: getProportionateScreenWidth(context,10)),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:  EdgeInsets.only(top: size.width*.02,left: size.width*.02,right: size.width*.02,bottom:size.width*.02 ),

                  child: Text('Store Collection',style: TextStyle(color: Colors.black,fontSize: size.width*.05 ),),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: new ClampingScrollPhysics(),
                  itemCount:10,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      childAspectRatio: 4.9/9),
                  itemBuilder: (BuildContext context, int index) {
                    // if (demoProducts[index].isPopular)
                    return PackageCard();
                    // return SizedBox
                    //     .shrink(); // here by default width and height is 0
                  },
                ),
              ),





          ],),
        ),
      ),
    );
  }
}
