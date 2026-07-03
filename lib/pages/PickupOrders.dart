import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vaahana/components/Cart_Provider.dart';
import 'package:vaahana/model/LoginRespose.dart';
import 'package:vaahana/model/PickupOrdersModel.dart';
import 'package:vaahana/pages/PickuporderdetailsPage.dart';
import 'package:vaahana/pages/loggin.dart';
import 'package:vaahana/utils/dataBase.dart';
import 'package:vaahana/widgets/drawer.dart';

class PickUpOrders extends StatefulWidget {
  final String status;
  final PickupkissanOrders? pickupkissanOrders;

  const PickUpOrders({required Key key, required this.status, this.pickupkissanOrders}) : super(key: key);

  @override
  _PickUpOrdersState createState() => _PickUpOrdersState();
}

class _PickUpOrdersState extends State<PickUpOrders> {
  late List<UserdatafromDB> list;
  final dbHelper = DBProvider.instance;
  late UserdatafromDB model;
  late bool listselection;

  @override
  void initState() {
    super.initState();

    fetch();
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.fetchMyStatus(status: "P");
    // orderProvider.getuseraddress();
  }

  fetch() async {
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
    setState(() {
      build(context);
    });
  }

  Future<bool> _onbackpress() async {
    final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Do you want to close app",
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text("No")),
                TextButton(
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    child: Text("Yes"))
              ],
            ));
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return new Consumer<CartProvider>(builder: (context, ordermodel, child) {
      if (ordermodel.kissanpendingList.length > 0) {
        _listview(context, ordermodel.kissanpendingList, ordermodel.count);
        listselection = true;
      } else {
        loginreturn();
        listselection = false;
      }

      return Column(
        children: [
          if (listselection == true)
            WillPopScope(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Color.fromRGBO(124, 194, 157, 1),
                      title: Text(
                        'Pending Orders',
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: [
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    drawer: DrawerWidget(),
                    body: Container(
                        margin: EdgeInsets.all(10),
                        // child:_single(),
                        child: _listview(context, ordermodel.kissanpendingList,
                            ordermodel.count)),
                  ),
                ),
                onWillPop: _onbackpress),
          if (listselection == false)
            Container(
              height: MediaQuery.of(context).size.height,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  centerTitle: true,
                  title: Text(
                    'Pending Orders',
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                drawer: DrawerWidget(),
                body: Container(
                    padding: EdgeInsets.only(top: 150, left: 140),
                    // child:_single(),
                    // child: loginreturn()
                    child: Text("Data not Available")),
              ),
            ),
        ],
      );
    });
  }

  Widget loginreturn() {
    return Center(child: LoginPage());
  }

  Widget _listview(
      BuildContext context, List<PickupkissanOrders> orders, int count) {
    return orders.length == 0
        ? Center(
            child: Text('No Pending Orders are avaliable',
                style: TextStyle(fontSize: 20, color: Colors.black)))
        : new ListView(
            children: [
              ListView.builder(
                  itemCount: count,
                  physics: ScrollPhysics(),
                  padding: EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            // onTap: () {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             PickuporderdetailsPage(
                            //               token: model,
                            //             ),
                            //         settings: RouteSettings(
                            //           arguments: orders[index],
                            //         )),
                            //   );
                            // },
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      iconData(
                                          Icon(
                                            Icons.edit,
                                            color:
                                                Color.fromRGBO(255, 95, 167, 1),
                                            size: 14,
                                          ),
                                          Text(
                                            "Order Number :",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Text(
                                          "${orders[index].orderInvoiceNumber}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      iconData(
                                          Icon(
                                            Icons.date_range,
                                            color:
                                                Color.fromRGBO(255, 95, 167, 1),
                                            size: 12,
                                          ),
                                          Text(
                                            "Order Date :",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Text("${orders[index].orderDate}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      iconData(
                                          Icon(
                                            Icons.phone,
                                            color:
                                                Color.fromRGBO(255, 95, 167, 1),
                                            size: 12,
                                          ),
                                          Text(
                                            "Customer Mobile No. :",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Text("${orders[index].orderUserId}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      iconData(
                                          Icon(
                                            Icons.date_range,
                                            color:
                                                Color.fromRGBO(255, 95, 167, 1),
                                            size: 12,
                                          ),
                                          Text(
                                            "Time Slot:",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Text("${orders[index].timeslot}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                    ],
                                  ),
                                                   Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 150, ),
                                  child: flatButton(
                                    Row(
                                      children: [
                                        Text(
                                          "Order Details",
                                          style: TextStyle(
                                            color: Colors.white,
                                            //letterSpacing: 1,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        //Icon(Icons.chevron_right),
                                      ],
                                    ),
                                    Colors.green[900] ?? Colors.green,
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                    builder: (context) => PickuporderdetailsPage(
                                          token: model,
                                        ),
                                    settings: RouteSettings(
                                      arguments: orders[index],
                                    )),
                                      );
                                    },
                                  ),
                                ),
                                
                                ]),
                                  Divider(color: Colors.red),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ])));
                  })
            ],
          );
  }

  Widget iconData(Icon iconData, Text textdata) {
    return Row(
      children: <Widget>[
        iconData,
        SizedBox(
          width: 10,
        ),
        textdata,
      ],
    );
  }

  Widget flatButton(
    Widget iconText,
    Color color,
    Function onPressed,
  ) {
    return TextButton(
      onPressed: onPressed as void Function()?,
      style: TextButton.styleFrom(backgroundColor: color, shape: const StadiumBorder()),
      child: iconText,
    );
  }

  Widget orderStatus(String status) {
    Icon icon;
    Color color;

    if (status == "P" || status == "Processing" || status == "On-Hold") {
      icon = Icon(
        Icons.timer,
        color: Colors.orange,
      );
      color = Colors.orange;
    } else if (status == "D" || status == "Deliverd") {
      icon = Icon(
        Icons.check,
        color: Colors.green,
      );
      color = Colors.green;
    } else if (status == "C" || status == "Cancelled") {
      icon = Icon(
        Icons.clear,
        color: Colors.redAccent,
      );
      color = Colors.redAccent;
    } else {
      icon = Icon(
        Icons.clear,
        color: Colors.redAccent,
      );
      color = Colors.redAccent;
    }
    return iconData(
        icon,
        Text(
          "Order Status :$status",
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
