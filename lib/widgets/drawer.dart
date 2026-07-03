import 'package:vaahana/components/Cart_Provider.dart';
import 'package:vaahana/model/LoginRespose.dart';
import 'package:vaahana/pages/GetservicePincodesList.dart';
import 'package:vaahana/pages/PickupOrders.dart';
import 'package:vaahana/pages/getDriverVehiclePage.dart';
import 'package:vaahana/pages/loggin.dart';
import 'package:vaahana/utils/dataBase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  @override
  DrawerWidgetState createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget> {
  List<UserdatafromDB> list = <UserdatafromDB>[];
  final dbHelper = DBProvider.instance;
  late UserdatafromDB model;
  @override
  void initState() {
    super.initState();
    fetch();
    // var orderProvider = Provider.of<CartProvider>(context, listen: false);
    // orderProvider.fetchVendorPincodes();
    // orderProvider.fetchMyStatus(status: "P");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: gridHeader(),
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
    );
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
    setState(() {});
  }

  Widget gridHeader() {
    if (list.isNotEmpty) {
      return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return new Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.22,
                  width: double.infinity,
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            child: Image.asset('assets/images/vahana-logo.png',
                                width: 100, height: 100, fit: BoxFit.fill),
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            list[index].name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            list[index].mobileNumber,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )),
                ),
                Divider(
                  color: Colors.indigo,
                ),
                ListTile(
                  // leading: Icon(
                  //   Icons.border_outer_rounded,
                  //   size: 30,
                  //   color: const Color(0xff312562),
                  // ),
                  title: new Text(
                    'Vehicle Details',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: const Color(0xff312562),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Open Sans',
                        fontSize: 15),
                  ),
                  onTap: () {
                    var orderProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    orderProvider.fetchDriverVehicle();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => getDriversVehiclePage(
                            mobileNum: list[index].mobileNumber,
                          token: model.token,
                          status: "P"),
                      ),
                    );
                                      // Navigator.of(context).pop();
                  },
                ),
                new Divider(
                  color: Colors.indigo,
                ),
                // ListTile(
                //   // leading: Icon(
                //   //   Icons.border_outer_rounded,
                //   //   size: 30,
                //   //   color: const Color(0xff312562),
                //   // ),
                //   title: new Text(
                //     'Add License',
                //     textAlign: TextAlign.left,
                //     style: TextStyle(
                //         color: const Color(0xff312562),
                //         fontWeight: FontWeight.w700,
                //         fontFamily: 'Open Sans',
                //         fontSize: 15),
                //   ),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     // Navigator.push(
                //     //   context,
                //     //   MaterialPageRoute(
                //     //     builder: (context) => MyOrderDetails(
                //     //         //  status: pending,
                //     //         ),
                //     //   ),
                //     // );
                //   },
                // ),
                // new Divider(
                //   color: Colors.indigo,
                // ),
                ListTile(
                  // leading: Icon(
                  //   Icons.border_outer_rounded,
                  //   size: 30,
                  //   color: const Color(0xff312562),
                  // ),
                  title: new Text(
                    'Add Service Pincode',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: const Color(0xff312562),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Open Sans',
                        fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GetServicePinodeList(
                            //  status: pending,
                            mobile: model.mobileNumber),
                      ),
                    );
                  },
                ),
                new Divider(
                  color: Colors.indigo,
                ),
                ListTile(
                  // leading: Icon(
                  //   Icons.border_outer_rounded,
                  //   size: 30,
                  //   color: const Color(0xff312562),
                  // ),
                  title: new Text(
                    'My Wallet',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: const Color(0xff312562),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Open Sans',
                        fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     //WalletUIscreen
                    //     //WalletScreen
                    //     builder: (context) => WalletUIscreen(),
                    //   ),
                    // );
                  },
                ),
                new Divider(
                  color: Colors.indigo,
                ),
                ListTile(
                  // leading: Icon(
                  //   Icons.border_outer_rounded,
                  //   size: 30,
                  //   color: const Color(0xff312562),
                  // ),
                  title: new Text(
                    'Transaction History',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: const Color(0xff312562),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Open Sans',
                        fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     //WalletUIscreen
                    //     //WalletScreen
                    //     builder: (context) => Transactiondetails(),
                    //   ),
                    // );
                  },
                ),
                new Divider(
                  color: Colors.indigo,
                ),
                ListTile(
                  // leading: Icon(
                  //   Icons.border_outer_rounded,
                  //   size: 30,
                  //   color: const Color(0xff312562),
                  // ),
                  title: new Text(
                    'Pending Orders',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: const Color(0xff312562),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Open Sans',
                        fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PickUpOrders(
                            key: UniqueKey(),
                            status: "P"),
                      ),
                    );
                  },
                ),
                new Divider(
                  color: Colors.indigo,
                ),
                ListTile(
                  // leading: Icon(
                  //   Icons.history,
                  //   size: 30,
                  //   color: const Color(0xff312562),
                  // ),
                  title: new Text(
                    'Accepted Orders',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: const Color(0xff312562),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Open Sans',
                        fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => OrderDetailsDeleverd(
                    //       status: delivery,
                    //     ),
                    //   ),
                    // );
                  },
                ),
                new Divider(
                  color: Colors.indigo,
                ),
                ListTile(
                  // leading: Icon(
                  //   Icons.cancel_outlined,
                  //   size: 30,
                  //   color: const Color(0xff312562),
                  // ),
                  title: new Text(
                    'Rejected Orders',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: const Color(0xff312562),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Open Sans',
                        fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => OrderDetailsCancel(
                    //       status: cancel,
                    //     ),
                    //   ),
                    // );
                  },
                ),
                new Divider(
                  color: Colors.indigo,
                ),
                // ListTile(
                //   // leading: Icon(
                //   //   Icons.lock,
                //   //   size: 30,
                //   //   color: const Color(0xff312562),
                //   // ),
                //   title: new Text(
                //     'Update Password',
                //     textAlign: TextAlign.left,
                //     style: TextStyle(
                //         color: const Color(0xff312562),
                //         fontWeight: FontWeight.w700,
                //         fontFamily: 'Open Sans',
                //         fontSize: 15),
                //   ),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => UpdatePassword(),
                //       ),
                //     );
                //   },
                // ),
                // new Divider(
                //   color: Colors.indigo,
                // ),
                ListTile(
                    leading: Icon(
                      Icons.logout,
                      size: 30,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Logout',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: const Color(0xff312562),
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Open Sans',
                          fontSize: 15),
                    ),
                    onTap: () {
                      _showDialog();
                      print("Existing user details deleted");
                    }),
              ],
            ),
          );
        });
    } else {
      return SizedBox();
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Suyoga Samarpana"),
          content: Text("Are you sure you want to Logout"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("YES"),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("LoginMobNumber");

                print(prefs.getString("cont_refId"));
                prefs.remove("cont_refId");
                dbHelper.userdelete();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
              },
            ),
          ],
        );
      },
    );
  }
}
