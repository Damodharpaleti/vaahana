import 'package:vaahana/model/addDriverDetailsModel.dart';
import 'package:vaahana/pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaahana/api_service.dart';
import 'package:vaahana/utils/ProgressHUD.dart';
import 'package:vaahana/utils/dataBase.dart';
import 'package:vaahana/components/globals.dart' as globals;
import '../utils/form_helper.dart';

// class AddDriverDetails extends StatefulWidget {
//   @override
//   _AddDriverDetailsState createState() => _AddDriverDetailsState();
// }

// class _AddDriverDetailsState extends State<AddDriverDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class AddDriverDetails extends StatefulWidget {
  @override
  _AddDriverDetailsState createState() => _AddDriverDetailsState();
}

class _AddDriverDetailsState extends State<AddDriverDetails> {
  final dbHelper = DBProvider.instance;
  late APIService apiService;
  bool isApicallProcess = false;
  bool hidePassword = true;
  // User usersignup;

  late SharedPreferences sharedPrefs;
  late addDriverDetailsModel adddriverdetailsmodel;
  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    // usersignup = new User();
    adddriverdetailsmodel = new addDriverDetailsModel();
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text("Add Driver Details"),
            centerTitle: true,
            elevation: 2,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => LoginPage(),
                //   ),
                // );
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          backgroundColor: Colors.blueGrey[100],
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 6, top: 2, right: 6),
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
                        height: 10,
                      ),
                      FormHelper.textInput(
                        context,
                        adddriverdetailsmodel.firstName ?? '',
                        (value) =>
                            {this.adddriverdetailsmodel.firstName = value},
                        onValidate: (value) =>
                            value.length < 2 ? "Please Enter FirstName" : null,
                        hintText: "First Name",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        adddriverdetailsmodel.lastName ?? '',
                        (value) =>
                            {this.adddriverdetailsmodel.lastName = value},
                        onValidate: (value) =>
                            value.length < 1 ? "Please Enter last name" : null,
                        hintText: "Last Name",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        adddriverdetailsmodel.mobileNumber ?? '',
                        (value) =>
                            {this.adddriverdetailsmodel.mobileNumber = value},
                        onValidate: (value) => value.length < 10
                            ? "Please Enter Valid Drive MobNumber"
                            : null,
                        hintText: "Driver MobNumber",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        adddriverdetailsmodel.emailId ?? '',
                        (value) => {this.adddriverdetailsmodel.emailId = value},
                        onValidate: (value) => value.length < 5
                            ? "Please Enter Valid Email"
                            : null,
                        hintText: "Email Id",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        adddriverdetailsmodel.location ?? '',
                        (value) =>
                            {this.adddriverdetailsmodel.location = value},
                        onValidate: (value) => value.length < 3
                            ? "Please Enter Valid Location"
                            : null,
                        hintText: "Location",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        adddriverdetailsmodel.address ?? '',
                        (value) => {this.adddriverdetailsmodel.address = value},
                        onValidate: (value) => value.length < 3
                            ? "Please Enter Valid address"
                            : null,
                        hintText: "Address",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        adddriverdetailsmodel.pinCode ?? '',
                        (value) => {this.adddriverdetailsmodel.pinCode = value},
                        onValidate: (value) => value.length < 3
                            ? "Please Enter Valid Pincode"
                            : null,
                        hintText: "Pincode",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        adddriverdetailsmodel.state ?? '',
                        (value) => {this.adddriverdetailsmodel.state = value},
                        onValidate: (value) => value.length < 1
                            ? "Please Enter Valid State"
                            : null,
                        hintText: "State",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      // FormHelper.textInput(
                      //   context,
                      //   adddriverdetailsmodel.transporterMobNum,
                      //   (value) => {
                      //     this.adddriverdetailsmodel.transporterMobNum = value
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
                      FormHelper.textInput(
                        context,
                        adddriverdetailsmodel.dlNumber ?? '',
                        (value) =>
                            {this.adddriverdetailsmodel.dlNumber = value},
                        onValidate: (value) {
                          if (value.toString().isEmpty) {
                            return "Please Enter DL Number";
                          }
                          return null;
                        },
                        hintText: "DL Number",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      new Center(
                        child: FormHelper.saveButton("Add", () {
                          if (validateandSave()) {
                            setState(() {
                              isApicallProcess = true;
                              this.adddriverdetailsmodel.transporterMobNum =
                                  globals.GlobaluserId;
                              print("aa");
                              print(adddriverdetailsmodel);
                            });
                            apiService
                                .uploaddriverdetails(adddriverdetailsmodel)
                                .then((ret) {
                              setState(() {
                                isApicallProcess = false;
                              });
                              FormHelper.showMessage(
                                  context,
                                  "SUYOGA",
                                  "Driver details added Successfull",
                                  "OK", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
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
