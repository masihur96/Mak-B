import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mak_b/controller/auth_controller.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/pages/change_password.dart';
import 'package:mak_b/pages/deposite_page.dart';
import 'package:mak_b/pages/edit_profile.dart';
import 'package:mak_b/pages/insaurance.dart';
import 'package:mak_b/pages/my_store_page.dart';
import 'package:mak_b/pages/order_list_page.dart';
import 'package:mak_b/pages/refferred_people.dart';
import 'package:mak_b/pages/withdrow_page.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:mak_b/widgets/notification_widget.dart';

class AccountNav extends StatefulWidget {
  const AccountNav({Key? key}) : super(key: key);

  @override
  _AccountNavState createState() => _AccountNavState();
}

class _AccountNavState extends State<AccountNav> {
  final AuthController authController=Get.find<AuthController>();
  final UserController userController=Get.find<UserController>();

  double _animatedContainerHeight = 0.0;
  File? uploadImage;
  bool icon=false;

  Future<void> chooseImage() async {
    var choosedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      uploadImage = File(choosedImage!.path);
      icon=true;
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setState(() {
      _animatedContainerHeight = size.width * .26;
    });
    return SafeArea(child: Scaffold(body: _bodyUI(size)));
  }

  Widget _bodyUI(Size size) {
    return Container(
      height: size.height,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: size.width,
                height: size.height * .3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0198DD), Color(0xFF19B52B)],
                  ),
                ),

              ),
              Positioned(
                bottom: -size.width * .4,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * .04)),
                  color: Colors.white,
                  child: Container(
                    width: size.width * .85,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.width * .06,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                uploadImage == null
                                    ?userController.user.imageUrl==null?CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    radius: size.width * .18,
                                    backgroundImage: AssetImage(
                                        'assets/images/profile_image_demo.png'))
                                    :userController.user.imageUrl==''?CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    radius: size.width * .18,
                                    backgroundImage: AssetImage(
                                        'assets/images/profile_image_demo.png'))
                                    : CachedNetworkImage(
                                  imageUrl: userController.user.imageUrl!,
                                  imageBuilder: (context, imageProvider) => Container(
                                    width: size.width*.45,
                                    height: size.width*.35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider, fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) => CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      radius: size.width * .18,
                                      backgroundImage: AssetImage(
                                          'assets/images/profile_image_demo.png')),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                )
                                    : CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    radius: size.width * .18,
                                    backgroundImage: FileImage(uploadImage!)),
                                Positioned(
                                  right: 5,
                                  bottom: 0,
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                          primary: kPrimaryColor,
                                            backgroundColor: Color(0xFFF5F6F9),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50),
                                            side: BorderSide(color: Colors.white),
                                          ),
                                        ),
                                      onPressed: () {
                                        chooseImage();
                                      },
                                      child: Icon(Icons.camera_alt_outlined)
                                    ),
                                  ),
                                )
                              ],
                            ),
                            icon==false
                                ? Container()
                                : IconButton(
                              icon: Icon(Icons.update_outlined),
                              onPressed: () async{
                                await authController.updatePhoto(uploadImage!);
                                setState(() {
                                  icon = false;
                                });
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.width * .04,
                        ),
                        Container(
                          width: size.width * .85,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              left: size.width * .04, right: size.width * .04),
                          child: Text(
                            userController.user.name??'',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: size.width * .07),
                          ),
                        ),
                        SizedBox(
                          height: size.width * .04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: size.width * .15,
                                height: size.width * .15,
                                child: Image.asset(
                                    'assets/images/silver_badge.jpg')),
                            SizedBox(width: size.width * .04),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rank',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width * .04),
                                ),
                                Text(
                                  'Level: ${userController.user.level??''}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w400,
                                      fontSize: size.width * .04),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.width * .04,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: size.width * .38),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * .04,
                right: size.width * .04,
                top: size.width * .04),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size.width * .04)),
              color: Colors.white,
              child: Container(
                width: size.width * .85,
                padding: EdgeInsets.all(size.width * .04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'USER INFO',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * .04,
                              fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: (){
                            Get.to(()=>EditProfile());
                          },
                            child: Icon(Icons.edit,color: Colors.redAccent,size: 22,))
                      ],
                    ),
                    SizedBox(
                      height: size.width * .04,
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.passport,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: size.width * .04,
                        ),
                        Text(
                          userController.user.nbp??'',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * .04,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.width * .03,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: size.width * .04,
                        ),
                        Text(
                          userController.user.phone??'',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * .04,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.width * .03,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: size.width * .04,
                        ),
                        Text(
                          userController.user.address??'',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * .04,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: size.width * .02),


          Container(
            width: size.width * .85,
            padding: EdgeInsets.all(size.width * .04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Refer Code',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width * .05,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: size.width * .04,
                ),
                Text(
                  userController.user.referCode??'',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * .04,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.width * .02),

          _functionBuilder('Referred People', Icons.people, size),
          _functionBuilder('My Store', Icons.store, size),
          _functionBuilder('My Order', Icons.shopping_basket, size),
          _functionBuilder('Insurance', Icons.account_balance_wallet, size),
          _functionBuilder('Deposit', Icons.credit_card, size),
          _functionBuilder('Withdraw', Icons.monetization_on_outlined, size),
          _functionBuilder('Change Password', Icons.lock_open, size),
        ],
      ),
    );
  }

  Column _functionBuilder(String title, IconData iconData, Size size)=>Column(
    children: [
      ListTile(
        onTap: (){
          Get.to((){
            if(title=='Referred People') return RefferredPeople();
              else if(title=='My Store') return MyStorePage();
              else if(title=='My Order') return OrderListPage();
              else if(title=='Insurance') return Insaurance();
              else if(title=='Deposit') return DepositePage();
              else if(title=='Change Password') return ChangePassword();
              else return WithDrawPage();
          });
        },
        leading: Icon(iconData),
        title: Text(
          title,
          style: TextStyle(
              color: Colors.black,
              fontSize: size.width * .04,
              fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.chevron_right),
      ),
      Container(
        width: size.width,
        child: Divider(
          color: Colors.grey.shade300,
          thickness: size.width * .001,
        ),
      ),
    ],
  );
}
