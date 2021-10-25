import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mak_b/models/Cart.dart';
import 'package:mak_b/models/area_hub_model.dart';
import 'package:mak_b/models/product_model.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController{
  RxInt total=0.obs;
  RxInt totalProfitAmount=0.obs;
  RxList<ProductModel> _productList = RxList<ProductModel>([]);
  RxList<Cart> _cartList = RxList<Cart>([]);
  RxList<AreaHubModel> _areaHubList = RxList<AreaHubModel>([]);
  RxList<String> _productIdList = RxList<String>([]);
  String? id;
  String? deviceId;

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.get('id') as String? ;
    deviceId = preferences.get('deviceId') as String? ;
  }
  @override // called when you use Get.put before running app
  void onInit() {
    super.onInit();
    _checkPreferences();
  }

  get productList => _productList;
  get cartList => _cartList;
  get productIdList => _productIdList;
  get areaHubList => _areaHubList;

  Future<void> getProducts()async{
    try{
      await FirebaseFirestore.instance.collection('Products').get().then((snapShot){
        _productList.clear();
        snapShot.docChanges.forEach((element) {
          ProductModel productModel=ProductModel(
            id: element.doc['id'],
            title: element.doc['title'],
            description: element.doc['description'],
            price: element.doc['price'],
            profitAmount: element.doc['profitAmount'],
            size: element.doc['size'],
            category: element.doc['category'],
            subCategory: element.doc['subCategory'],
            colors: element.doc['colors'],
            image: element.doc['image'],
            date: element.doc['date'],
          );
          _productList.add(productModel) ;
        });
        print(_productList.length);
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> addToCart(String productName,String productId,String price,int quantity,String color,String size,String image,String profitAmount)async {
    try{
      showLoadingDialog(Get.context!);
      await FirebaseFirestore.instance.collection('Cart').doc(deviceId).collection('CartList').doc(productId).set({
        "id": DateTime.now().millisecondsSinceEpoch,
        "productName": productName,
        "productId": productId,
        "productImage":image,
        "price": price,
        "quantity": quantity,
        "color":color,
        "size": size,
        "profitAmount":profitAmount
        }).then((value)async{
          await getCart();
          Get.back();
          showToast('Product added to cart');
        });
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> getCart()async{
    try{
      await FirebaseFirestore.instance.collection('Cart').doc(deviceId).collection('CartList').get().then((snapShot){
        _cartList.clear();
        _productIdList.clear();
        total=0.obs;
        totalProfitAmount=0.obs;
        snapShot.docChanges.forEach((element) {
          Cart cart=Cart(
            id: element.doc['id'],
            productName: element.doc['productName'],
            productId: element.doc['productId'],
            productImage: element.doc['productImage'],
            price: element.doc['price'],
            quantity: element.doc['quantity'],
            color: element.doc['color'],
            size: element.doc['size'],
            profitAmount: element.doc['profitAmount']
          );
          _cartList.add(cart) ;
          _productIdList.add(cart.productId!);
          total=total+(int.parse(cart.price!)*cart.quantity!);
          totalProfitAmount=totalProfitAmount+int.parse(cart.profitAmount!)*cart.quantity!;
        });
        print('ProductId${_productIdList.length}');
        print(total);
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> updateCart(String productId,int quantity)async {
    showLoadingDialog(Get.context!);
    await FirebaseFirestore.instance.collection('Cart').doc(deviceId).collection('CartList').doc(productId).update({
      "quantity": quantity,
    }).then((value)async{
      await getCart();
      Get.back();
    });
  }
  Future<void> deleteCartItem(String productId)async {
    showLoadingDialog(Get.context!);
    await FirebaseFirestore.instance.collection('Cart').doc(deviceId).collection('CartList').doc(productId).delete().then((value)async{
      await getCart();
      Get.back();
      showToast('Product deleted from cart');
    });
  }

  Future<void> getAreaHub()async{
    try{
      await FirebaseFirestore.instance.collection('Area&Hub').get().then((snapShot){
        _areaHubList.clear();
        snapShot.docChanges.forEach((element) {
          AreaHubModel areaHubModel=AreaHubModel(
            hub: element.doc['hub'],
            id: element.doc['id'],
          );
          _areaHubList.add(areaHubModel) ;
        });
        print('Hub List${_areaHubList.length}');
      });
    }catch(error){
      print(error);
    }
  }

}