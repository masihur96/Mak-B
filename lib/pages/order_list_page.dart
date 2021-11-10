import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/widgets/order_list_tile.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Lists',style: TextStyle(color: Colors.black),),
      ),
      body: _bodyUI(size),
    );
  }

  Widget _bodyUI(Size size)=>ListView.builder(
    physics: BouncingScrollPhysics(),
    itemCount: userController.productOrderList.length,
    itemBuilder: (context, index){
      return OrderHistoryTile(product: userController.productOrderList[index]);
    },
  );
}
