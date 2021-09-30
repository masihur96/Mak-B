import 'package:flutter/material.dart';
import 'package:mak_b/widgets/order_list_tile.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Lists'),
      ),
      body: _bodyUI(size),
    );
  }

  Widget _bodyUI(Size size)=>ListView.builder(
    physics: BouncingScrollPhysics(),
    itemCount: 50,
    itemBuilder: (context, index){
      return OrderHistoryTile();
    },
  );
}
