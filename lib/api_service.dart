import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaahana/config.dart';
import 'package:vaahana/model/DriverVehicleModel.dart';
import 'package:vaahana/model/ForgotPassword_model.dart';
import 'package:vaahana/model/GetPincodeListModel.dart';
import 'package:vaahana/model/LoginRespose.dart';
import 'package:vaahana/model/PickupOrdersModel.dart';
import 'package:vaahana/model/User_Signup_Model.dart';
import 'package:vaahana/model/UseraddressModel.dart';
import 'package:vaahana/model/Vendor_AccountModel.dart';
import 'package:vaahana/model/addNewservicePincodeModel.dart';
import 'package:vaahana/model/getPartnercitymodel.dart';

import 'model/AddVehicleDetailsModel.dart';
import 'model/GetDriverDetailsModel.dart';
import 'model/GetvehicleDetailsModel.dart';
import 'model/ServerResponse.dart';
import 'model/addDriverDetailsModel.dart';
import 'package:vaahana/components/globals.dart' as globals;

class APIService {
  Future<LoginResponse?> login(String username, String password) async {
    LoginResponse? model = LoginResponse();
    String url = Config.loginUrl + Config.login;
    try {
      final response = await Dio().post(
        url,
        data: {
          "username": username,
          "password": password,
        },
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        model = LoginResponse.fromJson(response.data);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("ROLE", model.roleDetails?[0].name ?? '');
        prefs.setString("token", model.token ?? '');
        globals.GlobaluserId = model.mobileNumber ?? '';
        globals.userRole = model.roleDetails?[0].name ?? '';
        print(response.data);
        print(model.token);
        print("getting role>>>>>>>>>>>>>>>>>>>>>");
        print(model.roleDetails.toString());
        print(model.roleDetails?[0].name);

        print("before role>>>>>>>>>>>>>>");

        print("After role>>>>>>>>>>>>>>");

        print("getting role>>>>>>>>>>>>>>>>>>>>>");
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return model;
  }

  Future<ForgotPasswordOTP?> forgotpassword(ForgotPasswordOTP model) async {
    ForgotPasswordOTP? data;
    String url = Config.loginUrl + Config.forgotPassword;
    try {
      final response = await Dio().post(
        url,
        data: jsonEncode(model.toJson()),
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {
        // ret = true;
        data = ForgotPasswordOTP.fromJson(response.data);
        //LoginResponse.fromJson(response.data);

        // print(response.data);
      }
    } on DioError catch (e) {
      // ret = false;
      if (e.response != null) {
        data = ForgotPasswordOTP.fromJson(e.response!.data);
      }
      // print(e.message);
    }
    return data ?? ForgotPasswordOTP();
  }

  Future<bool> loginWithOTP(String mobileNumber) async {
    bool ret = false;
    String url = Config.loginUrl + Config.otp;
    try {
      final response = await Dio().post(
        url,
        data: {
          "mobileNumber": mobileNumber,
        },
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {
        ret = true;
        //LoginResponse.fromJson(response.data);

        // print(response.data);
      }
    } on DioError {
      ret = false;
      // print(e.message);
    }
    return ret;
  }

  Future<bool> regWithOTP(String mobileNumber) async {
    bool ret = false;
    String url = Config.loginUrl + Config.regOtp;
    // String url = "http://192.168.43.142:8081/loginService/user/v1/Regotp";
    // print(url);
    try {
      final response = await Dio().post(
        url,
        data: {
          "mobileNumber": mobileNumber,
        },
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {
        ret = true;
        //LoginResponse.fromJson(response.data);

        // print(response.data);
      }
    } on DioError {
      ret = false;
      // print(e.message);
    }
    return ret;
  }

  Future<bool> userRegister(User model) async {
    bool ret = false;
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String City = prefs.getString('Location');
    // final String Pincode = prefs.getString('Pincode');
    // final String Address = prefs.getString('Address');
    // final String State = prefs.getString('State');
    try {
      // model.state = "$State";
      // model.city = "$City";
      // model.location = "$City";
      // model.address1 = "$Address";
      // model.roleId = 10;
      // //  model.pinCode = "$Pincode";
      // if (Address == null || State == null) {
      //   model.address1 = "XXXXXXX";
      //   model.state = "XXXXXXX";
      // }
      String url = Config.url + Config.driverRegister;
      print(jsonEncode(model.toJson()));
      var response = await Dio().post(url,
          data: jsonEncode(model.toJson()),
          options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
          ));
      if (response.statusCode == 200) {
        // print(response.data);
        return ret = true;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        // print(jsonEncode(model.toJson()));
        print(e.error?.data);
        return ret = false;
      } else {
        // print(e.message);
        // print(e.request);
        return ret = false;
      }
    }
    return ret;
  }

  Future<List<PickupkissanOrders>> myPaymentsList(
      {required String orderstatus, required String token, required String mobileNumber}) async {
    // ignore: deprecated_member_use
    List<PickupkissanOrders> data = <PickupkissanOrders>[];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userRole = prefs.getString("ROLE");
    try {
      // String url = Config.url +
      //     Config.orders +
      //     "?status=$orderstatus&user=$mobileNumber";

      String url = Config.url +
          Config.orders +
          "?status=$orderstatus&user=$mobileNumber&userRole=$userRole";

      //  http://44.192.46.200:8084/samarpanaService/Order/v1/getOrdersByuser?status=D&user=7729928291&userRole=ROLE_SAMARPANA_ADMIN
      print(url);
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            //  HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        // print(token);
        data = (response.data as List)
            .map((i) => PickupkissanOrders.fromJson(i))
            .toList();
      }
      print(response.data);
    } on DioError catch (e) {
      print(e.response);
    }

    return data;
  }

  //add Driverdetails
  Future<ServerResponse> uploaddriverdetails(
      addDriverDetailsModel adddriverdetailsmodel) async {
    late ServerResponse model;
    String url = Config.url + Config.addDrivers;
    print(url);
    print(adddriverdetailsmodel.toJson());
    try {
      final response = await Dio().post(
        url,
        data: adddriverdetailsmodel.toJson(),
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {
        // loginFlag = true;
        model = ServerResponse.fromJson(response.data);
        print("response from post method update Driver Details>>>>>>>>>>>>>>>");
        print(model.message);
        print(model.statusCode);
        print("response from post method Driver Details>>>>>>>>>>>>>>>>");
      }
    } on DioError catch (e) {
      //loginFlag = false;
      print(e.message);
    }
    return model;
  }

  //add Driverdetails
  Future<ServerResponse> uploadVehicleDetails(
      AddVehicleDetailsModel addVehicledetailsmodel) async {
    late ServerResponse model;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    print(prefs.getString("token"));
    String url = Config.url + Config.addVehicleDetails;
    print(url);
    print(jsonEncode(addVehicledetailsmodel.toJson()));
    try {
      final response = await Dio().post(
        url,
        data: jsonEncode(addVehicledetailsmodel.toJson()),
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 201) {
        // loginFlag = true;
        model = ServerResponse.fromJson(response.data);
        print("response from post method update Driver Details>>>>>>>>>>>>>>>");
        print(model.message);
        print(model.statusCode);
        print("response from post method Driver Details>>>>>>>>>>>>>>>>");
      }
    } on DioError catch (e) {
      //loginFlag = false;
      print(e.message);
    }
    return model;
  }
  Future<List<UserAddressModel>> getuseraddress(
      int userId, String token) async {
    List<UserAddressModel> data = <UserAddressModel>[];
    try {
      String url = Config.loginUrl + Config.useraddress + "?userId=$userId";
      // String url =
      //     "http://44.192.46.200:8081/loginService/user/v1/getuserAddress?userId=$userId";
      // String url =
      //     "http://44.192.46.200:8081/loginService/user/v1/getuserAddress?userId=835";

      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        print(url);
        print(response.data);
        data = (response.data as List)
            .map((i) => UserAddressModel.fromJson(i))
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return data;
  }

  //..........fetch Driver details

  Future<List<GetDriverDetailsModel>> getDriversDetails() async {
    // ignore: deprecated_member_use
    List<GetDriverDetailsModel> data = <GetDriverDetailsModel>[];
    print("calling Step 5 gst Profile>>>>>>");

    try {
      String url = Config.url + Config.getDriverDetails;

      print(url);
      var response = await Dio().get(url,
          options: new Options(
              headers: {HttpHeaders.contentTypeHeader: 'application/json'}));
      if (response.statusCode == 200) {
        print("new one>>");
        data = (response.data as List)
            .map((i) => GetDriverDetailsModel.fromJson(i))
            .toList();
        print("data>>>>>>>>>");
        print(data);
      }
    } on DioError catch (e) {
      print("no new one");
      print(e.response);
    }

    return data;
  }

  Future<List<GetPartnerscityList>> getpartnersList() async {
    // ignore: deprecated_member_use
    List<GetPartnerscityList> data = <GetPartnerscityList>[];
    print("calling Step 5 gst Profile>>>>>>");

    try {
      String url = Config.url + Config.getPartnercityist;

      print(url);
      var response = await Dio().get(url,
          options: new Options(
              headers: {HttpHeaders.contentTypeHeader: 'application/json'}));
      if (response.statusCode == 200) {
        print("new one>>");
        data = (response.data as List)
            .map((i) => GetPartnerscityList.fromJson(i))
            .toList();
        print("data>>>>>>>>>");
        print(data);
      }
    } on DioError catch (e) {
      print("no new one");
      print(e.response);
    }

    return data;
  }

//getDriver Vehicle List
  Future<List<DriverVehicleModel>> getDriversVehicle(String token) async {
    // ignore: deprecated_member_use
    List<DriverVehicleModel> data = <DriverVehicleModel>[];
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // ignore: non_constant_identifier_names
    String? MobNumber = prefs.getString("LoginMobNumber");
    try {
      String url =
          Config.url + Config.getDriversVehicleDetails + "?userId=" + (MobNumber ?? '');
      print(url);
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        print("new one>>");
        data = (response.data as List)
            .map((i) => DriverVehicleModel.fromJson(i))
            .toList();
        print("data>>>>>>>>>");
        print(data);
      }
    } on DioError catch (e) {
      print("no new one");
      print(e.response);
    }

    return data;
  }

//fetch vehicle details
  Future<List<GetvehicleDetailsModel>> getVehicleDetails() async {
    // ignore: deprecated_member_use
    List<GetvehicleDetailsModel> data = <GetvehicleDetailsModel>[];
    print("calling Step 5 gst Profile>>>>>>");

    try {
      String url = Config.url + Config.getvehicleDetails;

      print(url);
      var response = await Dio().get(url,
          options: new Options(
              headers: {HttpHeaders.contentTypeHeader: 'application/json'}));
      if (response.statusCode == 200) {
        print("new one>>");
        data = (response.data as List)
            .map((i) => GetvehicleDetailsModel.fromJson(i))
            .toList();
        print("data>>>>>>>>>");
        print(data);
      }
    } on DioError catch (e) {
      print("no new one");
      print(e.response);
    }

    return data;
  }

  // ignore: non_constant_identifier_names
  Future<LoginResponse> Otplogin(String username, String accessCode) async {
    late LoginResponse model;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String url = Config.loginUrl + Config.login;
    try {
      final response = await Dio().post(
        url,
        data: {"username": username, "acessCode": accessCode},
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        model = LoginResponse.fromJson(response.data);
        print(model);
        if (model.roleDetails?.isEmpty ?? true) {
          // model.roleDetails[0].name = "Role not assigned";
          // model.roleDetails[0].id = 0;
          // print("role name>>>>>>>>>" + model.roleDetails[0].name);
          prefs.setString("ROLE", "Role not assigned");
          // globals.role = prefs.getString("ROLE");
        } else {
          prefs.setString("ROLE", model.roleDetails?[0].name ?? '');
          prefs.setString("token", model.token ?? '');
          // globals.role = model.roleDetails[0].name;
        }
      } else {
        prefs.setString("ROLE", "Role not assigned");
        // globals.role = prefs.getString("ROLE");
      }
    } on DioError catch (e) {
      print(e.message);
      LoginResponse model = new LoginResponse();
      model.statusCode = 400;
    }
    return model;
  }

  Future<bool> loginOTP(String mobileNumber) async {
    bool ret = false;
    String url = Config.loginUrl + Config.loginOtp;
    print(url);
    try {
      final response = await Dio().post(
        url,
        data: {
          "mobileNumber": mobileNumber,
        },
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {
        ret = true;
      }
    } on DioError catch (e) {
      ret = false;
      print(e.message);
    }
    return ret;
  }

  Future<VendorAccountdetails> getVendorBankDetails(
      String mobile, String token) async {
    late VendorAccountdetails data;

    try {
      String url =
          Config.paymentservice + Config.getvendorbankdata + "?userId=$mobile";
      print(url);
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        data = VendorAccountdetails.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<ContactResponse> createContact(CreateContact vendor) async {
    late ContactResponse data;
    try {
      String username = Config.razorpaykey;
      String password = Config.apiSecret;
      String basicAuth = base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);
      print(vendor);
      String url = "https://api.razorpay.com/v1/contacts";
      var response = await Dio().post(url,
          data: jsonEncode(vendor.toJson()),
          options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: 'Basic $basicAuth',
            },
          ));
      if (response.statusCode == 200) {
        print(response.data);
        data = ContactResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        data = ContactResponse.fromJson(e.response?.data ?? {});
      } else {
        data = ContactResponse.fromJson(e.response?.data ?? {});
      }
    }
    return data;
  }

  Future<Contactadded> addrzpccontact(Contactadded contid, String token) async {
    late Contactadded data;
    try {
      String url = Config.paymentservice + Config.rzpContact;
      var response = await Dio().post(url,
          data: jsonEncode(contid.toJson()),
          options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: 'Bearer $token',
            },
          ));
      if (response.statusCode == 200) {
        data = Contactadded.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        data = Contactadded.fromJson(e.response?.data ?? {});
      } else {
        data = Contactadded.fromJson(e.response?.data ?? {});
      }
    }
    return data;
  }

  // getVendorsPincodes(String token) {}

  Future<List<GetPinocodeListModel>> getVendorsPincodes(String token) async {
    // ignore: deprecated_member_use
    List<GetPinocodeListModel> data = <GetPinocodeListModel>[];
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? MobNumber = prefs.getString("LoginMobNumber");
    try {
      String url =
          Config.url + Config.getPicodeList + "?MobileNumber=" + (MobNumber ?? '');
      print(url);
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        print(response.data);
        data = (response.data as List)
            .map((i) => GetPinocodeListModel.fromJson(i))
            .toList();
        print("data>>>>>>>>>");
        print(data);
      }
    } on DioError catch (e) {
      print("no new one");
      print(e.response);
    }

    return data;
  }

  Future<AddNewPincodes> addservicePindoces(
      AddNewPincodes addNewPincodes) async {
    late AddNewPincodes data;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    print(prefs.getString("token"));
    String url = Config.url + Config.addKissanPincode;
    print(url);
    print(jsonEncode(addNewPincodes.toJson()));
    try {
      final response = await Dio().post(
        url,
        data: jsonEncode(addNewPincodes.toJson()),
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${token ?? ''}",
          },
        ),
      );

      if (response.statusCode == 200) {
        data = AddNewPincodes.fromJson(response.data);
      }
    } on DioError catch (e) {
      //loginFlag = false;
      print(e.message);
      data = AddNewPincodes();
    }
    return data;
  }
}
