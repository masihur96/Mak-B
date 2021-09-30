import 'package:flutter/material.dart';

class PackageCard extends StatefulWidget {
  @override
  _PackageCardState createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  List selectedColor=[];
  List selectedSize=[];
  List <Color> colors =<Color>[Colors.green, Colors.red,Colors.greenAccent,];
  List <String> productSizes=['S','M','L'];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  Container(
                    height: size.width*.55 ,
                    decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        image: DecorationImage(image: AssetImage("assets/images/ps4_console_white_1.png",)),
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),

                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: size.width*.02,left: size.width*.02,right: size.width*.02,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: size.width*.3,
                            child: Text('White traditional long dress',style: TextStyle(color: Colors.black),)),

                        Column(
                          children: [
                            Text('\$ 3.99',style: TextStyle(color: Colors.red)),
                            Text('\$ 5.99',style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      ],),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: size.width*.02,left: size.width*.02,right: size.width*.02,bottom: size.width*.02 ),

                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: size.width*.07,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: (){

                                      if(selectedColor.contains(index)){
                                        setState(() {
                                          selectedColor.remove(index);
                                        });

                                      }else {
                                        setState(() {
                                          selectedColor.add(index);
                                        });


                                      }

                                    },
                                    child: selectedColor.contains(index)? Icon(Icons.circle_outlined,color: Colors.pink,):Icon(Icons.circle_outlined,color: colors[index],),
                                  );
                                },
                              ),
                            ),
                            Container(
                              height: size.width*.07,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: InkWell(
                                        onTap: (){

                                          if(selectedSize.contains(index)){
                                            setState(() {
                                              selectedSize.remove(index);
                                            });

                                          }else {
                                            setState(() {
                                              selectedSize.add(index);
                                            });
                                          }
                                        },
                                        child:  Container(
                                            height: size.width*.05,
                                            width: size.width*.05,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(width: 1,color:selectedSize.contains(index)? Colors.pink:Colors.grey)
                                            ),

                                            child: Center(child: Text(productSizes[index])))),
                                  );

                                },
                              ),
                            ),

                          ],),
                        Row(
                          children: [
                            Icon(Icons.star_border),
                            Text('4.8')
                          ],),
                      ],
                    ),
                  ),



                ],
              ),
            ),

            Positioned(

                right: 15,
                top: 15,

                child: Icon(Icons.add_circle_outline)),
          ],
        )

      ],);
  }
}



