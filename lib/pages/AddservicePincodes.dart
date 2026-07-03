import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaahana/api_service.dart';
import 'package:vaahana/components/Cart_Provider.dart';
import 'package:vaahana/model/addNewservicePincodeModel.dart';
import 'package:vaahana/pages/GetservicePincodesList.dart';
import 'package:vaahana/utils/ProgressHUD.dart';
import 'package:vaahana/utils/dataBase.dart';
import 'package:vaahana/utils/form_helper.dart';

class AddservicePincodes extends StatefulWidget {
  AddservicePincodes({this.mobile, Key? key}) : super(key: key);
  final String? mobile;
  @override
  State<AddservicePincodes> createState() => _AddservicePincodesState();
}

class _AddservicePincodesState extends State<AddservicePincodes> {
  final dbHelper = DBProvider.instance;
  late APIService apiService;
  bool isApicallProcess = false;

  late SharedPreferences sharedPrefs;
  late AddNewPincodes addNewPincodes;
  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    addNewPincodes = new AddNewPincodes();
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
            'Add Pincode',
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
                      // CircleAvatar(
                      //   backgroundColor: Colors.transparent,
                      //   radius: 50,
                      //   child: Image.asset('assets/images/vahana-logo.png',
                      //       width: 100, height: 100, fit: BoxFit.fill),
                      // ),
                      Text("Add New service Pincodes Here",
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 15,
                      ),

                      FormHelper.textInput(
                        context,
                        addNewPincodes.postalcode ?? '',
                        (value) => {this.addNewPincodes.postalcode = value},
                        onValidate: (value) {
                          if (value.toString().isEmpty) {
                            return "Please Enter New Service Pincode";
                          }
                          return null;
                        },
                        hintText: "New Pincode",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        addNewPincodes.address1 ?? '',
                        (value) => {this.addNewPincodes.address1 = value},
                        onValidate: (value) {
                          if (value.toString().isEmpty) {
                            return "Please Enter Pincode address";
                          }
                          return null;
                        },
                        hintText: "Address",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),

                      new Center(
                        child: FormHelper.saveButton("Submit", () {
                          if (validateandSave()) {
                            setState(() {
                              isApicallProcess = true;
                              print("aa");
                              this.addNewPincodes.mobileNumber =
                                  this.widget.mobile;
                            });
                            this.addNewPincodes.mobileNumber =
                                this.widget.mobile;
                            apiService
                                .addservicePindoces(addNewPincodes)
                                .then((ret) {
                              setState(() {
                                isApicallProcess = false;
                              });
                              var orderProvider = Provider.of<CartProvider>(
                                  context,
                                  listen: false);
                              orderProvider.fetchVendorPincodes();
                              FormHelper.showMessage(
                                  context, "SUYOGA", ret.message ?? '', "OK", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GetServicePinodeList()),
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
