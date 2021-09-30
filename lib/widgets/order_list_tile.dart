import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class OrderHistoryTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.width*.03,horizontal: size.width*.03),
      margin: EdgeInsets.only(top: size.width*.03,left: size.width*.03,right: size.width*.03),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey, offset: Offset(0, 1), blurRadius: 5.0)
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  //text: 'Hello ',
                    style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: size.width*.038,
                    fontFamily: "ZillaSlab"),
                    children: <TextSpan>[
                      TextSpan(text: 'Order No: '),
                      TextSpan(text: "#76435832\n",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.green)),
                      TextSpan(text: 'Order Status: '),
                      TextSpan(text: "Processing",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.blue)),
                    ]
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Payment Status",
                      style: TextStyle(color: Colors.grey,fontSize: size.width*.04,fontStyle: FontStyle.italic,fontFamily: "ZillaSlab")),
                  Text("Paid",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: size.width*.038)),
                ],
              )
            ],
          ),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              //text: 'Hello ',
                style: TextStyle(fontSize: size.width*.038,color: Colors.grey.shade800,fontFamily: "ZillaSlab"),
                children: <TextSpan>[
                  TextSpan(text: '\nPlaced on ',style: TextStyle(fontWeight: FontWeight.w500)),
                  TextSpan(text: DateFormat('dd-MMM-yyyy, hh:mm aa').format(DateTime.now())),
                ]
            ),
          ),
          //SizedBox(height: size.width * .02),

          ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index)=>
                _productTile(size),
          ),
        ],
      ),
    );
  }

  Widget _productTile(Size size)=>Container(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Image Container
            Container(
              height: size.width * .25,
              width: size.width * .25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: CachedNetworkImage(
                  imageUrl: 'https://loremflickr.com/640/360',
                  placeholder: (context, url) => Image.asset('assets/images/shoes_2.png'),
                  errorWidget: (context, url, error) => Icon(Icons.error,color: Colors.grey),
                  height: size.width * .18,
                  width: size.width * .18,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                padding:EdgeInsets.only(top: 5, bottom: 5,left: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///Name Container
                    Text(
                      'Adorable Cat',
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: size.width*.038,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: size.width*.01),
                    Text(
                      'Price: 23\$',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: size.width*.035,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400),
                    ),

                    Row(
                      children: [
                        Text(
                          'Size: ',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: size.width*.035,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                        Text('M',style: TextStyle(fontSize: size.width*.035)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Color: ',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: size.width*.035,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                        Text('Green',style: TextStyle(fontSize: size.width*.035)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
