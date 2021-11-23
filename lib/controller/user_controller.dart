import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mak_b/controller/auth_controller.dart';
import 'package:mak_b/models/Cart.dart';
import 'package:mak_b/models/check_first_user_model.dart';
import 'package:mak_b/models/info_model.dart';
import 'package:mak_b/models/package_model.dart';
import 'package:mak_b/models/product_order_model.dart';
import 'package:mak_b/models/refered_list_model.dart';
import 'package:mak_b/models/set_rate_model.dart';
import 'package:mak_b/models/user_model.dart';
import 'package:mak_b/models/deposit_model.dart';
import 'package:mak_b/models/watch_history_model.dart';
import 'package:mak_b/models/withdraw_model.dart';
import 'package:mak_b/pages/login_page.dart';
import 'package:mak_b/pages/my_store_page.dart';
import 'package:mak_b/widgets/notification_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_nav.dart';

class UserController extends AuthController {
  RxInt total=0.obs;
  RxInt totalProfitAmount=0.obs;
  RxList<String> _productIds = RxList<String>([]);
  RxList<Cart> _cartList = RxList<Cart>([]);
  Rx<UserModel> userModel = UserModel().obs;
  Rx<CheckFirstUserModel> checkUserModel = CheckFirstUserModel().obs;
  Rx<UserModel> referUserModel = UserModel().obs;
  Rx<WithDrawModel> withdrawModel = WithDrawModel().obs;
  RxList<WithDrawModel> withdrawHistory = <WithDrawModel>[].obs;
  RxList<ReferredList> referredList = <ReferredList>[].obs;
  Rx<DepositModel> depositModel = DepositModel().obs;
  RxList<DepositModel> depositList = <DepositModel>[].obs;
  RxList<WatchHistoryModel> watchHistoryList = <WatchHistoryModel>[].obs;
  Rx<bool> isReferCodeCorrect = false.obs;
  Rx<RateModel> rateData = RateModel().obs;
  RxList<PackageModel> storePackageList = <PackageModel>[].obs;
  RxList<ProductOrderModel> productOrderList = <ProductOrderModel>[].obs;
  RxList<ContactInfoModel> infoList = <ContactInfoModel>[].obs;
  get cartList => _cartList;
  get productIds => _productIds;

  String? id;

