import 'dart:io';

import 'package:Samarpana/config.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/order_status_Model.dart';
import 'package:Samarpana/pages/Delivery_status.dart';
import 'package:Samarpana/pages/Order_detailsPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/style.dart';
import 'package:Samarpana/utils/ProgressHUD.dart';
import 'package:Samarpana/utils/form_helper.dart';

class DOTP extends StatefulWidget {
  //User user;
  StatusUpdate statusUpdate;
  String mobile;
  String Dstatus = "D";
  String Pstatus = "P";
  UserdatafromDB token;
  String ordernumber;

  DOTP({Key key, this.mobile, this.token, this.ordernumber}) : super(key: key);

  @override
  _DOTPState createState() => _DOTPState();
}

class _DOTPState extends State<DOTP> {
  APIService apiService;
  bool isApicallProcess = false;
  String accesscode;
  @override
  void initState() {
    super.initState();
    apiService = new APIService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ProgressHUD(
            child: new Form(
              child: formui(),
            ),
            inAsyncCall: isApicallProcess,
            opacity: 0.3));
  }

  Widget formui() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Text(
              "Customer Delivery Verification Code",
              style: headingStyle,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "We sent Verification code To +91 " + " " + this.widget.mobile,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text("This code valid Upto "),
            //     TweenAnimationBuilder(
            //       tween: Tween(
            //         begin: 120.0,
            //         end: 0,
            //       ),
            //       duration: Duration(seconds: 120),
            //       builder: (BuildContext context, value, child) => Text(
            //         " ${value.toInt()}" + " " + "Seconds",
            //         style: TextStyle(color: Colors.red),
            //       ),
            //       onEnd: () {},
            //     ),
            //   ],
            // ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: PinFieldAutoFill(
                codeLength: 4,
                onCodeChanged: (val) {
                  print(val);
                  if (val.isNotEmpty) {
                    accesscode = val;
                  }
                },
              ),
            ),
            SizedBox(
              height: 200,
            ),
            new Center(
              child: FormHelper.saveButton("Submit", () {
                if (accesscode != null) {
                  // setState(() {
                  //   isApicallProcess = false;
                  // });
                  statusUpdate(
                    this.widget.ordernumber,
                    this.widget.Dstatus,
                    this.widget.token.token,
                    this.widget.mobile,
                    accesscode,
                  ).then((ret) {
                    // setState(() {
                    //   isApicallProcess = true;
                    // });

                    if (ret) {
                      FormHelper.showMessage(context, "SAMARPANA",
                          "Your Order Delivered Succesfully", "OK", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderStatus(status: this.widget.Pstatus),
                              ),
                            );
                          });
                    } else {
                      FormHelper.showMessage(
                          context, "SUYOGA", "Enter Valid OTP", "OK", () {
                        Navigator.of(context).pop();
                      });
                    }
                  });
                }
              }),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> statusUpdate(
      String ordernumber,
      String status,
      String token,
      String mobile,
      String accesscode,
      ) async {
    bool ret = false;
    String url = Config.url + Config.ordersatus;
    print(url);
    try {
      final response = await Dio().put(
        url,
        data: {
          "orderNumber": ordernumber,
          "orderStatus": status,
          "mobileNumber": mobile,
          "accessCode": accesscode,
        },
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201) {
        ret = true;
        print(url);
        print(response.data);

        //  print(model.token);
      }
    } on DioError catch (e) {
      print(e.message);
      ret = false;
    }
    return ret;
  }
}