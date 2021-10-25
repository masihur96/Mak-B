import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mak_b/models/refered_list_model.dart';
import 'package:mak_b/models/user_model.dart';
import 'package:mak_b/models/deposit_model.dart';
import 'package:mak_b/models/withdraw_model.dart';

class UserController extends GetxController {
  Rx<UserModel> _userModel = UserModel().obs;
  Rx<UserModel> _referUserModel = UserModel().obs;
  Rx<WithDrawModel> _withdrawModel = WithDrawModel().obs;
  RxList<WithDrawModel> _withdrawHistory = RxList<WithDrawModel>([]);
  RxList<ReferredList> _referredList = RxList<ReferredList>([]);
  Rx<DepositModel> _depositModel = DepositModel().obs;

  RxList<DepositModel> _depositList = RxList<DepositModel>([]);


  set user(UserModel value){
    this._userModel.value = value;
  }
  UserModel get user => _userModel.value;
  UserModel get referUser => _referUserModel.value;

  set withDrawModel(WithDrawModel value){
    this._withdrawModel.value = value;
  }
  WithDrawModel get withDraw => _withdrawModel.value;
  get withdrawHistory => _withdrawHistory;

  set depositModel(DepositModel value){
    this._depositModel.value = value;
  }
  DepositModel get depositModel => _depositModel.value;
  get depositList => _depositList;
  get referredList => _referredList;

  void clear() {
    _userModel.value = UserModel();
  }

  Future<void> getUser(String id)async{
    try{
      await FirebaseFirestore.instance.collection('Users').where('id', isEqualTo: id).get().then((snapShot){
        snapShot.docChanges.forEach((element) {
          UserModel user=UserModel(
            id: element.doc['id'],
            name: element.doc['name'],
            address: element.doc['address'],
            phone: element.doc['phone'],
            password: element.doc['password'],
            nbp: element.doc['nbp'],
            email: element.doc['email'],
            zip: element.doc['zip'],
            referCode: element.doc['referCode'],
            // timeStamp: element.doc['timeStamp'],
            referDate: element.doc['referDate'],
            imageUrl: element.doc['imageUrl'],
            //referredList: element.doc['referredList'],
            numberOfReferred: element.doc['numberOfReferred'],
            insuranceEndingDate: element.doc['insuranceEndingDate'],
            depositBalance: element.doc['depositBalance'],
            //depositHistory: element.doc['depositHistory'],
            //withdrawHistory: element.doc['withdrawHistory'],
            insuranceBalance: element.doc['insuranceBalance'],
            lastInsurancePaymentDate: element.doc['lastInsurancePaymentDate'],
            level: element.doc['level'],
            mainBalance: element.doc['mainBalance'],
            videoWatched: element.doc['videoWatched'],
            watchDate: element.doc['watchDate'],
            myStore: element.doc['myStore'],
            myOrder: element.doc['myOrder'],
            //cartList: element.doc['cartList'],
            referLimit: element.doc['referLimit'],
          );
          _userModel.value=user;
        });
        print(_userModel.value.name);
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getWithDrawHistory(String id)async{
    try{
      await FirebaseFirestore.instance.collection('Users').doc(id).collection('WithdrawHistory').get().then((snapShot){
        _withdrawHistory.clear();
        snapShot.docChanges.forEach((element) {
          WithDrawModel withDrawModel=WithDrawModel(
            id: element.doc['id'],
            name: element.doc['name'],
            phone: element.doc['phone'],
            image: element.doc['imageUrl'],
            date: element.doc['date'],
            amount: element.doc['amount'],
            status: element.doc['status'],
          );
          _withdrawHistory.add(withDrawModel) ;
        });
        print(_withdrawHistory.length);
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getDepositHistory(String id)async{
    try{
      await FirebaseFirestore.instance.collection('Users').doc(id).collection('DepositHistory').get().then((snapShot){
        _depositList.clear();
        snapShot.docChanges.forEach((element) {
          DepositModel depositModel=DepositModel(
            id: element.doc['id'],
            name: element.doc['name'],
            phone: element.doc['phone'],
            date: element.doc['date'],
            amount: element.doc['amount'],
            status: element.doc['status'],
          );
          _depositList.add(depositModel) ;
        });
        print(_depositList.length);
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getReferUser(String referCode)async{
    try{
      await FirebaseFirestore.instance.collection('Users').where('referCode', isEqualTo: referCode).get().then((snapShot){
        snapShot.docChanges.forEach((element) {
          UserModel user=UserModel(
            phone: element.doc['phone'],
            referCode: element.doc['referCode'],
            referLimit: element.doc['referLimit'],
          );
          _referUserModel.value=user;
        });
        print(_referUserModel.value.name);
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getReferUserReferList(String id)async{
    try{
      await FirebaseFirestore.instance.collection('Users').doc(id).collection('referredList').get().then((snapShot){
        _referredList.clear();
        snapShot.docChanges.forEach((element) {
          ReferredList referredList=ReferredList(
            id: element.doc['id'],
            code: element.doc['code'],
          );
          _referredList.add(referredList) ;
        });
        print(_referredList.length);
      });
    }catch(error){
      print(error);
    }
  }

}