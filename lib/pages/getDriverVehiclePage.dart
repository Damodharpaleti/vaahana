import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaahana/components/Cart_Provider.dart';
import 'package:vaahana/model/DriverVehicleModel.dart';
import 'package:vaahana/model/LoginRespose.dart';
import 'package:vaahana/model/PickupOrdersModel.dart';
import 'package:vaahana/pages/AddVehicleDetails.dart';
import 'package:vaahana/pages/PickupOrders.dart';
import 'package:vaahana/utils/dataBase.dart';
import 'package:vaahana/widgets/drawer.dart';

class getDriversVehiclePage extends StatefulWidget {
  final String mobileNum;
  final String status;
  final String token;
  final PickupkissanOrders? pickupkissanOrders = null;
  
  getDriversVehiclePage({Key? key, required this.mobileNum, required this.status, required this.token})
      : super(key: key);
  
  @override
  _getDriversVehiclePageState createState() => _getDriversVehiclePageState();
}

class _getDriversVehiclePageState extends State<getDriversVehiclePage> {
  List<UserdatafromDB> list = <UserdatafromDB>[];
  final dbHelper = DBProvider.instance;
  late UserdatafromDB model;
  late bool listselection;

  @override
  void initState() {
    super.initState();

    // fetch();
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.fetchDriverVehicle();
    // orderProvider.getuseraddress();
  }

  Future<bool> _onbackpress() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PickUpOrders(key: UniqueKey(), status: "P")));
    return Future.value(true);
    // showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //           title: Text(
    //             "Do you want to close app",
    //           ),
    //           actions: <Widget>[
    //             FlatButton(
    //                 onPressed: () {
    //                   Navigator.pop(context, false);
    //                 },
    //                 child: Text("No")),
    //             FlatButton(
    //                 onPressed: () {
    //                   SystemChannels.platform
    //                       .invokeMethod('SystemNavigator.pop');
    //                   Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => PickUpOrders(status: "P"),
    //                     ),
    //                   );
    //                 },
    //                 child: Text("Yes"))
    //           ],
    //         ));
  }

  @override
  Widget build(BuildContext context) {
    return new Consumer<CartProvider>(
        // ignore: non_constant_identifier_names
        builder: (context, DriverVehicleModel, child) {
      if (DriverVehicleModel.DriverVehiclList.length > 0) {
        _listview(context, DriverVehicleModel.DriverVehiclList,
            DriverVehicleModel.count);
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
                      backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                      title: Text(
                        'Vehicle Details',
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
                        child: _listview(
                            context,
                            DriverVehicleModel.DriverVehiclList,
                            DriverVehicleModel.count)),
                  ),
                ),
                onWillPop: _onbackpress),
          if (listselection == false)
            Container(
              height: MediaQuery.of(context).size.height,
              child: Scaffold(
                  // appBar: AppBar(
                  //   backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                  //   centerTitle: true,
                  //   title: Text(
                  //     'Vehicles Details',
                  //     style: TextStyle(color: Colors.black),
                  //   ),
                  //   actions: [
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //   ],
                  // ),
                  body: Container(
                      // padding: EdgeInsets.only(top: 80, left: 130),
                      // child:_single(),
                      child: loginreturn())
                  // child: Text("Vehicle Details Not Found")),
                  ),
            ),
        ],
      );
    });
  }

  Widget loginreturn() {
    return Center(child: AddVehicleDetails());
  }

  Widget _listview(
      BuildContext context, List<DriverVehicleModel> orders, int count) {
    return orders.length == 0
        ? Center(
            child: Text('Vehicle Details Not avaliable',
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
                        width: 350,
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PickupOrderdetails(
                            //       token: model,
                            //       orders: orders,
                            //     ),
                            //   ),
                            // );
                          },
                          child: new Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(16.0)),
                            child: Column(
                              children: <Widget>[
                                // orderStatus("${orders[index].orderStatus}"),
                                Divider(color: Colors.green),
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
                                          color: Colors.black,
                                          size: 14,
                                        ),
                                        Text(
                                          "Transporter Name :",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.pinkAccent,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text("${orders[index].transportName}",
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
                                          Icons.airport_shuttle_outlined,
                                          color: Colors.black,
                                          size: 12,
                                        ),
                                        Text(
                                          "Vehicle Name:",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.pinkAccent,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text("${orders[index].vehicleName}",
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
                                          Icons.domain_verification,
                                          color: Colors.black,
                                          size: 12,
                                        ),
                                        Text(
                                          "Vehicle Number :",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.pinkAccent,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text("${orders[index].vehicleNumber}",
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
                                          Icons.apps_sharp,
                                          color: Colors.black,
                                          size: 12,
                                        ),
                                        Text(
                                          "RC Number:",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.pinkAccent,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text("${orders[index].rcNumber}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddVehicleDetails(
                                              token: this.widget.token,
                                              userMobi: this.widget.mobileNum,
                                              vehicleName:
                                                  orders[index].vehicleName,
                                              vehicleNumber:
                                                  orders[index].vehicleNumber,
                                              rcNumber: orders[index].rcNumber,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.pinkAccent,
                                      ),
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white),
                                      ),
                                    )
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
      child: iconText,
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.all(5),
        shape: StadiumBorder(),
      ),
    );
  }

  // Widget orderStatus(String status) {
  //   Icon icon;
  //   Color color;

  //   if (status == "P" || status == "Processing" || status == "On-Hold") {
  //     icon = Icon(
  //       Icons.timer,
  //       color: Colors.orange,
  //     );
  //     color = Colors.orange;
  //   } else if (status == "D" || status == "Deliverd") {
  //     icon = Icon(
  //       Icons.check,
  //       color: Colors.green,
  //     );
  //     color = Colors.green;
  //   } else if (status == "C" || status == "Cancelled") {
  //     icon = Icon(
  //       Icons.clear,
  //       color: Colors.redAccent,
  //     );
  //     color = Colors.redAccent;
  //   } else {
  //     icon = Icon(
  //       Icons.clear,
  //       color: Colors.redAccent,
  //     );
  //     color = Colors.redAccent;
  //   }
  //   return iconData(
  //       icon,
  //       Text(
  //         "Order Status :$status",
  //         style: TextStyle(
  //           color: color,
  //           fontSize: 15,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ));
  // }
}
