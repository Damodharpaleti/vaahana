import 'package:vaahana/pages/loggin.dart';
import 'package:flutter/material.dart';
import 'package:vaahana/api_service.dart';
import 'package:vaahana/model/ForgotPassword_model.dart';
import 'package:vaahana/pages/Forgot_OTP.dart';
import 'package:vaahana/utils/ProgressHUD.dart';
import 'package:vaahana/utils/form_helper.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //String username;
  late APIService apiService;
  bool isApiCallProcess = false;
  late ForgotPasswordOTP forgotPassword;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    forgotPassword = new ForgotPasswordOTP();
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
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text(
              'Forgot Password',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            elevation: 2,
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          backgroundColor: Colors.blueGrey[100],
          body: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: Text(
                        'Enter your Mobile Number we will send New Password',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FormHelper.textInput(
                        context,
                        forgotPassword.mobile ?? '',
                        (value) => {this.forgotPassword.mobile = value},
                        onValidate: (value) => value.length < 10
                            ? "Please Enter Valid Mobile Number"
                            : null,
                        hintText: "Enter Your Mobile Number",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 110),
                      ),
                      onPressed: () {
                        if (forgotPassword.mobile != null && forgotPassword.mobile!.isNotEmpty) {
                          setState(() {
                            isApiCallProcess = true;
                          });
                          apiService
                              .loginWithOTP(forgotPassword.mobile!)
                              .then((value) => {
                                    if (value)
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotOTP(user: forgotPassword),
                                          ),
                                        ),
                                      }
                                    else
                                      {}
                                  });
                        }
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
