import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaahana/api_service.dart';
import 'package:vaahana/model/DriverVehicleModel.dart';
import 'package:vaahana/model/GetDriverDetailsModel.dart';
import 'package:vaahana/model/GetPincodeListModel.dart';
import 'package:vaahana/model/GetvehicleDetailsModel.dart';
import 'package:vaahana/model/LoginRespose.dart';
import 'package:vaahana/model/PickupOrdersModel.dart';
import 'package:vaahana/model/UseraddressModel.dart';
import 'package:vaahana/utils/dataBase.dart';

class CartProvider with ChangeNotifier {
  final dbHelper = DBProvider.instance;
  late UserdatafromDB model;
  late List<UserdatafromDB> list;
  late APIService apiService;
  late List<PickupkissanOrders> _myStatus;
  late List<PickupkissanOrders> _myproductList;
  List<PickupkissanOrders> get pendingList => _myStatus;
  
  List<PickupkissanOrders> get kissanproductList => _myproductList;
  List<PickupkissanOrders> get kissanpendingList => _myStatus;
  late List<UserAddressModel> _useraddress;
  late List<GetDriverDetailsModel> _myDriversList;
  List<GetDriverDetailsModel> get DriversList => _myDriversList;

  // ignore: non_constant_identifier_names
  late List<DriverVehicleModel> _DriversVehicleList;

  late List<GetPinocodeListModel> _getpincodeList;
  // ignore: non_constant_identifier_names
  List<GetPinocodeListModel> get getVendorpincodeList => _getpincodeList;

  // ignore: non_constant_identifier_names
  List<DriverVehicleModel> get DriverVehiclList => _DriversVehicleList;

  late List<GetvehicleDetailsModel> _myVehiclesList;

  List<GetvehicleDetailsModel> get getvehicledata => _myVehiclesList;
  late int ordercount;
  int get count => ordercount;

  late int picodecount;
  int get pcount => picodecount;

  CartProvider() {
    list = <UserdatafromDB>[];
    apiService = APIService();
    _myStatus = <PickupkissanOrders>[];
    _myproductList = <PickupkissanOrders>[];
    _myDriversList = <GetDriverDetailsModel>[];
    _DriversVehicleList = <DriverVehicleModel>[];
    _getpincodeList = <GetPinocodeListModel>[];
    _myVehiclesList = <GetvehicleDetailsModel>[];
    _useraddress = <UserAddressModel>[];
    ordercount = 0;
    picodecount = 0;
  }
  fetchMyStatus({String? status}) async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          model = UserdatafromDB(
            row["id"],
            row["name"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            row["walletamt"],
          );
          list.add(model);
        });
    print(allRows);
    String token = model.token;
    String mobileNumber = model.mobileNumber;
    List<PickupkissanOrders> orderList = await apiService.myPaymentsList(
        orderstatus: status ?? '', token: token, mobileNumber: mobileNumber);
    if (orderList.length > 0) {
      ordercount = orderList.length;
      //  _myStatus = [];
      _myStatus.addAll(orderList);
    }
    notifyListeners();
  }

  getuseraddress() async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          // model = UserdatafromDB(
          //   row["id"],
          //   row["firstName"],
          //   row["lastName"],
          //   row["address1"],
          //   row["address2"],
          //   row["state"],
          //   row["city"],
          //   row["pinCode"],
          //   row["mobileNumber"],
          //   row["token"],
          //   // row["emailId"],
          //   // row["walletamt"],
          // ),
          model = UserdatafromDB(
            row["id"],
            row["name"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            row["walletamt"],
          );
          list.add(model);
        });
    print(allRows);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<UserAddressModel> timslot =
        await apiService.getuseraddress(model.id, model.token);

    if (timslot.length > 0) {
      _useraddress = [];
      _useraddress.addAll(timslot);
      bool result =
          await prefs.setString('useraddressdata', jsonEncode(_useraddress));
      print(result);
    }
    notifyListeners();
  }
  fetchMyproducts({String? status}) async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          model = UserdatafromDB(
            row["id"],
            row["name"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            row["walletamt"],
          );
          list.add(model);
        });
    print(allRows);
    String token = model.token;
    String mobileNumber = model.mobileNumber;
    List<PickupkissanOrders> orderList = await apiService.myPaymentsList(
        orderstatus: status ?? '', token: token, mobileNumber: mobileNumber);
    if (orderList.length > 0) {
      ordercount = orderList.length;
      //  _myStatus = [];
      _myproductList.addAll(orderList);
    }
    notifyListeners();
  }

  fetchMyDriverList() async {
    List<GetDriverDetailsModel> DriverList =
        await apiService.getDriversDetails();
    if (DriverList.length > 0) {
      ordercount = DriverList.length;
      //  _myStatus = [];
      _myDriversList.addAll(DriverList);
    }
    notifyListeners();
  }

  fetchDriverVehicle() async {
    List<DriverVehicleModel> DriverVehiclList =
        await apiService.getDriversVehicle(model.token);
    _DriversVehicleList = <DriverVehicleModel>[];
      if (DriverVehiclList.length > 0) {
      ordercount = DriverVehiclList.length;
      //  _myStatus = [];
      //  _DriversVehicleList = null;
      _DriversVehicleList.addAll(DriverVehiclList);
    }
    notifyListeners();
  }

  fetchVendorPincodes() async {
    List<GetPinocodeListModel> getvendorPincodelist =
        await apiService.getVendorsPincodes(model.token);
    _getpincodeList = <GetPinocodeListModel>[];
      if (getvendorPincodelist.length > 0) {
      picodecount = getvendorPincodelist.length;
      //  _myStatus = [];
      _getpincodeList.addAll(getvendorPincodelist);
    }
    // if (_getpincodeList == null) {
    //   _getpincodeList = new List<GetPinocodeListModel>();
    // }
    // if (getvendorPincodelist.length > 0) {
    //   picodecount = getVendorpincodeList.length;
    //   //  _myStatus = [];
    //   //  _DriversVehicleList = null;
    //   _getpincodeList.addAll(getvendorPincodelist);
    // }

    notifyListeners();
  }

  fetchMyVehiclesList() async {
    List<GetvehicleDetailsModel> VehiclsList =
        await apiService.getVehicleDetails();
    _myVehiclesList = <GetvehicleDetailsModel>[];
      if (VehiclsList.length > 0) {
      ordercount = VehiclsList.length;
      //  _myStatus = [];
      _myVehiclesList.addAll(VehiclsList);
    }
    notifyListeners();
  }
}
