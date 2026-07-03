import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vaahana/components/Cart_Provider.dart';
import 'package:vaahana/model/LoginRespose.dart';
import 'package:vaahana/model/MyPayments_Model.dart';
import 'package:vaahana/utils/dataBase.dart';
import 'package:vaahana/widgets/drawer.dart';

class OrderStatus extends StatefulWidget {
  OrderStatus({Key? key, required this.status, this.orderModel}) : super(key: key);

  final String status;
  final Myorders? orderModel;
  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
    List<UserdatafromDB> list = <UserdatafromDB>[];
  final dbHelper = DBProvider.instance;
  late UserdatafromDB model;
  late bool listselection;

  @override
  void initState() {
    super.initState();

    fetch();
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.fetchMyStatus(status: this.widget.status);
    orderProvider.getuseraddress();
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

  Future<bool> _onbackpress() {
    return showDialog<bool>(
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
                      // Navigator.pop(context, true);
                    },
                    child: Text("Yes"))
              ],
            )).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return new Consumer<CartProvider>(builder: (context, ordermodel, child) {
      if (ordermodel.pendingList.length > 0) {
        _listview(context, ordermodel.pendingList, ordermodel.count);
        listselection = true;
      } else {
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
                      backgroundColor: Color.fromRGBO(123, 212, 165, 1),
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

                    body: _listview(
                        context, ordermodel.pendingList, ordermodel.count),
                    // body: Container(
                    //     // margin: EdgeInsets.all(10),
                    //     // child:_single(),
                    //     child: _listview(
                    //         context, ordermodel.pendingList, ordermodel.count)),
                  ),
                ),
                onWillPop: _onbackpress),
          if (listselection == false)
            WillPopScope(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.99,
                width: double.infinity,
                child: Scaffold(
                    drawer: DrawerWidget(),
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                      centerTitle: true,
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
                    body: Center(
                      child: Text(
                        "No orders available.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    )),
              ),
              onWillPop: _onbackpress,
            )
        ],
      );
    });
  }

  Widget _listview(BuildContext context, List<dynamic> orders, int count) {
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
                            //         builder: (context) => Mypayments(
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
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    // builder: (context) => Mypayments(
                                    //       token: model,
                                    //     ),
                                    // settings: RouteSettings(
                                    //   arguments: orders[index],
                                    // )),
                                    //   );
                                    },
                                  ),
                                ),
                                
                                ]),
                                  Divider(color: Colors.red),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  
                                ])));
                  }
                  ),
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
    return ElevatedButton(
      onPressed: onPressed as VoidCallback?,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(5),
        backgroundColor: color,
        shape: StadiumBorder(),
      ),
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

class pendingStatus extends StatefulWidget {
  pendingStatus({Key? key, required this.status, this.orderModel}) : super(key: key);

  final String status;
  final Myorders? orderModel;
  @override
  _pendingStatusState createState() => _pendingStatusState();
}

class _pendingStatusState extends State<pendingStatus> {
    List<UserdatafromDB> list = <UserdatafromDB>[];
  final dbHelper = DBProvider.instance;
  late UserdatafromDB model;

  @override
  void initState() {
    super.initState();

    fetch();
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.fetchMyStatus(status: this.widget.status);
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

  @override
  Widget build(BuildContext context) {
    return new Consumer<CartProvider>(builder: (context, ordermodel, child) {
      if (ordermodel.pendingList.length > 0) {
        _listview(context, ordermodel.pendingList, ordermodel.count);
      }
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
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
        body: Container(
          margin: EdgeInsets.all(10),
          // child:_single(),
          child: _listview(context, ordermodel.pendingList, ordermodel.count),
        ),
      );
    });
  }

  Widget _listview(BuildContext context, List<dynamic> orders, int count) {
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
                    return Row(children: [
                      SizedBox(
                        width: 328,
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => Mypayments(
                            //             token: model,
                            //           ),
                            //       // settings: RouteSettings(
                            //       //   arguments: orders[index],
                            //       // ),
                            //       ),
                            // );
                          },
                          child: new Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(16.0)),
                            child: Column(
                              children: <Widget>[
                                // orderStatus("${orders[index].orderStatus}"),
                                Divider(color: Colors.red),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    iconData(
                                        Icon(
                                          Icons.edit,
                                          color: Colors.lightGreen,
                                          size: 14,
                                        ),
                                        Text(
                                          "Order Number :",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text("${orders[index].orderInvoiceNumber}",
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
                                          color: Colors.lightGreen,
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
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    iconData(
                                        Icon(
                                          Icons.person,
                                          color: Colors.lightGreen,
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
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    iconData(
                                        Icon(
                                          Icons.date_range,
                                          color: Colors.lightGreen,
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
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                    ]);
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
    return ElevatedButton(
      onPressed: onPressed as VoidCallback?,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(5),
        backgroundColor: color,
        shape: StadiumBorder(),
      ),
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
