import 'package:Samarpana/pages/Order_detailsPage.dart';
import 'package:Samarpana/pages/orderdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/pages/forgot-password.dart';
import 'package:Samarpana/pages/home.dart';
import 'package:Samarpana/utils/ProgressHUD.dart';
import 'package:Samarpana/utils/already_have_an_account_acheck.dart';
import 'package:Samarpana/utils/background-image.dart';
import 'package:Samarpana/pages/SignUp_page.dart';
import 'package:Samarpana/utils/dataBase.dart';

import '../utils/form_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dbHelper = DBProvider.instance;
  List<LoginResponse> user = [];
  bool hidePassword = true;
  bool isApiCallProcess = false;
  APIService apiService;
  String password;
  String username;
  String pending = "P";
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Stack(
      key: scaffoldKey,
      children: [
        BackgroundImage(
          image: 'assets/images/grocery.jpg',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
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
                              "Welcome To Samarpana",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 70,
                              child: Image.asset('assets/images/icon.png',
                                  width: 100, height: 100, fit: BoxFit.fill),
                            ),
                            SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Container(
                                    height: 60,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: TextFormField(
                                      onSaved: (input) => username = input,
                                      validator: (input) => input.length < 10
                                          ? "Please Enter Valid Mobile Number"
                                          : null,
                                      decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Icon(
                                              Icons.phone,
                                              size: 26,
                                              color: Colors.white,
                                            ),
                                          ),
                                          border: InputBorder.none,
                                          hintText: "Mobile Number",
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 19,
                                          )),
                                      style: TextStyle(color: Colors.white),
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Container(
                                    height: 60,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[500].withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: TextFormField(
                                      onSaved: (input) => password = input,
                                      validator: (input) => input.length < 3
                                          ? "Password should be more than 3 characters"
                                          : null,
                                      obscureText: hidePassword,
                                      decoration: InputDecoration(
                                          errorStyle:
                                              TextStyle(color: Colors.white),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Icon(
                                              Icons.lock,
                                              size: 26,
                                              color: Colors.white,
                                            ),
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                hidePassword = !hidePassword;
                                              });
                                            },
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            icon: Icon(hidePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                          ),
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 19,
                                          )),
                                      style: TextStyle(color: Colors.white),
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.done,
                                      cursorColor: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPassword(),
                                    ),
                                  ),
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 35),
                              ],
                            ),
                            FlatButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 110),
                              onPressed: () {
                                //  print("deleted");
                                if (validateAndSave()) {
                                  setState(() {
                                    isApiCallProcess = true;
                                  });
                                  print(username + password);
                                  apiService
                                      .login(username, password)
                                      .then((value) => {
                                            if (value != null)
                                              {
                                                dbHelper
                                                    .userdelete()
                                                    .whenComplete(
                                                        () => _insert(value)),
                                                print(value.firstName),
                                                FormHelper.showMessage(
                                                    context,
                                                    "Suyoga Samarpana",
                                                    "Login Successfull",
                                                    "OK", () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => OrderDetails(
                                                        status: pending,
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              }
                                            else
                                              {
                                                FormHelper.showMessage(
                                                    context,
                                                    "SUYOGA",
                                                    "Login Failed, Please Enter Valid Details",
                                                    "OK", () {
                                                  _insert(value);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage(),
                                                    ),
                                                  );
                                                }),
                                              }
                                          });
                                }
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                              color: Colors.green,
                              shape: StadiumBorder(),
                            ),
                            SizedBox(height: 15),
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

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<Widget> _insert(LoginResponse cp) async {
    Map<String, dynamic> row = {
      DBProvider.columnFirstName: cp.firstName,
      DBProvider.columnLastName: cp.lastName,
      DBProvider.columnAddress1: cp.address.address1,
      DBProvider.columnAddress2: cp.address.address2,
      DBProvider.columnCity: cp.address.city,
      DBProvider.columnstate: cp.address.state,
      DBProvider.columnPincode: cp.address.pinCode,
      DBProvider.columnPhoneNumber: cp.mobileNumber,
      DBProvider.columnToken: cp.token,
    };
    final id = await dbHelper.userinsert(row);
    print("$id");
  }
}