  Future<void> _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.get('id') as String?;
  }

  @override // called when you use Get.put before running app
  void onInit() {
    super.onInit();
    _checkPreferences();
  }

  // set user(UserModel value){
  //   this.userModel.value = value;
  // }
  // UserModel get user => userModel.value;
  // UserModel get referUser => _referUserModel.value;
  //
  // set withDrawModel(WithDrawModel value){
  //   this._withdrawModel.value = value;
  // }
  // WithDrawModel get withDraw => _withdrawModel.value;
  // get withdrawHistory => _withdrawHistory;
  //
  // set depositModel(DepositModel value){
  //   this._depositModel.value = value;
  // }
  // DepositModel get depositModel => _depositModel.value;
  // get depositList => _depositList;
  // get referredList => _referredList;

  void clear() {
    userModel.value = UserModel();
  }

  /// get User Edited
  Future<void> getUser(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .get()
          .then((snapShot) {
        UserModel user = UserModel(
          id: snapShot['id'],
          name: snapShot['name'],
          address: snapShot['address'],
          phone: snapShot['phone'],
          password: snapShot['password'],
          nbp: snapShot['nbp'],
          email: snapShot['email'],
          zip: snapShot['zip'],
          referCode: snapShot['referCode'],
          timeStamp: snapShot['timeStamp'],
          referDate: snapShot['referDate'],
          imageUrl: snapShot['imageUrl'],
          //referredList: snapShot['referredList'],
          numberOfReferred: snapShot['numberOfReferred'],
          insuranceEndingDate: snapShot['insuranceEndingDate'],
          depositBalance: snapShot['depositBalance'],
          //depositHistory: snapShot['depositHistory'],
          //withdrawHistory: snapShot['withdrawHistory'],
          insuranceBalance: snapShot['insuranceBalance'],
          lastInsurancePaymentDate: snapShot['lastInsurancePaymentDate'],
          level: snapShot['level'],
          insuranceWithDraw: snapShot['insuranceWithDraw'],
          mainBalance: snapShot['mainBalance'],
          videoWatched: snapShot['videoWatched'],
          watchDate: snapShot['watchDate'],
          myStore: snapShot['myStore'],
          myOrder: snapShot['myOrder'],
          //cartList: snapShot['cartList'],
          referLimit: snapShot['referLimit'],
        );
        userModel.value = user;
      });
      update();
    } catch (error) {
      print("getting user error: $error");
    }
  }

  /// withdraw section
  Future<void> getWithDrawHistory(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .collection('WithdrawHistory')
          .orderBy('date', descending: true)
          .get()
          .then((snapShot) {
        withdrawHistory.clear();
        snapShot.docChanges.forEach((element) {
          WithDrawModel withDrawModel = WithDrawModel(
            id: element.doc['id'],
            name: element.doc['name'],
            phone: element.doc['phone'],
            image: element.doc['imageUrl'],
            date: element.doc['date'],
            amount: element.doc['amount'],
            status: element.doc['status'],
            transactionSystem: element.doc['transactionSystem'],
            transactionMobileNo: element.doc['transactionMobileNo'],
          );
          withdrawHistory.add(withDrawModel);
        });
        print(withdrawHistory.length);
      });
      update();
    } catch (error) {
      print("getting withdraw history error: $error");
    }
  }

  Future<void> withdraw(String transactionSystem, String transactionMobileNo,
      String amount, String name, dynamic due, String image) async {
    await _checkPreferences();
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    String withdrawId = "$id$date";
    try {
      print(withdrawId);
      showLoadingDialog(Get.context!);
      await getUser(id!);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .collection('WithdrawHistory')
          .doc(withdrawId)
          .set({
        "id": id.toString(),
        "date": date,
        "phone": id.toString(),
        "name": name,
        "imageUrl": image,
        "amount": amount,
        "status": 'pending',
        "withdrawId": withdrawId,
        "transactionSystem": transactionSystem,
        "transactionMobileNo": transactionMobileNo,
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('WithdrawRequests')
            .doc(withdrawId)
            .set({
          "id": id,
          "phone": id,
          "name": name,
          "imageUrl": image,
          "date": date,
          "amount": amount,
          "status": 'pending',
          "withdrawId": withdrawId,
          "transactionSystem": transactionSystem,
          "transactionMobileNo": transactionMobileNo,
        }).then((value) async {
          await FirebaseFirestore.instance.collection('Users').doc(id).update({
            "lastInsurancePaymentDate": date,
            "insuranceBalance": (int.parse(userModel.value.insuranceBalance!) + due).toString(),
            "mainBalance": (int.parse(userModel.value.mainBalance!) - int.parse(amount)).toString()
          }).then((value) async {
            await getWithDrawHistory(id!).then((value) async {
              await getUser(id!).then((value) {
                Get.back();
                showToast('Request Sent  for withdraw');
              });
            });
          });
        });
      });
      update();
    } catch (error) {
      print("Withdraw failed: $error");
    }
  }

  /// deposit section

  Future<void> depositBalance(String amount, dynamic depositBalance,
      dynamic mainBalance, String name, String phone) async {
    await _checkPreferences();
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    String depositId = "$id$date";
    try {
      showLoadingDialog(Get.context!);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .collection('DepositHistory')
          .doc(depositId)
          .set({
        "depositId": depositId,
        "name": name,
        "phone": phone,
        "date": date,
        "amount": amount,
        "status": "transferred",
        "userId" : phone
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('DepositRequests')
            .doc(depositId)
            .set({
          "depositId": depositId,
          "name": name,
          "phone": phone,
          "date": date,
          "amount": amount,
          "status": "transferred",
          "userId" : phone
        }).then((value) async {
          await FirebaseFirestore.instance.collection('Users').doc(id).update({
            "depositBalance": '$depositBalance',
            "mainBalance": '$mainBalance'
          }).then((value) async {
            await getDepositHistory(id!).then((value) async {
              await getUser(id!).then((value) {
                Get.back();
                showToast('Balance deposited');
              });
            });
          });
        });
      });
      update();
    } catch (error) {
      print("transferred deposit balance error: $error");
    }
  }

  Future<void> depositRequest(String name, String phone) async {
    await _checkPreferences();
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    String depositId = "$id$date";
    try {
      showLoadingDialog(Get.context!);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .collection('DepositHistory')
          .doc(depositId)
          .set({
        "depositId": depositId,
        "name": name,
        "phone": phone,
        "date": date,
        "amount": '',
        "status": 'pending',
        "userId" : phone
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('DepositRequests')
            .doc(depositId)
            .set({
          "depositId": depositId,
          "name": name,
          "phone": phone,
          "date": date,
          "amount": '',
          "status": 'pending',
          "userId" : phone
        }).then((value) async {
          await getDepositHistory(id!).then((value) async {
            await getUser(id!).then((value) {
              Get.back();
            });
          });
        });
      });
      update();
    } catch (error) {
      print("pending deposit balance error: $error");
    }
  }

  Future<void> getDepositHistory(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .collection('DepositHistory').orderBy('date',descending: true)
          .get()
          .then((snapShot) {
        depositList.clear();
        snapShot.docChanges.forEach((element) {
          DepositModel depositModel = DepositModel(
            depositId: element.doc['depositId'],
            name: element.doc['name'],
            phone: element.doc['phone'],
            date: element.doc['date'],
            amount: element.doc['amount'],
            status: element.doc['status'],
          );
          depositList.add(depositModel);
        });
        print(depositList.length);
      });
      update();
    } catch (error) {
      print("getting deposit history error: $error");
    }
  }

  Future<void> insuranceWithDraw(String name, String phone,String insuranceAmount) async {
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    String insuranceId = "$id$date";
    try {
      showLoadingDialog(Get.context!);
        await FirebaseFirestore.instance
            .collection('InsuranceWithDrawRequest')
            .doc(insuranceId)
            .set({
          "insuranceId": insuranceId,
          "name": name,
          "phone": phone,
          "date": date,
          "amount": insuranceAmount,
          "status": 'pending',
          "userId" : phone
        }).then((value) async {
              Get.back();
            });

      update();
    } catch (error) {
      print("Insurance request error: $error");
    }
  }

  /// user info settings
  Future<void> updatePhoto(File imageFile) async {
    showLoadingDialog(Get.context!);
    try {
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('User Photo')
          .child(id!);

      firebase_storage.UploadTask storageUploadTask =
          storageReference.putFile(imageFile);

      firebase_storage.TaskSnapshot taskSnapshot;
      storageUploadTask.then((value) {
        taskSnapshot = value;
        taskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl) {
          final photoUrl = newImageDownloadUrl;
          FirebaseFirestore.instance.collection('Users').doc(id).update({
            "imageUrl": photoUrl,
          });
        }).then((value) async {
          await getUser(id!);
          Get.back();
          showToast('Photo Updated');
        });
      });
    } catch (e) {
      Get.back();
      print(e.toString());
      showToast('Something went wrong');
    }
  }

  Future<void> updateProfile(String name, String address, String phone,
      String nbp, String email, String zip) async {
    showLoadingDialog(Get.context!);
    await FirebaseFirestore.instance.collection('Users').doc(id).update({
      "name": name,
      "address": address,
      "phone": phone,
      "nbp": nbp,
      "email": email,
      "zip": zip,
    }).then((value) async {
      await getUser(id!);
      Get.back();
      Get.back();
      showToast('Profile Updated');
    });
  }

  Future<void> updateBalance(String profitAmount) async {
    await getUser(id!);
    double amount=double.parse(userModel.value.mainBalance!)+double.parse(profitAmount);
    await FirebaseFirestore.instance.collection('Users').doc(id).update({
      "mainBalance": '$amount',
    }).then((value) async {
      await getUser(id!);
    });
  }

  Future<void> updateInsuranceWithDraw() async {
    showLoadingDialog(Get.context!);
    await FirebaseFirestore.instance.collection('Users').doc(id).update({
      "insuranceWithDraw": true,
    }).then((value) async {
      await getUser(id!);
      Get.back();
      Get.back();
      showToast('Request sent to withdraw insurance balance');
    });
  }

  Future<void> changePassword(String newPass) async {
    try {
      showLoadingDialog(Get.context!);
      await FirebaseFirestore.instance.collection('Users').doc(id).update({
        "password": newPass,
      }).then((value) async {
        await getUser(id!);
        Get.back();
        Get.back();
        showToast('Password Changed');
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> recoverPassword(String newPass, String phone) async {
    try {
      showLoadingDialog(Get.context!);
      await FirebaseFirestore.instance.collection('Users').doc(phone).update({
        "password": newPass,
      }).then((value) {
        Get.back();
        Get.offAll(() => LoginPage());
        showToast('Password Recovered');
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getReferUser(String referCode) async {
    print("get refer called");
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .where('referCode', isEqualTo: referCode)
          .get()
          .then((snapShot) {
        if (snapShot.docs.length == 0) {
          isReferCodeCorrect.value = false;
          Get.back();
          showToast("Incorrect refer code!");
        }
        snapShot.docChanges.forEach((element) {
          UserModel user = UserModel(
            phone: element.doc['phone'],
            referCode: element.doc['referCode'],
            referLimit: element.doc['referLimit'],
            mainBalance: element.doc['mainBalance']
          );
          isReferCodeCorrect.value = true;
          referUserModel.value = user;
        });
        print(referUserModel.value.mainBalance);
      });
      update();
    } catch (error) {
      print("getting refer user failed: $error");
    }
  }

  Future<void> getReferUserReferList(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .collection('referredList')
          .get()
          .then((snapShot) {
        referredList.clear();
        snapShot.docChanges.forEach((element) {
          ReferredList referredLst = ReferredList(
            id: element.doc['id'],
            name: element.doc['name'],
            phone: element.doc['phone'],
            date: element.doc['date'],
            referCode: element.doc['referCode'],
            profit: element.doc['profit'],
          );
          referredList.add(referredLst);
        });
        print(referredList.length);
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> getRate()async{
    try{
      await FirebaseFirestore.instance.collection('SetRate').get().then((snapShot){
        snapShot.docChanges.forEach((element) {
          RateModel rateModel=RateModel(
            serviceCharge: element.doc['serviceCharge'],
            videoRate: element.doc['videoRate'],
            date: element.doc['date'],
          );
          rateData.value=rateModel ;
        });

        print(rateData.value.serviceCharge);
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> addStoreProduct(String packageId,String productName, dynamic productPrice,List<dynamic> images,
      List<dynamic>colors,List<dynamic>sizes,String desc,String thumbnail,String discount,String quantity) async {
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    String ids = "$id$date";
    try {
      showLoadingDialog(Get.context!);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .collection('MyStore')
          .doc(ids)
          .set({
        "id": ids,
        "packageId": packageId,
        "productName": productName,
        "productPrice": productPrice,
        "discount": discount,
        "description":desc,
        "thumbnail":thumbnail,
        "quantity": quantity,
        "date": date,
        "imageUrl":images,
        "colors":colors,
        "sizes":sizes,
        "status": "stored",
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('SoldPackages')
            .doc(ids)
            .set({
          "id": ids,
          "userName": userModel.value.name,
          "userPhone": userModel.value.phone,
          "userAddress":userModel.value.address,
          "packageId": packageId,
          "productName": productName,
          "productPrice": productPrice,
          "discount": discount,
          "description":desc,
          "thumbnail":thumbnail,
          "quantity": quantity,
          "date": date,
          "imageUrl":images,
          "colors":colors,
          "sizes":sizes,
          "status": "stored",
        }).then((value) async {
            await getMyStore().then((value) async {
                Get.back();
                Get.to(()=>HomeNav());
                showToast('Package stored');
              });
            });
          });
      update();
    } catch (error) {
      print("package error: $error");
    }
  }

  Future<void> getMyStore() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .collection('MyStore')
          .get()
          .then((snapShot) {
        storePackageList.clear();
        snapShot.docChanges.forEach((element) {
          PackageModel model = PackageModel(
            documentId: element.doc['id'],
            id: element.doc['packageId'],
            title: element.doc['productName'],
            date: element.doc['date'],
            price: element.doc['productPrice'],
            status: element.doc['status'],
            description: element.doc['description'],
            thumbNail: element.doc['thumbnail'],
            discountAmount: element.doc['discount'],
            size: element.doc['sizes'],
            colors: element.doc['colors'],
            image: element.doc['imageUrl'],
            quantity: element.doc['quantity'],
          );
          storePackageList.add(model);
        });
        print('jj${storePackageList.length}');
      });
      update();
    } catch (error) {
      print("getting deposit history error: $error");
    }
  }

  Future<void> updateReferUser(String phone,String profit)async {
    await getReferUserReferList(phone);
    int referred=referredList.length+1;
    await FirebaseFirestore.instance.collection('Users').doc(phone).update({
      "mainBalance": profit,
      "numberOfReferred": '$referred',
      "level": '$referred',
    });
  }

  Future<void> addReferUserReferList(String referPhone,String referCode,String name,String profit,String userPhone)async{
    await FirebaseFirestore.instance.collection('Users').doc(referPhone).collection('referredList').
    doc('$userPhone').set({
      "id": referPhone,
      "date":'${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      "phone":userPhone,
      "name":name,
      "referCode":referCode,
      "profit":profit
    });
  }

  Future<void> getProductOrder()async{
    try{
      await FirebaseFirestore.instance.collection('Orders').where('phone',isEqualTo: id).orderBy('orderNumber',descending: true).get().then((snapShot){
        productOrderList.clear();
        snapShot.docChanges.forEach((element) {
          ProductOrderModel productOrderModel =ProductOrderModel(
              id: element.doc['id'],
              Area: element.doc['Area'],
              hub: element.doc['hub'],
              name: element.doc['name'],
              orderDate: element.doc['orderDate'],
              orderNumber: element.doc['orderNumber'],
              phone: element.doc['phone'],
              products: element.doc['products'],
              quantity: element.doc['quantity'],
              state: element.doc['state'],
              totalAmount: element.doc['totalAmount']
          );
          productOrderList.add(productOrderModel) ;
        });
        print('Product Order  List: ${productOrderList.length}');
      });
    }catch(error){
      print(error);
    }
  }


  Future<void> requestForPackageCollection(String idd,String packageId,String name, dynamic price,List<dynamic> images,
      List<dynamic>colors,List<dynamic>sizes,String discount,String thumbnail,String quantity) async {
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      showLoadingDialog(Get.context!);
        await FirebaseFirestore.instance
            .collection('PackageCollectionRequest')
            .doc(idd)
            .set({
          "id": idd,
          "userName": userModel.value.name,
          "userPhone": userModel.value.phone,
          "userAddress":userModel.value.address,
          "packageId": packageId,
          "productName": name,
          "productPrice": price,
          "discount": discount,
          "quantity": quantity,
          "date": date,
          "imageUrl":images,
          "thumbnail":thumbnail,
          "colors":colors,
          "sizes":sizes,
          "status": "pending",
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(id)
              .collection('MyStore').doc(idd).update({
              "status": 'pending',
          }).then((value)async{
            await FirebaseFirestore.instance.collection('SoldPackages').doc(idd).update({
              "status": 'pending',
            }).then((value)async{
              await getMyStore().then((value) async {
                Get.back();
                Get.to(()=>HomeNav());
                showToast('Request sent for package collection');
              });
            });
          });
        });
      update();
    } catch (error) {
      print("package error: $error");
    }
  }


  Future<void> addToUserCart(String productName,String thumbnail,String productId,String price,int quantity,String color,String size,String image,String profitAmount)async {
    await _checkPreferences();
    try{
      showLoadingDialog(Get.context!);
      await FirebaseFirestore.instance.collection('Users').doc(id).collection('CartList').doc(productId).set({
        "id": DateTime.now().millisecondsSinceEpoch,
        "productName": productName,
        "productId": productId,
        "productImage":image,
        "thumbnail":thumbnail,
        "price": price,
        "quantity": quantity,
        "color":color,
        "size": size,
        "profitAmount":profitAmount
      }).then((value)async{
        await getUserCart();
        Get.back();
        showToast('Product added to cart');
      });
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> getUserCart()async{
    try{
      await FirebaseFirestore.instance.collection('Users').doc(id).collection('CartList').get().then((snapShot){
        _cartList.clear();
        _productIds.clear();
        total=0.obs;
        totalProfitAmount=0.obs;
        snapShot.docChanges.forEach((element) {
          Cart cart=Cart(
              id: element.doc['id'],
              productName: element.doc['productName'],
              productId: element.doc['productId'],
              productImage: element.doc['productImage'],
              thumbnail: element.doc['thumbnail'],
              price: element.doc['price'],
              quantity: element.doc['quantity'],
              color: element.doc['color'],
              size: element.doc['size'],
              profitAmount: element.doc['profitAmount']
          );
          _cartList.add(cart) ;
          _productIds.add(cart.productId!);
          total=total+(int.parse(cart.price!)*cart.quantity!);
          totalProfitAmount=totalProfitAmount+int.parse(cart.profitAmount!)*cart.quantity!;
        });
        print('ProductId${_productIds.length}');
        print(totalProfitAmount);
        print(total);
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> updateUserCart(String productId,int quantity)async {
    showLoadingDialog(Get.context!);
    await FirebaseFirestore.instance.collection('Users').doc(id).collection('CartList').doc(productId).update({
      "quantity": quantity,
    }).then((value)async{
      await getUserCart();
      Get.back();
    });
  }
  Future<void> deleteUserCartItem(String productId)async {
    showLoadingDialog(Get.context!);
    await FirebaseFirestore.instance.collection('Users').doc(id).collection('CartList').doc(productId).delete().then((value)async{
      await getUserCart();
      Get.back();
      Get.back();
      showToast('Product deleted from cart');
    });
  }

  Future<void> deleteUserCart()async {
    await FirebaseFirestore.instance.collection('Users').doc(id).collection('CartList').get().then((value){
      value.docChanges.forEach((element) {
        FirebaseFirestore.instance.collection('Users')
            .doc(id)
            .collection("CartList")
            .doc(element.doc.id)
            .delete()
            .then((value)async{
          await getUserCart();
        });
      });
    });
  }

  Future<void> getFirstUser() async {
    try {
      await FirebaseFirestore.instance
          .collection('CheckFirstUser')
          .doc('12345')
          .get()
          .then((snapShot) {
        CheckFirstUserModel checkUser = CheckFirstUserModel(
          id: snapShot['id'],
          count: snapShot['count']
        );
        checkUserModel.value = checkUser;
      });
      print("checking user ");
      update();
    } catch (error) {
      print("getting user error: $error");
    }
  }

  Future<void> getWatchedHistory() async {
    await _checkPreferences();
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .collection('VideoHistory')
          .get()
          .then((snapShot) {
        watchHistoryList.clear();
        snapShot.docChanges.forEach((element) {
          WatchHistoryModel watchHistoryModel = WatchHistoryModel(
            watchDate: element.doc['watchDate'],
            videoWatched: element.doc['videoWatched'],
          );
          watchHistoryList.add(watchHistoryModel);
        });
        print(watchHistoryList.length);
      });
      update();
    } catch (error) {
      print("getting deposit history error: $error");
    }
  }

  Future<void> getContactInfo()async{
    try{
      await FirebaseFirestore.instance.collection('ContactInfo').get().then((snapShot){
        infoList.clear();
        snapShot.docChanges.forEach((element) {
          ContactInfoModel contactInfoModel = ContactInfoModel(
            email: element.doc['email'],
            phone: element.doc['phone'],
            address: element.doc['address'],
            fbLink: element.doc['fbLink'],
            youtubeLink: element.doc['youtubeLink'],
            twitterLink: element.doc['twitterLink'],
            instagram: element.doc['instagram'],
            linkedIn: element.doc['linkedIn'],
            date: element.doc['date'],
          );
          infoList.add(contactInfoModel) ;
        });
        print('Contact Info: ${infoList.length}');
      });
    }catch(error){
      print(error);
    }
  }
}
