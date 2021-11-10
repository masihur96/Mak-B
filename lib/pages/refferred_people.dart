import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:mak_b/controller/user_controller.dart';

class RefferredPeople extends StatefulWidget {
  const RefferredPeople({Key? key}) : super(key: key);

  @override
  _RefferredPeopleState createState() => _RefferredPeopleState();
}

class _RefferredPeopleState extends State<RefferredPeople> {
  final UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Refferred People',
          style: TextStyle(
            color: Colors.black,
            fontSize: size.width * .04,
          ),
        ),
      ),
      body: _bodyUI(size),
    );
  }

  Widget _bodyUI(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * .04),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
              width: size.width,
              child: Text(
                'You reffered ${userController.referredList.length} people',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * .04,
                    fontWeight: FontWeight.bold),
              )),
          SizedBox(
            height: size.width * .04,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: userController.referredList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: size.width * .02),
                  child: Card(
                    child: ListTile(
                        // leading: CircleAvatar(
                        //   backgroundColor: Colors.grey.shade200,
                        //   backgroundImage: NetworkImage(
                        //       userController.referredList[index].),
                        // ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name:  ${userController.referredList[index].name!}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width * .04,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Contact No:  ${userController.referredList[index].phone!}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width * .03,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'ReferCode:  ${userController.referredList[index].referCode!}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width * .03,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profit:  ${userController.referredList[index].profit!}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * .03,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Date:  ${userController.referredList[index].date!}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * .03,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
