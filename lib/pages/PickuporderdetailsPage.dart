import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:vaahana/api_service.dart';
import 'package:vaahana/config.dart';
import 'package:vaahana/model/LoginRespose.dart';
import 'package:vaahana/model/PickupOrdersModel.dart';
import 'package:flutter/material.dart';
import 'package:vaahana/model/StatusUpdate.dart';
import 'package:vaahana/pages/PickupOrders.dart';
import 'package:vaahana/utils/form_helper.dart';
import 'package:vaahana/widgets/MapsWidget.dart';

class PickuporderdetailsPage extends StatefulWidget {
  final UserdatafromDB? token;
  final List<PickupkissanOrders>? orders;
  
  PickuporderdetailsPage({Key? key, this.token, this.orders}) : super(key: key);

  @override
  State<PickuporderdetailsPage> createState() => _PickuporderdetailsPageState();
}

class _PickuporderdetailsPageState extends State<PickuporderdetailsPage> {
  late APIService apiService;

  @override
  void initState() {
    super.initState();
    apiService = APIService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromRGBO(123, 212, 165, 1),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Orders Details',
          style: TextStyle(color: Colors.black),
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: orderDetailsUI(context),
      ),
    );
  }

  Widget orderDetailsUI(BuildContext context) {
    final PickupkissanOrders orderModel =
        ModalRoute.of(context)?.settings.arguments as PickupkissanOrders;
    return SingleChildScrollView(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Order Number :"
            "${orderModel.orderInvoiceNumber}",
            style: Theme.of(context).textTheme.labelText,
          ),
          Text(
            "Date :"
            "${orderModel.orderDate}",
            style: Theme.of(context).textTheme.labelText,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Pickup Address",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${orderModel.address}",
                  // "${orderModel.address}",
                  style: Theme.of(context).textTheme.labelText,
                  softWrap: true,
                  maxLines: 3,
                ),
              ),
              IconButton(
                  icon: Icon(Icons.location_on_sharp),
                  onPressed: () {
                    //navigateTo();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoogleMaps(
                            // latitude: double.parse(orderModel.latitude),
                            // longitude: double.parse(orderModel.longitude),
                            ),
                      ),
                    );
                    // navigateMethod();
                    // navigateTo(double.parse(orderModel.latitude),
                    //     double.parse(orderModel.longitude));
                  })
            ],
          ),
          // Text(
          //   "${orderModel.address}",
          //   style: Theme.of(context).textTheme.labelText,
          // ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Delivery Address",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "#101, ABC Shop, HSR Layout,near temple, Bangalore-560102",
                  // "${orderModel.address}",
                  style: Theme.of(context).textTheme.labelText,
                  softWrap: true,
                  maxLines: 3,
                ),
              ),
              IconButton(
                  icon: Icon(Icons.location_on_sharp),
                  onPressed: () {
                    // navigateTo(double.parse(orderModel.latitude),
                    //     double.parse(orderModel.longitude));
                  })
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Payment Method",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            "${orderModel.orderType}",
            style: Theme.of(context).textTheme.labelText,
          ),
          Divider(
            color: Colors.green,
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: Colors.grey,
          ),
          listOrderItems(context),
          Divider(color: Colors.green),
          itemsTotal(
            context,
            "Bill Total",
            "${orderModel.orderFullPrice}",
          ),
          SizedBox(
            height: 10,
          ),
          //  buttons(context),
        ],
      ),
    );
  }

  Widget listOrderItems(BuildContext context) {
    final PickupkissanOrders orderModel =
        ModalRoute.of(context)?.settings.arguments as PickupkissanOrders;

    return ListView.builder(
      itemCount: orderModel.productList?.length ?? 0,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return productslitsItems(context, orderModel.productList![index]);
      },
    );
  }

  Widget productslitsItems(BuildContext context, ProductList productLists) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.all(2),
      onTap: () {},
      title: new Text(
        productLists.productName ?? '',
        style: Theme.of(context).textTheme.productnameText,
      ),
      subtitle: Padding(
        padding: EdgeInsets.all(1),
        child: new Text(
          "Qty :" + "${productLists.numOfItems}",
        ),
      ),
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 44,
          minHeight: 44,
          maxWidth: 44,
          maxHeight: 44,
        ),
        child: Image.network(
          Config.imageurl + (productLists.productCode ?? '') + '.png',
          fit: BoxFit.fill,
        ),
      ),
      trailing: new Text(
        "${productLists.price}",
        style: Theme.of(context).textTheme.labelText,
      ),
    );
  }

  Widget itemsTotal(BuildContext context, String label, String value,
      {TextStyle? textStyle}) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(
        horizontal: 0,
        vertical: -4,
      ),
      contentPadding: EdgeInsets.fromLTRB(2, -10, 2, -10),
      title: new Text(
        label,
        style: Theme.of(context).textTheme.labelHeading,
      ),
      trailing: new Text(
        "$value",
        style: Theme.of(context).textTheme.labelText,
      ),
    );
  }

  Widget buttons(BuildContext buildcontext) {
    final PickupkissanOrders orderModel =
        ModalRoute.of(buildcontext)?.settings.arguments as PickupkissanOrders;
    final token = widget.token;
    String s = orderModel.status ?? 'Rejected';
    
    if ("${orderModel.orderStatus}" == "P" && s == "pending") {
      return Container(
         height: 150,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        // FlatButton(
        //     color: Color.fromRGBO(255, 95, 167, 1),
        //     shape: StadiumBorder(),
        //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        //     child: Text(
        //       'Delivered',
        //       style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 22,
        //           fontWeight: FontWeight.bold),
        //     ),
        //     onPressed: () {
        //       loginWithOTP(mobile);
        //       Navigator.push(
        //         buildcontext,
        //         MaterialPageRoute(
        //           builder: (context) => DOTP(
        //             mobile: mobile,
        //             token: token,
        //             ordernumber: "${orderModel.orderInvoiceNumber}",
        //           ),
        //         ),
        //       );
        //       // statusUpdate(ordernumber, Dstatus, token.token);
        //       // FormHelper.showMessage(
        //       //     buildcontext, "Suyoga", "Order Delivered Successfull", "OK",
        //       //     () {
        //       //   Navigator.push(
        //       //     buildcontext,
        //       //     MaterialPageRoute(
        //       //       builder: (context) => OrderDetails(
        //       //         status: pending,
        //       //       ),
        //       //     ),
        //       //   );
        //       // });
        //     }),
        //      SizedBox(
        //   width: 40,
        // ),
         
          //child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            RichText(
                text: TextSpan(
                    text: "Dear ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                    children: <TextSpan>[
                  TextSpan(
                    text: "${token?.name ?? 'User'}",
                    style: TextStyle(
                        color: Color.fromRGBO(255, 95, 167, 1),
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        " you have 30 minutes to accept this order otherwise we wil assign this order to another vendor.",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                ])),
            // Expanded(
            //   child: Text(
            //     'Dear "${this.token.name}" you have 30 minutes to accept this order otherwise we wil assign this order to another vendor.',
            //     style: TextStyle(fontSize: 18, color: Colors.black),
            //     softWrap: true,
            //     maxLines: 3,
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    showDialog(
                        context: buildcontext,
                        builder: (context) {
                          _showDialog(buildcontext);
                          return SizedBox();
                        });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(79, 78, 78, 1),
                    shape: StadiumBorder(),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: RichText(
                        text: TextSpan(
                      text: "Cancel Order",
                    )),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    'Accept',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                      // loginWithOTP(mobile);
                      // Navigator.push(
                      //   buildcontext,
                      //   MaterialPageRoute(
                      //     builder: (context) => DOTP(
                      //       mobile: mobile,
                      //       token: token,
                      //       ordernumber: "${orderModel.orderInvoiceNumber}",
                      //     ),
                      //   ),
                      // );
                ),

                SizedBox(
                  width: 10,
                ),

                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 95, 167, 1),
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(
                      'Reject',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      // loginWithOTP(mobile);
                      // Navigator.push(
                      //   buildcontext,
                      //   MaterialPageRoute(
                      //     builder: (context) => DOTP(
                      //       mobile: mobile,
                      //       token: token,
                      //       ordernumber: "${orderModel.orderInvoiceNumber}",
                      //     ),
                      //   ),
                      // );
                      // statusUpdate(ordernumber, Dstatus, token.token);
                      // FormHelper.showMessage(
                      //     buildcontext, "Suyoga", "Order Delivered Successfull", "OK",
                      //     () {
                      //   Navigator.push(
                      //     buildcontext,
                      //     MaterialPageRoute(
                      //       builder: (context) => OrderDetails(
                      //         status: pending,
                      //       ),
                      //     ),
                      //   );
                      // });
                    }),
                // FlatButton(
                //     color: Colors.orange,
                //     shape: StadiumBorder(),
                //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                //     child: Text(
                //       "Cancel",
                //       style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 22,
                //           fontWeight: FontWeight.bold),
                //     ),
                //     onPressed: () {
                //       _showDialog(buildcontext);
                //       statusUpdate(ordernumber, Dstatus, token.token);
                //     }),
              ],
            )
          ]));
    } else if (s == "Accepted") {
      return Container(
          height: 150,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            RichText(
                text: TextSpan(
                    text: "Dear ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                    children: <TextSpan>[
                  TextSpan(
                    text: "${token?.name ?? 'User'}",
                    style: TextStyle(
                        color: Color.fromRGBO(255, 95, 167, 1),
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: " Thanks for the accepting the order.",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                ])),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(
                      'Accepted',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {}),
              ],
            )
          ]));
      // return ListTile(
      //   dense: true,
      //   visualDensity: VisualDensity(
      //     horizontal: 0,
      //     vertical: -4,
      //   ),
      //   contentPadding: EdgeInsets.fromLTRB(2, -10, 2, -10),
      // );
    } else if (s == "Rejected") {
      return Container(
          height: 150,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            RichText(
                text: TextSpan(
                    text: "Dear ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                    children: <TextSpan>[
                  TextSpan(
                    text: "${token?.name ?? 'User'}",
                    style: TextStyle(
                        color: Color.fromRGBO(255, 95, 167, 1),
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        " After 30 minutes this order will be dis appear and added to the rejected orders list",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                ])),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(
                      'Rejected',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {}),
              ],
            )
          ]));
    } else {
      return SizedBox();
    }
  }

  void _showDialog(BuildContext buildcontext) {
    // flutter defined function
    final PickupkissanOrders orderModel =
        ModalRoute.of(buildcontext)?.settings.arguments as PickupkissanOrders;
    String ordernumber = "${orderModel.orderInvoiceNumber}";
    String cstatus = "C";
    final token = widget.token;

    showDialog(
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Suyoga"),
          content: new Text("Are you sure you want to Cancel Order"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text("YES"),
              onPressed: () {
                statusUpdate(ordernumber, cstatus, token?.token ?? "");
                FormHelper.showMessage(
                    buildcontext, "Suyoga", "Order Cancel Successfull", "OK",
                    () {
                  Navigator.push(
                    buildcontext,
                    MaterialPageRoute(
                      builder: (context) => PickUpOrders(
                        key: UniqueKey(),
                        status: "P",
                      ),
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
      context: buildcontext,
    );
  }

  // static void navigateTo(double lat, double lng) async {
  //   try {
  //     final position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);

  //     final coordinates =
  //         new Coordinates(position.latitude, position.longitude);
  //     var addresses =
  //         await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //     var first = addresses.first;
  //     print("++++++++++" + '$coordinates');
  //     // print(
  //     //     ">>>>>>>>>>>>>>>>>>>>>>>>>>: ${first.adminArea}: ${first.featureName} : ${first.addressLine} : ${first.postalCode}");
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     // prefs.setString('Location', '${first.locality}');
  //     prefs.setString('Pincode', '${first.postalCode}');
  //     prefs.setString('Address', '${first.addressLine}');
  //     prefs.setString('State', '${first.adminArea}');
  //     prefs.setString('Location', '${first.locality}');
  //   } catch (e) {
  //     // print(">>>>>>>>>>>>>>>>>>>> postion deny");
  //   }
  //   var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
  //   if (await canLaunch(uri.toString())) {
  //     await launch(uri.toString());
  //   } else {
  //     throw 'Could not launch ${uri.toString()}';
  //   }
  // }

  // Future navigateMethod() async {
  //   String url = "";
  //   var response = "asfd";

  //   return response;
  // }
}

extension CustomStyles on TextTheme {
  TextStyle get labelHeading {
    return TextStyle(
        fontSize: 16, color: Colors.redAccent, fontWeight: FontWeight.bold);
  }

  TextStyle get labelText {
    return TextStyle(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold);
  }

  TextStyle get productnameText {
    return TextStyle(
        fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);
  }
}

Future<StatusUpdate?> statusUpdate(
  String ordernumber,
  String status,
  String token,
) async {
  StatusUpdate? model;
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

    if (response.statusCode == 201) {
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
