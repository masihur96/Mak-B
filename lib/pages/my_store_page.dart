import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.only(left: 5.0,right: 5.0),
          child:   SingleChildScrollView(
            child: Column(



              children: [

              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Store Collection',style: TextStyle(color: Colors.black,fontSize:size.width*.04,fontWeight: FontWeight.bold ),),
                  )),

                Padding(

                  padding: const EdgeInsets.only(right:8.0),

                  child: GridView.builder(

                    shrinkWrap: true,

                    physics: new ClampingScrollPhysics(),

                    itemCount:4,

                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(

                        crossAxisCount: 2,

                        mainAxisSpacing: 2,

                        childAspectRatio: 5/9),

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
      ),
    );
  }
}
