import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:vaahana/components/Cart_Provider.dart';
import 'package:vaahana/model/AddVehicleDetailsModel.dart';
import 'package:vaahana/model/LoginRespose.dart';
import 'package:vaahana/pages/getDriverVehiclePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaahana/api_service.dart';
import 'package:vaahana/utils/ProgressHUD.dart';
import 'package:vaahana/utils/dataBase.dart';
import 'package:vaahana/components/globals.dart' as globals;
import 'package:http/http.dart' as http;
import '../utils/form_helper.dart';

class AddVehicleDetails extends StatefulWidget {
  AddVehicleDetails({
      Key? key,
      this.userMobi,
      this.vehicleName,
      this.rcNumber,
      this.vehicleNumber,
      this.token})
      : super(key: key);
  final String? userMobi;
  final String? vehicleName;
  final String? vehicleNumber;
  final String? rcNumber;
  final String? token;

  @override
  _AddVehicleDetailsState createState() => _AddVehicleDetailsState();
}

class _AddVehicleDetailsState extends State<AddVehicleDetails> {
  final dbHelper = DBProvider.instance;
  late APIService apiService;
  bool isApicallProcess = false;
  bool hidePassword = true;
  // User usersignup;
  late UserdatafromDB model;
  List<UserdatafromDB> list = <UserdatafromDB>[];
  late SharedPreferences sharedPrefs;
  late AddVehicleDetailsModel addVehicledetailsmodel;
  late String mySelection;
  @override
  void initState() {
    super.initState();
    fetch();
    apiService = new APIService();
    // usersignup = new User();
    addVehicledetailsmodel = new AddVehicleDetailsModel();
    getSWData();
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
  String url =
      "http://34.229.63.210:8087/vaahanaService/Vehicle/v1/getDriverDetails?userId=" +
          globals.GlobaluserId;
  List data = [];
  Future<String> getSWData() async {
    var res = await http
        .get(Uri.parse(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);
    setState(() {
      data = resBody;
    });
    print(resBody);
    return "Sucess";
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color.fromRGBO(123, 212, 165, 1),
          title: Text(
            'Add Vehicle Details',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: ProgressHUD(
            child: new Form(
              key: _formkey,
              child: formui(),
            ),
            inAsyncCall: isApicallProcess,
            opacity: 0.3));
  }

  Widget formui() {
    return Stack(children: [
      // BackgroundImage(
      //   image: 'assets/images/grocery.jpg',
      // ),
      Scaffold(
          backgroundColor: Colors.blueGrey[100],
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50,
                        child: Image.asset('assets/images/vahana-logo.png',
                            width: 100, height: 100, fit: BoxFit.fill),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // FormHelper.textInput(
                      //   context,
                      //   addVehicledetailsmodel.transportMobNumber,
                      //   (value) => {
                      //     this.addVehicledetailsmodel.transportMobNumber = value
                      //   },
                      //   onValidate: (value) => value.length < 10
                      //       ? "Please Enter Valid TransPort MobNumber"
                      //       : null,
                      //   hintText: "TransPort MobNumber",
                      //   hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                      //   prefixIcon: Icon(
                      //     Icons.phone,
                      //     color: Colors.black,
                      //     size: 30,
                      //   ),
                      // ),

                      // Padding(
                      //   padding: const EdgeInsets.all(8),
                      //   child: new DropdownButton(
                      //     dropdownColor: Colors.green,
                      //     focusColor: Colors.red,

                      //     items: data.map((item) {
                      //       return new DropdownMenuItem(
                      //         child: new Text(
                      //           item['driverName'],
                      //           style: TextStyle(
                      //               color: Colors.black,
                      //               fontSize: 22,
                      //               fontWeight: FontWeight.w600),
                      //         ),
                      //         value: item['driverMobNumber'].toString(),
                      //       );
                      //     }).toList(),

                      //     //isExpanded: true,
                      //     hint: Text(
                      //       "Select Driver",
                      //       style: TextStyle(color: Colors.black),
                      //     ),

                      //     onChanged: (newVal) {
                      //       setState(() {
                      //         mySelection = newVal;
                      //         // saveSharedPref(newVal);
                      //         print(">>>>>>>>>>>>>>>>>>");
                      //         print(mySelection);
                      //         print(">>>>>>>>>>>>>>>>>>");
                      //       });
                      //     },
                      //     value: mySelection,
                      //   ),
                      // ),
                      // FormHelper.textInput(
                      //   context,
                      //   addVehicledetailsmodel.driverMobNumber,
                      //   (value) => {
                      //     this.addVehicledetailsmodel.driverMobNumber = value
                      //   },
                      //   onValidate: (value) => value.length < 10
                      //       ? "Please Enter Valid Driver MobNumber"
                      //       : null,
                      //   hintText: "Driver MobNumber",
                      //   hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                      //   prefixIcon: Icon(
                      //     Icons.phone,
                      //     color: Colors.black,
                      //     size: 30,
                      //   ),
                      // ),
                      FormHelper.textInput(
                        context,
                        addVehicledetailsmodel.vehicleName =
                            this.widget.vehicleName ?? '',
                        (value) =>
                            {this.addVehicledetailsmodel.vehicleName = value},
                        onValidate: (value) {
                          if (value.toString().isEmpty) {
                            return "Please Enter Vehicle Name";
                          }
                          return null;
                        },
                        hintText: "Vehicle Name",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.car_rental,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        addVehicledetailsmodel.vehicleNumber =
                            this.widget.vehicleNumber ?? '',
                        (value) =>
                            {this.addVehicledetailsmodel.vehicleNumber = value},
                        onValidate: (value) {
                          if (value.toString().isEmpty) {
                            return "Please Enter vehicle Number";
                          }
                          return null;
                        },
                        hintText: "vehicle Number",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.pedal_bike,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        addVehicledetailsmodel.rcNumber = this.widget.rcNumber ?? '',
                        (value) =>
                            {this.addVehicledetailsmodel.rcNumber = value},
                        onValidate: (value) {
                          if (value.toString().isEmpty) {
                            return "Please Enter RCNumber";
                          }
                          return null;
                        },
                        hintText: "RC Number",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.sim_card_rounded,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      new Center(
                        child: FormHelper.saveButton("Submit", () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? MobNumber = prefs.getString("LoginMobNumber");
                          if (validateandSave()) {
                            setState(() {
                              this.addVehicledetailsmodel.transportMobNumber =
                                  "9012345678";

                              this.addVehicledetailsmodel.driverMobNumber =
                                  MobNumber;

                              isApicallProcess = true;
                              print("aa");
                              print(addVehicledetailsmodel);
                            });
                            apiService
                                .uploadVehicleDetails(addVehicledetailsmodel)
                                .then((ret) {
                              setState(() {
                                isApicallProcess = false;
                              }
                              );
                              FormHelper.showMessage(
                                  context,
                                  "SUYOGA",
                                  "Vehicle Details Updated succesfully",
                                  "OK", () {
                                var orderProvider = Provider.of<CartProvider>(
                                    context,
                                    listen: false);
                                orderProvider.fetchDriverVehicle();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          getDriversVehiclePage(
                                            mobileNum: this.widget.userMobi ?? '',
                                            status: 'P',
                                            token: this.widget.token ?? '',
                                          )),
                                );
                              });
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => OTP(
                              //       user: usersignup,
                              //     ),
                              //   ),
                              // );
                                                        });
                          }
                        }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ))
    ]);
  }

  bool validateandSave() {
    final form = _formkey.currentState;
    if (form?.validate() ?? false) {
      form?.save();
      return true;
    }
    return false;
  }
}
