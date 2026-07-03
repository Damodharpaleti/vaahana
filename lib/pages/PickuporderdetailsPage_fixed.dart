import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:vaahana/api_service.dart';
import 'package:vaahana/config.dart';
import 'package:vaahana/model/LoginRespose.dart';
import 'package:vaahana/model/PickupOrdersModel.dart';
import 'package:flutter/material.dart';
import 'package:vaahana/model/StatusUpdate.dart';
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
                  style: Theme.of(context).textTheme.labelText,
                  softWrap: true,
                  maxLines: 3,
                ),
              ),
              IconButton(
                  icon: Icon(Icons.location_on_sharp),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoogleMaps(),
                      ),
                    );
                  })
            ],
          ),
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
                  style: Theme.of(context).textTheme.labelText,
                  softWrap: true,
                  maxLines: 3,
                ),
              ),
              IconButton(
                  icon: Icon(Icons.location_on_sharp),
                  onPressed: () {})
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
      print(response.data);
    }
  } on DioError catch (e) {
    ret = false;
    print(e.message);
  }
  return ret;
}
