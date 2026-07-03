import 'dart:io';

import 'package:dio/dio.dart';
import 'package:vaahana/model/Vendor_AccountModel.dart';
import 'package:vaahana/pages/LoginPage_OTP.dart';
import 'package:flutter/material.dart';
import 'package:vaahana/api_service.dart';
import 'package:vaahana/model/LoginRespose.dart';
import 'package:vaahana/pages/SignUp_page.dart';
import 'package:vaahana/utils/ProgressHUD.dart';
import 'package:vaahana/utils/dataBase.dart';
import 'package:flutter/services.dart';
import 'package:vaahana/utils/form_helper.dart';
import 'package:vaahana/utils/already_have_an_account_acheck.dart';

import '../config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dbHelper = DBProvider.instance;
  List<LoginResponse> user = [];
  bool hidePassword = true;
  bool isApiCallProcess = false;
  late APIService apiService;
  late String password;
  late String username;
  String pending = "P";
  late CreateContact createContact;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Contactadded contactadded;
  late List<String> citylist;
  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    getpartnersList();
    citylist = [];
    createContact = new CreateContact();
    contactadded = new Contactadded();
  }

  Future<String> getpartnersList() async {
    try {
      String url = Config.url + Config.getPartnercityist;
      var response = await Dio().get(url,
          options: new Options(
              headers: {HttpHeaders.contentTypeHeader: 'application/json'}));
      if (response.statusCode == 200) {
        citylist = List<String>.from(response.data);
      }
      return "Success";
    } on DioError catch (e) {
      print("no new one");
      print(e.response);
      return "Error";
    }
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
    return ProgressHUD(
      child: WillPopScope(child: _uiSetup(context), onWillPop: _onbackpress),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Stack(
      key: scaffoldKey,
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(123, 212, 165, 1),
            title: Text(
              "Vaahana",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 2,
          ),
          backgroundColor: Colors.blueGrey[100],
          body: SingleChildScrollView(
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Form(
                        key: globalFormKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 60),
                            Text(
                              "Welcome To Vaahana",
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 95, 167, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 70,
                              child: Image.asset(
                                  'assets/images/vahana-logo.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    height: 100,
                                    child: TextFormField(
                                      inputFormatters: [
                                        new LengthLimitingTextInputFormatter(
                                            10),
                                      ],
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Icon(
                                              Icons.phone,
                                              size: 26,
                                              color: Colors.black,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    255, 95, 167, 1),
                                              )),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(14)),
                                          hintText: "Mobile Number ",
                                          hintStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 19,
                                          )),
                                      onSaved: (input) => username = input ?? '',
                                      validator: (input) => (input?.length ?? 0) < 10
                                          ? 'Please Enter Mobile Number'
                                          : null,
                                      style: TextStyle(color: Colors.black),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                  // GestureDetector(
                                  //   onTap: () => Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => ForgotPassword(),
                                  //     ),
                                  //   ),
                                  //   child: Text(
                                  //     'Forgot Password',
                                  //     style: TextStyle(
                                  //         fontSize: 20,
                                  //         color:
                                  //             Color.fromRGBO(255, 95, 167, 1),
                                  //         fontWeight: FontWeight.bold),
                                  //   ),
                                  // ),
                                  SizedBox(height: 15),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 60),
                              ),
                              onPressed: () {
                                if (validateAndSave()) {
                                  setState(() {
                                    isApiCallProcess = true;
                                  });
                                  apiService.loginOTP(username).then((ret) {
                                    setState(() {
                                      isApiCallProcess = false;
                                    });
                                    if (ret) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginOTP(
                                            user: username,
                                          ),
                                        ),
                                      );

                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => OTP(
                                      //       user: usersignup,
                                      //     ),
                                      //   ),
                                      // );
                                    } else {
                                      FormHelper.showMessage(
                                          context,
                                          "SUYOGA",
                                          "Mobile Number Not Registered",
                                          "OK", () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return SignUPThroughLogin(
                                                mobileNumber: username,
                                              );
                                            },
                                          ),
                                        );
                                      });
                                    }
                                  });
                                }
                              },
                              child: Text(
                                "Generate OTP",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            AlreadyHaveAccountCheck(
                              key: UniqueKey(),
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SignUP(
                                        mobileNumber: username,
                                        citylist: this.citylist,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  // Widget _uiSetup(BuildContext context) {
  //   return Stack(
  //     key: scaffoldKey,
  //     children: [
  //       BackgroundImage(
  //         image: 'assets/images/grocery.jpg',
  //       ),
  //       Scaffold(
  //         backgroundColor: Colors.transparent,
  //         body: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: <Widget>[
  //               Stack(
  //                 children: <Widget>[
  //                   Container(
  //                     width: double.infinity,
  //                     child: Form(
  //                       key: globalFormKey,
  //                       child: Column(
  //                         children: <Widget>[
  //                           SizedBox(height: 60),
  //                           Text(
  //                             "Welcome To Samarpana",
  //                             style: TextStyle(
  //                                 color: Colors.red,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 26),
  //                           ),
  //                           CircleAvatar(
  //                             backgroundColor: Colors.transparent,
  //                             radius: 70,
  //                             child: Image.asset('assets/images/icon.png',
  //                                 width: 100, height: 100, fit: BoxFit.fill),
  //                           ),
  //                           SizedBox(height: 20),
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               Padding(
  //                                 padding: EdgeInsets.symmetric(vertical: 10.0),
  //                                 child: Container(
  //                                   height: 60,
  //                                   width: double.infinity,
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.grey.withOpacity(0.5),
  //                                     borderRadius: BorderRadius.circular(16),
  //                                   ),
  //                                   child: TextFormField(
  //                                     onSaved: (input) => username = input,
  //                                     validator: (input) => input.length < 10
  //                                         ? "Please Enter Valid Mobile Number"
  //                                         : null,
  //                                     decoration: InputDecoration(
  //                                         errorStyle: TextStyle(
  //                                           color: Colors.white,
  //                                           fontWeight: FontWeight.bold,
  //                                           fontSize: 12,
  //                                         ),
  //                                         prefixIcon: Padding(
  //                                           padding: EdgeInsets.symmetric(
  //                                               horizontal: 20),
  //                                           child: Icon(
  //                                             Icons.phone,
  //                                             size: 26,
  //                                             color: Colors.white,
  //                                           ),
  //                                         ),
  //                                         border: InputBorder.none,
  //                                         hintText: "Mobile Number",
  //                                         hintStyle: TextStyle(
  //                                           color: Colors.white,
  //                                           fontSize: 19,
  //                                         )),
  //                                     style: TextStyle(color: Colors.white),
  //                                     keyboardType: TextInputType.emailAddress,
  //                                     textInputAction: TextInputAction.next,
  //                                     cursorColor: Colors.white,
  //                                   ),
  //                                 ),
  //                               ),
  //                               Padding(
  //                                 padding: EdgeInsets.symmetric(vertical: 10.0),
  //                                 child: Container(
  //                                   height: 60,
  //                                   width: double.infinity,
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.grey[500].withOpacity(0.3),
  //                                     borderRadius: BorderRadius.circular(16),
  //                                   ),
  //                                   child: TextFormField(
  //                                     onSaved: (input) => password = input,
  //                                     validator: (input) => input.length < 3
  //                                         ? "Password should be more than 3 characters"
  //                                         : null,
  //                                     obscureText: hidePassword,
  //                                     decoration: InputDecoration(
  //                                         errorStyle:
  //                                             TextStyle(color: Colors.white),
  //                                         prefixIcon: Padding(
  //                                           padding: EdgeInsets.symmetric(
  //                                               horizontal: 20),
  //                                           child: Icon(
  //                                             Icons.lock,
  //                                             size: 26,
  //                                             color: Colors.white,
  //                                           ),
  //                                         ),
  //                                         suffixIcon: IconButton(
  //                                           onPressed: () {
  //                                             setState(() {
  //                                               hidePassword = !hidePassword;
  //                                             });
  //                                           },
  //                                           color:
  //                                               Colors.white.withOpacity(0.9),
  //                                           icon: Icon(hidePassword
  //                                               ? Icons.visibility_off
  //                                               : Icons.visibility),
  //                                         ),
  //                                         border: InputBorder.none,
  //                                         hintText: "Password",
  //                                         hintStyle: TextStyle(
  //                                           color: Colors.white,
  //                                           fontSize: 19,
  //                                         )),
  //                                     style: TextStyle(color: Colors.white),
  //                                     keyboardType: TextInputType.name,
  //                                     textInputAction: TextInputAction.done,
  //                                     cursorColor: Colors.white,
  //                                   ),
  //                                 ),
  //                               ),
  //                               SizedBox(height: 1),
  //                               GestureDetector(
  //                                 onTap: () => Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                     builder: (context) => ForgotPassword(),
  //                                   ),
  //                                 ),
  //                                 child: Text(
  //                                   'Forgot Password',
  //                                   style: TextStyle(
  //                                       fontSize: 20, color: Colors.white),
  //                                 ),
  //                               ),
  //                               SizedBox(height: 35),
  //                             ],
  //                           ),
  //                           FlatButton(
  //                             padding: EdgeInsets.symmetric(
  //                                 vertical: 18, horizontal: 110),
  //                             onPressed: () async {
  //                               final SharedPreferences prefs =
  //                                   await SharedPreferences.getInstance();

  //                               //  print("deleted");
  //                               if (validateAndSave()) {
  //                                 setState(() {
  //                                   isApiCallProcess = true;
  //                                 });
  //                                 print(username + password);
  //                                 apiService
  //                                     .login(username, password)
  //                                     .then((value) => {
  //                                           print(prefs.getString("ROLE")),
  //                                           if (value != null &&
  //                                               prefs
  //                                                   .getString("ROLE")
  //                                                   .isNotEmpty)
  //                                             {
  //                                               if (prefs.getString("ROLE").contains("ROLE_DELIVERY_PARTNER") ||
  //                                                   prefs
  //                                                       .getString("ROLE")
  //                                                       .contains(
  //                                                           "ROLE_SAMARPANA_ADMIN") ||
  //                                                   prefs
  //                                                       .getString("ROLE")
  //                                                       .contains(
  //                                                           "ROLE_MANAGING_PARTNER"))
  //                                                 {
  //                                                   dbHelper
  //                                                       .userdelete()
  //                                                       .whenComplete(() =>
  //                                                           _insert(value)),
  //                                                   print(value.firstName),
  //                                                   FormHelper.showMessage(
  //                                                       context,
  //                                                       "Suyoga Samarpana",
  //                                                       "Login Successfull",
  //                                                       "OK", () {
  //                                                     Navigator.push(
  //                                                       context,
  //                                                       MaterialPageRoute(
  //                                                         builder: (context) =>
  //                                                             OrderStatus(
  //                                                           status: pending,
  //                                                         ),
  //                                                       ),
  //                                                     );
  //                                                   }),
  //                                                 }
  //                                               else
  //                                                 {
  //                                                   prefs.remove("ROLE"),
  //                                                   FormHelper.showMessage(
  //                                                       context,
  //                                                       "SUYOGA",
  //                                                       "Samarpana login Role does not assigned",
  //                                                       "OK", () {
  //                                                     _insert(value);
  //                                                     Navigator.push(
  //                                                       context,
  //                                                       MaterialPageRoute(
  //                                                         builder: (context) =>
  //                                                             LoginPage(),
  //                                                       ),
  //                                                     );
  //                                                   }),
  //                                                 }
  //                                             }
  //                                           else
  //                                             {
  //                                               prefs.remove("ROLE"),
  //                                               FormHelper.showMessage(
  //                                                   context,
  //                                                   "SUYOGA",
  //                                                   "Login Failed, Please Enter Valid Details",
  //                                                   "OK", () {
  //                                                 _insert(value);
  //                                                 Navigator.push(
  //                                                   context,
  //                                                   MaterialPageRoute(
  //                                                     builder: (context) =>
  //                                                         LoginPage(),
  //                                                   ),
  //                                                 );
  //                                               }),
  //                                             }
  //                                         });
  //                               }
  //                             },
  //                             child: Text(
  //                               "Sign In",
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 24,
  //                               ),
  //                             ),
  //                             color: Colors.green,
  //                             shape: StadiumBorder(),
  //                           ),
  //                           SizedBox(height: 15),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Future<Widget> _insert(LoginResponse cp) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setDouble("Walletamt", cp.walletamt);
  //   prefs.setString("LoginMobNumber", cp.mobileNumber);
  //   Map<String, dynamic> row = {
  //     DBProvider.columnId: cp.id,
  //     DBProvider.columnFirstName: cp.firstName,
  //     DBProvider.columnLastName: cp.lastName,
  //     DBProvider.columnAddress1: cp.address.address1,
  //     DBProvider.columnAddress2: cp.address.address2,
  //     DBProvider.columnCity: cp.address.city,
  //     DBProvider.columnstate: cp.address.state,
  //     DBProvider.columnPincode: cp.address.pinCode,
  //     DBProvider.columnPhoneNumber: cp.mobileNumber,
  //     DBProvider.columnToken: cp.token,
  //     DBProvider.columnEmail: cp.emailId,
  //     DBProvider.columnwalletamt: cp.walletamt,
  //   };
  //   this.createContact.contact = cp.mobileNumber;
  //   this.createContact.email = cp.emailId;
  //   this.createContact.name = cp.firstName;
  //   this.createContact.type = "vendor";
  //   this.createContact.referenceId = "SAM_VEN" + cp.mobileNumber;
  //   apiService.getVendorBankDetails(cp.mobileNumber, cp.token).then((value) => {
  //         prefs.setString("cont_refId", value.rzpContactId),
  //       });
  //   if (prefs.getString("cont_refId") == null) {
  //     apiService.createContact(createContact).then((value) => {
  //           if (prefs.getString("cont_refId") == null)
  //             {
  //               if (value != null)
  //                 {
  //                   this.contactadded.rzpcontactid = value.id,
  //                   this.contactadded.mobileNumber = cp.mobileNumber,
  //                   print(value.id),
  //                   apiService.addrzpccontact(contactadded, cp.token),
  //                   prefs.setString("cont_refId", value.id),
  //                 }
  //             }
  //         });
  //     final id = await dbHelper.userinsert(row);
  //     print("$id");
  //   }
  //   final id = await dbHelper.userinsert(row);
  //   print("$id");
  // }
}


// //import 'package:vaahana/widgets/widget_cart_card.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:vaahana/api_service.dart';
// import 'package:vaahana/model/LoginRespose.dart';
// import 'package:vaahana/pages/PickupOrders.dart';
// import 'package:vaahana/pages/VehiclesListPage.dart';
// import 'package:vaahana/pages/forgot-password.dart';
// import 'package:vaahana/pages/getDriverVehiclePage.dart';
// import 'package:vaahana/pages/getDriversDetails.dart';
// //import 'package:vaahana/pages/forgot-password.dart';
// import 'package:vaahana/pages/home.dart';
// import 'package:vaahana/utils/ProgressHUD.dart';
// import 'package:vaahana/utils/already_have_an_account_acheck.dart';
// //import 'package:vaahana/pages/SignUp_page.dart';
// import 'package:vaahana/utils/dataBase.dart';
// import 'package:vaahana/utils/form_helper.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vaahana/components/globals.dart' as globals;

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final dbHelper = DBProvider.instance;
//   List<LoginResponse> user = [];

//   bool hidePassword = true;
//   bool isApiCallProcess = false;
//   APIService apiService;
//   String password;
//   String username;
//   GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     apiService = new APIService();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ProgressHUD(
//       child: _uiSetup(context),
//       inAsyncCall: isApiCallProcess,
//       opacity: 0.3,
//     );
//   }

//   Widget _uiSetup(BuildContext context) {
//     return Stack(
//       key: scaffoldKey,
//       children: [
//         Scaffold(
//           backgroundColor: Colors.blueGrey[100],
//           body: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 Stack(
//                   children: <Widget>[
//                     Container(
//                       width: double.infinity,
//                       child: Form(
//                         key: globalFormKey,
//                         child: Column(
//                           children: <Widget>[
//                             SizedBox(height: 60),
//                             Text(
//                               "Welcome To Vaahana",
//                               style: TextStyle(
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 26),
//                             ),
//                             CircleAvatar(
//                               backgroundColor: Colors.transparent,
//                               radius: 90,
//                               child: Image.asset(
//                                   'assets/images/vahana-logo.png',
//                                   width: 120,
//                                   height: 120,
//                                   fit: BoxFit.fill),
//                             ),
//                             SizedBox(height: 20),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Padding(
//                                     padding:
//                                         EdgeInsets.symmetric(vertical: 10.0),
//                                     child: Container(
//                                       height: 60,
//                                       width: double.infinity,
//                                       decoration: BoxDecoration(
//                                         color: Colors.green.withOpacity(0.5),
//                                         borderRadius: BorderRadius.circular(22),
//                                       ),
//                                       child: TextFormField(
//                                         onSaved: (input) => username = input,
//                                         validator: (input) => input.length < 10
//                                             ? "Please Enter Valid Mobile Number"
//                                             : null,
//                                         decoration: InputDecoration(
//                                             errorStyle: TextStyle(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 12,
//                                             ),
//                                             prefixIcon: Padding(
//                                               padding: EdgeInsets.symmetric(
//                                                   horizontal: 20),
//                                               child: Icon(
//                                                 Icons.phone,
//                                                 size: 26,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                             border: InputBorder.none,
//                                             hintText: "Mobile Number ",
//                                             hintStyle: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 19,
//                                             )),
//                                         style: TextStyle(color: Colors.black),
//                                         keyboardType:
//                                             TextInputType.emailAddress,
//                                         textInputAction: TextInputAction.next,
//                                         cursorColor: Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding:
//                                         EdgeInsets.symmetric(vertical: 10.0),
//                                     child: Container(
//                                       height: 60,
//                                       width: double.infinity,
//                                       decoration: BoxDecoration(
//                                         color: Colors.green.withOpacity(0.5),
//                                         borderRadius: BorderRadius.circular(22),
//                                       ),
//                                       child: TextFormField(
//                                         onSaved: (input) => password = input,
//                                         validator: (input) => input.length < 3
//                                             ? "Password should be more than 4 characters"
//                                             : null,
//                                         obscureText: hidePassword,
//                                         decoration: InputDecoration(
//                                             errorStyle:
//                                                 TextStyle(color: Colors.black),
//                                             prefixIcon: Padding(
//                                               padding: EdgeInsets.symmetric(
//                                                   horizontal: 20),
//                                               child: Icon(
//                                                 Icons.lock,
//                                                 size: 26,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                             suffixIcon: IconButton(
//                                               onPressed: () {
//                                                 setState(() {
//                                                   hidePassword = !hidePassword;
//                                                 });
//                                               },
//                                               color:
//                                                   Colors.red.withOpacity(0.9),
//                                               icon: Icon(hidePassword
//                                                   ? Icons.visibility_off
//                                                   : Icons.visibility),
//                                             ),
//                                             border: InputBorder.none,
//                                             hintText: "Password",
//                                             hintStyle: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 19,
//                                             )),
//                                         style: TextStyle(color: Colors.black),
//                                         keyboardType: TextInputType.name,
//                                         textInputAction: TextInputAction.done,
//                                         cursorColor: Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 1),
//                                   GestureDetector(
//                                     onTap: () => Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => ForgotPassword(),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       'Forgot Password',
//                                       style: TextStyle(
//                                           fontSize: 20,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   SizedBox(height: 15),
//                                 ],
//                               ),
//                             ),
//                             FlatButton(
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 18, horizontal: 110),
//                               onPressed: () {
//                                 if (validateAndSave()) {
//                                   setState(() {
//                                     isApiCallProcess = true;
//                                   });
//                                   apiService
//                                       .login(username, password)
//                                       .then((value) => {
//                                             if (value != null)
//                                               {
//                                                 dbHelper
//                                                     .userdelete()
//                                                     .whenComplete(
//                                                         () => _insert(value)),
//                                                 FormHelper.showMessage(
//                                                     context,
//                                                     "SUYOGA",
//                                                     "Login Successfull",
//                                                     "OK", () {
//                                                   if (globals.userRole ==
//                                                       "ROLE_VAHANA_DRIVER") {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             getDriversVehiclePage(),
//                                                       ),
//                                                     );
//                                                   } else {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             // getDriversDetails(),
//                                                             PickUpOrders(),
//                                                       ),
//                                                     );
//                                                   }
//                                                 }),
//                                               }
//                                             else
//                                               {
//                                                 FormHelper.showMessage(
//                                                     context,
//                                                     "SUYOGA",
//                                                     "Login Failed, Please Enter Valid Details",
//                                                     "OK", () {
//                                                   _insert(value);
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           LoginPage(),
//                                                     ),
//                                                   );
//                                                 }),
//                                               }
//                                           });
//                                 }
//                               },
//                               child: Text(
//                                 "Sign In",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 24,
//                                 ),
//                               ),
//                               color: Colors.green,
//                               shape: StadiumBorder(),
//                             ),
//                             SizedBox(height: 15),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   bool validateAndSave() {
//     final form = globalFormKey.currentState;
//     if (form.validate()) {
//       form.save();
//       return true;
//     }
//     return false;
//   }

//   Future<Widget> _insert(LoginResponse cp) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setDouble("Walletamt", cp.walletamt);
//     Map<String, dynamic> row = {
//       DBProvider.columnId: cp.id,
//       DBProvider.columnFirstName: cp.firstName,
//       DBProvider.columnLastName: cp.lastName,
//       DBProvider.columnAddress1: cp.address.address1,
//       DBProvider.columnAddress2: cp.address.address2,
//       DBProvider.columnCity: cp.address.city,
//       DBProvider.columnstate: cp.address.state,
//       DBProvider.columnPincode: cp.address.pinCode,
//       DBProvider.columnPhoneNumber: cp.mobileNumber,
//       DBProvider.columnToken: cp.token,
//       DBProvider.columnEmail: cp.emailId,
//       DBProvider.columnwalletamt: cp.walletamt,
//     };
//     final id = await dbHelper.userinsert(row);
//   }
// }
