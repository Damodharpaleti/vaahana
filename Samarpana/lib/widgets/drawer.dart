import 'dart:ui';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/pages/Delivery_status.dart';
import 'package:Samarpana/pages/Oders_deleverd.dart';
import 'package:Samarpana/pages/Order_Cancel.dart';
import 'package:Samarpana/pages/Order_detailsPage.dart';
import 'package:Samarpana/pages/home.dart';
import 'package:Samarpana/pages/loggin.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  @override
  DrawerWidgetState createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget> {
  List<UserdatafromDB> list = new List();
  final dbHelper = DBProvider.instance;
  UserdatafromDB model;
  String cancel = "C";
  String delivery = "D";
  String pending = "P";
  @override
  void initState() {
    fetch();
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
    allRows.forEach((row) => {
          print(allRows),
          model = UserdatafromDB(
            row["id"].toString(),
            row["firstName"],
            row["lastName"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
          ),
          list.add(model)
        });
    setState(() {});
  }

  // List<String> listHeader = ['Student Record'];
  Widget gridHeader() {
    return ListView.builder(
        itemCount: list.length,
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
                            child: Image.asset('assets/images/icon.png',
                                width: 100, height: 100, fit: BoxFit.fill),
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            list[index].firstName + " " + list[index].lastName,
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
                new Divider(
                  color: Colors.indigo,
                ),
                ListTile(
                  leading: Icon(
                    Icons.history,
                    size: 30,
                    color: const Color(0xff312562),
                  ),
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
                        builder: (context) => OrderStatus(
                          status: pending,
                        ),
                      ),
                    );
                  },
                ),
                new Divider(
                  color: Colors.indigo,
                ),
                ListTile(
                  leading: Icon(
                    Icons.history,
                    size: 30,
                    color: const Color(0xff312562),
                  ),
                  title: new Text(
                    'Delivery Orders',
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
                        builder: (context) => OrderDetailsDeleverd(
                          status: delivery,
                        ),
                      ),
                    );
                  },
                ),
                new Divider(
                  color: Colors.indigo,
                ),
                ListTile(
                  leading: Icon(
                    Icons.cancel_outlined,
                    size: 30,
                    color: const Color(0xff312562),
                  ),
                  title: new Text(
                    'Cancel Orders',
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
                        builder: (context) => OrderDetailsCancel(
                          status: cancel,
                        ),
                      ),
                    );
                  },
                ),
                new Divider(
                  color: Colors.indigo,
                ),
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
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Suyoga Samarpana"),
          content: new Text("Are you sure you want to Logout"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("YES"),
              onPressed: () {
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
