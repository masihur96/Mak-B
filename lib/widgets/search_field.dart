import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mak_b/pages/search_page.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/variables/size_config.dart';

class SearchField extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        Get.to(()=>SearchPage());
      },
      child: Container(
        width: size.width * 0.72,
        decoration: BoxDecoration(
          color: kSecondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
        ),
         child: Padding(
           padding: const EdgeInsets.all(5.0),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Icon(Icons.search,color:Colors.grey[600],),
               Text("What would you like to buy",style:TextStyle(color:Colors.grey[600],fontSize: size.width*.037),)
             ],
           ),
         )
        // TextField(
        //   // onChanged: (value) => print(value),
        //   decoration: InputDecoration(
        //       contentPadding: EdgeInsets.symmetric(
        //           horizontal: getProportionateScreenWidth(20),
        //           vertical: getProportionateScreenWidth(6)),
        //       border: InputBorder.none,
        //       focusedBorder: InputBorder.none,
        //       enabledBorder: InputBorder.none,
        //       hintText: "What would you like to buy",
        //       hintStyle: TextStyle(fontSize: size.width*.037),
        //       prefixIcon: Icon(Icons.search)),
        // ),
      ),
    );
  }
}
