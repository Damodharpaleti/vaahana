import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaahana/components/Cart_Provider.dart';
import 'package:vaahana/model/GetPincodeListModel.dart';
import 'package:vaahana/model/LoginRespose.dart';
import 'package:vaahana/pages/AddservicePincodes.dart';
import 'package:vaahana/pages/PickupOrders.dart';
import 'package:vaahana/utils/dataBase.dart';
import 'package:vaahana/widgets/drawer.dart';

class GetServicePinodeList extends StatefulWidget {
  final String? mobile;
  GetServicePinodeList({Key? key, this.mobile}) : super(key: key);
  @override
  State<GetServicePinodeList> createState() => _GetServicePinodeListState();
}

class _GetServicePinodeListState extends State<GetServicePinodeList> {
  List<UserdatafromDB> list = <UserdatafromDB>[];
  final dbHelper = DBProvider.instance;
  late UserdatafromDB model;
  bool listselection = true;

  @override
  void initState() {
    super.initState();
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.fetchVendorPincodes();
  }

  Future<bool> _onbackpress() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PickUpOrders(key: UniqueKey(), status: "P")));
    return Future.value(true);  }

  @override
  Widget build(BuildContext context) {
    return new Consumer<CartProvider>(builder: (context, pincodeModel, child) {
      if (pincodeModel.getVendorpincodeList.length > 0 &&
          pincodeModel.getVendorpincodeList.length == pincodeModel.pcount) {
        _listview(
            context, pincodeModel.getVendorpincodeList, pincodeModel.pcount);
      } else {
        loginreturn();
        // var orderProvider = Provider.of<CartProvider>(context, listen: false);
        // orderProvider.fetchVendorPincodes();
      }
      return Column(
        children: [
          WillPopScope(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                      title: Text(
                        'Service Pincodes',
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
                                pincodeModel.getVendorpincodeList,
                                pincodeModel.pcount))),
              ),
              onWillPop: _onbackpress),
        ],
      );
    });
  }

  Widget loginreturn() {
    return Center(
        child: AddservicePincodes(
      mobile: this.widget.mobile,
    ));
  }

  Widget _listview(BuildContext context,
      List<GetPinocodeListModel> getvendorspinList, int pcount) {
    return getvendorspinList.length == 0
        ? Center(
            child: Text('Picode Details Not avaliable',
                style: TextStyle(fontSize: 20, color: Colors.black)))
        : new ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddservicePincodes(
                                      mobile: this.widget.mobile,
                                    )));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                      ),
                      child: Text("Add New Pincodes",
                          style: TextStyle(fontSize: 20, color: Colors.white))),
                ],
              ),
              Text("List of service pincodes",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              ListView.builder(
                  itemCount: pcount,
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
                                          "Transport Name :",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.pinkAccent[200],
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text(
                                        "${getvendorspinList[index].partnerName}",
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
                                          "Transport Mobile No:",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.pinkAccent[200],
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text(
                                        "${getvendorspinList[index].partnerMobNum}",
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
                                          "Name:",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.pinkAccent[200],
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text(
                                        "${getvendorspinList[index].vendorName}",
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
                                          "Mobile No:",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.pinkAccent[200],
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text(
                                        "${getvendorspinList[index].mobileNumber}",
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
                                          "address:",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.pinkAccent[200],
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text("${getvendorspinList[index].address}",
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
                                          "Service Pincode:",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.pinkAccent[200],
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text(
                                        "${getvendorspinList[index].postalcode}",
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
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.all(5),
        shape: StadiumBorder(),
      ),
      child: iconText,
    );
  }
}
