import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mak_b/controller/user_controller.dart';
import 'package:mak_b/models/advertisement_model.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AdvertisementController extends GetxController{


  RxList<AdvertisementModel> videoList =<AdvertisementModel>[].obs;


   @override // called when you use Get.put before running app
  void onInit() {
    super.onInit();
    getVideo();
  }

  Future<void> getVideo()async{

     print('Initialize');
    try{
      await FirebaseFirestore.instance.collection('Advertisement').get().then((snapShot){
        videoList.clear();
      //  showLoadingDialog(Get.context!);
        snapShot.docChanges.forEach((element) {
          AdvertisementModel advertisementModel=AdvertisementModel(
            id: element.doc['id'],
            title: element.doc['title'],
            videoUrl: element.doc['videoUrl'],
            date: element.doc['date'],
          );
          videoList.add(advertisementModel) ;
        });
    //    Get.back();
        print('Video Length: ${videoList.length}');
      });
      update();
    }catch(error){
      print('Error from Video:$error');
    }
  }


  String userMainBalance='';
  String watchDate='';
  String videoWatched='';

  Future<void> getSingleUserData(String id)async{
    try {

      var document = await FirebaseFirestore.instance.collection('Users').doc(id).get();

      // ignore: unnecessary_statements
      userMainBalance = document['mainBalance'];
      watchDate = document['watchDate'];
      videoWatched = document['videoWatched'];

    }catch(error){
      print('get Single User Name: $error');
    }
  }

  Future<void> updateAddAmount()async {
    final UserController userController=Get.find<UserController>();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('Submit Data Into Firebase');

 //   print(currentDate);
    var  id = preferences.get('id');
    print(id);

    try{
      getSingleUserData(id.toString()).then((value) async{
        String currentDate='${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
        if(watchDate ==currentDate ){
          showToast('You have finished watching videos for today');

        }else {

          await FirebaseFirestore.instance.collection('Users').doc(id.toString()).update({
            "videoWatched": '5',
            "watchDate": currentDate,
            "mainBalance": '${int.parse(userMainBalance)+5}',
          }).then((value) async{
            await userController.getUser(id.toString());
           //  Get.back();
          });
        }
      });
    }catch (err){

      print(err);

    }

  }


  // Future<void> getAdvertisementData(var id)async{
  //   try{
  //     await FirebaseFirestore.instance.collection('Users').doc(id).get().then((snapShot){
  //       _cartList.clear();
  //       _productIdList.clear();
  //       total=0.obs;
  //       totalProfitAmount=0.obs;
  //       snapShot.docChanges.forEach((element) {
  //         Cart cart=Cart(
  //             id: element.doc['id'],
  //             productName: element.doc['productName'],
  //             productId: element.doc['productId'],
  //             productImage: element.doc['productImage'],
  //             price: element.doc['price'],
  //             quantity: element.doc['quantity'],
  //             color: element.doc['color'],
  //             size: element.doc['size'],
  //             profitAmount: element.doc['profitAmount']
  //         );
  //         _cartList.add(cart) ;
  //         _productIdList.add(cart.productId!);
  //         total=total+(int.parse(cart.price!)*cart.quantity!);
  //         totalProfitAmount=totalProfitAmount+int.parse(cart.profitAmount!)*cart.quantity!;
  //       });
  //       print('ProductId${_productIdList.length}');
  //       print(total);
  //     });
  //   }catch(error){
  //     print(error);
  //   }
  // }


}
