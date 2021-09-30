import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mak_b/variables/size_config.dart';
import 'package:mak_b/widgets/package_card.dart';

class PackageListPage extends StatefulWidget {
  const PackageListPage({Key? key}) : super(key: key);

  @override
  _PackageListPageState createState() => _PackageListPageState();
}

class _PackageListPageState extends State<PackageListPage> {


  @override

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Packages",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenWidth(context,10)),
            Padding(
              padding:  EdgeInsets.only(top: size.width*.02,left: size.width*.02,right: size.width*.02,bottom:size.width*.02 ),

              child: Text('Regular Package',style: TextStyle(color: Colors.black,fontSize: size.width*.05 ),),
            ),

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
          ],
          ),
        ),
      ),
    );
  }
}
