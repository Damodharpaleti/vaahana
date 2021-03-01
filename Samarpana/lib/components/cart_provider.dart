import 'package:flutter/widgets.dart';
import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/MyPayments_Model.dart';
import 'package:Samarpana/model/User_Signup_Model.dart';
import 'package:Samarpana/utils/dataBase.dart';

class CartProvider with ChangeNotifier {
// ignore: non_constant_identifier_names
  bool _isorderCreated = false;
  APIService apiService;
  List<Myorders> _mypayments;
  List<Myorders> _myDelivery;
  List<Myorders> _myCancel;
  List<Myorders> _myStatus=null;
  String moblieNumber;
  final dbHelper = DBProvider.instance;

  List<UserdatafromDB> list = new List();
  UserdatafromDB model;
  User user;
  List<Myorders> get paymentslist => _mypayments;
  List<Myorders> get deliverylist => _myDelivery;
  List<Myorders> get cancelList => _myCancel;
  List<Myorders> get pendingList => _myStatus;
  bool get isorderCreated => _isorderCreated;

  CartProvider() {
    list = new List<UserdatafromDB>();
    apiService = APIService();
  }
  fetchMypayments({String status}) async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) => {
          print(allRows),
          model = UserdatafromDB(
            row["id"].toString(),
            row["firstName"],
            row["lastName"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
          ),
          list.add(model)
        });
    print(allRows);

    String token = model.token;
    String mobileNumber = model.mobileNumber;
    List<Myorders> orderList = await apiService.myPaymentsList(
        orderstatus: status, token: token, mobileNumber: mobileNumber);
    if (_mypayments == null) {
      _mypayments = new List<Myorders>();
    }
    if (orderList.length > 0) {
      _mypayments = [];
      _mypayments.addAll(orderList);
    }
    notifyListeners();
  }

  fetchMyDelivery({String status}) async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) => {
          print(allRows),
          model = UserdatafromDB(
            row["id"].toString(),
            row["firstName"],
            row["lastName"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
          ),
          list.add(model)
        });
    print(allRows);

    String token = model.token;
    String mobileNumber = model.mobileNumber;
    List<Myorders> orderList = await apiService.myPaymentsList(
        orderstatus: status, token: token, mobileNumber: mobileNumber);
    if (_myDelivery == null) {
      _myDelivery = new List<Myorders>();
    }
    if (orderList.length > 0) {
      _myDelivery = [];
      _myDelivery.addAll(orderList);
    }
    notifyListeners();
  }

  fetchMyCancel({String status}) async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) => {
          print(allRows),
          model = UserdatafromDB(
            row["id"].toString(),
            row["firstName"],
            row["lastName"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
          ),
          list.add(model)
        });
    print(allRows);

    String token = model.token;
    String mobileNumber = model.mobileNumber;
    List<Myorders> orderList = await apiService.myPaymentsList(
        orderstatus: status, token: token, mobileNumber: mobileNumber);
    if (_myCancel == null) {
      _myCancel = new List<Myorders>();
    }
    if (orderList.length > 0) {
      _myCancel = [];
      _myCancel.addAll(orderList);
    }
    notifyListeners();
  }
  fetchMyStatus({String status}) async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) => {
      print(allRows),
      model = UserdatafromDB(
        row["id"].toString(),
        row["firstName"],
        row["lastName"],
        row["address1"],
        row["address2"],
        row["state"],
        row["city"],
        row["pinCode"],
        row["mobileNumber"],
        row["token"],
      ),
      list.add(model)
    });
    print(allRows);
    String token = model.token;
    String mobileNumber = model.mobileNumber;
    List<Myorders> orderList = await apiService.myPaymentsList(
        orderstatus: status, token: token, mobileNumber: mobileNumber);
    if (_myStatus == null) {
      _myStatus = new List<Myorders>();
    }
    if (orderList.length > 0){
      _myStatus = [];
      _myStatus.addAll(orderList);
    }
    notifyListeners();
  }
}


