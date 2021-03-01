import 'dart:convert';
import 'dart:io';
import 'package:Samarpana/model/order_status_Model.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:dio/dio.dart';
import 'package:Samarpana/model/ForgotPassword_model.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'config.dart';
import 'package:Samarpana/model/MyPayments_Model.dart';

class APIService {
  Future<List<Myorders>> myPaymentsList(
      {String orderstatus, String token,String mobileNumber}) async {
    List<Myorders> data = new List<Myorders>();
    try {
      String url = Config.url + Config.orders + "?status=$orderstatus&user=$mobileNumber";
      print(url);
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        // print(token);
        data =
            (response.data as List).map((i) => Myorders.fromJson(i)).toList();
      }
      print(response.data);
    } on DioError catch (e) {
      print(e.response);
    }

    return data;

  }

  Future<LoginResponse> login(String username, String password) async {
    LoginResponse model;
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

        print(response.data);
        print(model.token);
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return model;
  }

  Future<StatusUpdate> statusUpdate(
    String ordernumber,
    String status,
    String token,
  ) async {
    StatusUpdate model;
    String url = Config.url + Config.ordersatus;
    print(url);
    try {
      final response = await Dio().put(
        url,
        data: {
          "orderNumber": ordernumber,
          "orderStatus": status,
        },
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        model = StatusUpdate.fromJson(response.data);
        print(url);
        print(response.data);

        //  print(model.token);
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return model;
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

        print(response.data);
      }
    } on DioError catch (e) {
      ret = false;
      print(e.message);
    }
    return ret;
  }

  Future<bool> forgotpassword(ForgotPasswordOTP model) async {
    bool ret = false;
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
        ret = true;
        //LoginResponse.fromJson(response.data);

        print(response.data);
      }
    } on DioError catch (e) {
      ret = false;
      print(e.message);
    }
    return ret;
  }
}
