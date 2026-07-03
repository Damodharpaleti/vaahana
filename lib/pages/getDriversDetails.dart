import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vaahana/components/Cart_Provider.dart';
import 'package:vaahana/model/GetDriverDetailsModel.dart';
import 'package:vaahana/model/LoginRespose.dart';
import 'package:vaahana/model/PickupOrdersModel.dart';
import 'package:vaahana/pages/loggin.dart';
import 'package:vaahana/utils/dataBase.dart';
import 'package:vaahana/widgets/drawer.dart';

class getDriversDetails extends StatefulWidget {
  final String status;
  final PickupkissanOrders pickupkissanOrders;
  
  getDriversDetails({Key? key, required this.status, required this.pickupkissanOrders}) : super(key: key);
  
  @override
  _getDriversDetailsState createState() => _getDriversDetailsState();
}

class _getDriversDetailsState extends State<getDriversDetails> {
  List<UserdatafromDB> list = <UserdatafromDB>[];
  final dbHelper = DBProvider.instance;
  late UserdatafromDB model;
  late bool listselection;

  @override
  void initState() {
    super.initState();

    // fetch();
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.fetchMyDriverList();
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
    return new Consumer<CartProvider>(
        builder: (context, GetDriverDetailsModel, child) {
      if (GetDriverDetailsModel.DriversList.length > 0) {
        _listview(context, GetDriverDetailsModel.DriversList,
            GetDriverDetailsModel.count);
        listselection = true;
      } else {
        //  loginreturn();
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
                      backgroundColor: Colors.green,
                      title: Text(
                        'Driver Details',
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
                        margin: EdgeInsets.all(10),
                        // child:_single(),
                        child: _listview(
                            context,
                            GetDriverDetailsModel.DriversList,
                            GetDriverDetailsModel.count)),
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
                    'Driver Details',
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                body: Container(
                    padding: EdgeInsets.only(top: 80, left: 130),
                    // child:_single(),
                    // child: loginreturn()
                    child: Text("Driver Details Not Found")),
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
      BuildContext context, List<GetDriverDetailsModel> orders, int count) {
    return orders.length == 0
        ? Center(
            child: Text('Driver Details Not avaliable',
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
                                          color: Colors.green,
                                          size: 14,
                                        ),
                                        Text(
                                          "Driver Name :",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text("${orders[index].driverName}",
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
                                          Icons.phone_android,
                                          color: Colors.green,
                                          size: 12,
                                        ),
                                        Text(
                                          "Driver Mobile Num:",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text("${orders[index].driverMobNumber}",
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
                                          color: Colors.green,
                                          size: 12,
                                        ),
                                        Text(
                                          "DL Number :",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text("${orders[index].dlNumber}",
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
                                          Icons.emoji_transportation_sharp,
                                          color: Colors.green,
                                          size: 12,
                                        ),
                                        Text(
                                          "Transport Name:",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green,
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
