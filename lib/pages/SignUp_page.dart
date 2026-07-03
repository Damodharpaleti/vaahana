
import 'package:flutter/services.dart';
import 'package:vaahana/pages/loggin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaahana/api_service.dart';
import 'package:vaahana/model/User_Signup_Model.dart';
import 'package:vaahana/pages/SignUp_otp.dart';
import 'package:vaahana/utils/ProgressHUD.dart';
import 'package:vaahana/utils/dataBase.dart';

import '../utils/form_helper.dart';

class SignUP extends StatefulWidget {
  final String? mobileNumber;
  final List<String>? citylist;
  const SignUP({this.mobileNumber, this.citylist, Key? key}) : super(key: key);
  @override
  _SignUPState createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  final dbHelper = DBProvider.instance;
  late APIService apiService;
  bool isApicallProcess = false;
  bool hidePassword = true;
  late User usersignup;

  late SharedPreferences sharedPrefs;
  late String _mySelection;
  final _dropdownFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    usersignup = new User();
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
      WillPopScope(
          onWillPop: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
            return false;
          },
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                title: Text(
                  "SUYOGA",
                  style: TextStyle(color: Colors.black),
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
              body: SingleChildScrollView(
                reverse: true,
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

                          Form(
                              key: _dropdownFormKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Select your near by city',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                          width: 2,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                    ),
                                    validator: (value) => value == null
                                        ? "Select your city"
                                        : null,
                                    dropdownColor: Colors.white,
                                    initialValue: _mySelection,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _mySelection = newValue ?? "";
                                        usersignup.nearbyCity = _mySelection;
                                      });
                                    },
                                    items: this.widget.citylist?.map((cityOne) {
                                      return DropdownMenuItem(
                                        child: Text(cityOne),
                                        value: cityOne,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          FormHelper.textInput(
                            context,
                            usersignup.name ?? "",
                            (value) => {this.usersignup.name = value},
                            onValidate: (value) {
                              if (value.toString().isEmpty) {
                                return "Please Enter Your Name";
                              }
                              return null;
                            },
                            hintText: "Name",
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 20),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 30,
                            ),
                            //style: TextStyle(color: Colors.white),
                          ),

                          FormHelper.textInput(
                            context,
                            usersignup.mobileNumber ?? "",
                            (value) => {this.usersignup.mobileNumber = value},
                            onValidate: (value) => value.length < 10
                                ? "Please Enter Valid Mobile Number"
                                : null,
                            hintText: "Mobile Number",
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 20),
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(10),
                            ],
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),

                          FormHelper.textInput(
                            context,
                            usersignup.address ?? "",
                            (value) => {this.usersignup.address = value},
                            onValidate: (value) {
                              if (value.toString().isEmpty) {
                                return "Please Enter Your Address";
                              }
                              return null;
                            },
                            hintText: "Adress",
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 20),
                            prefixIcon: Icon(
                              Icons.location_city,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          FormHelper.textInput(
                            context,
                            usersignup.city ?? "",
                            (value) => {this.usersignup.city = value},
                            onValidate: (value) {
                              if (value.toString().isEmpty) {
                                return "Please Enter Your Location";
                              }
                              return null;
                            },
                            hintText: "Location",
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 20),
                            prefixIcon: Icon(
                              Icons.location_city,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          FormHelper.textInput(
                            context,
                            usersignup.state ?? "",
                            (value) => {this.usersignup.state = value},
                            onValidate: (value) {
                              if (value.toString().isEmpty) {
                                return "Please Enter Your state";
                              }
                              return null;
                            },
                            hintText: "state",
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 20),
                            prefixIcon: Icon(
                              Icons.location_city,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          FormHelper.textInput(
                            context,
                            usersignup.dlNumber ?? "",
                            (value) => {this.usersignup.dlNumber = value},
                            onValidate: (value) {
                              if (value.toString().isEmpty) {
                                return "Please Enter Your DL Number";
                              }
                              return null;
                            },
                            hintText: "License Number",
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 20),
                            prefixIcon: Icon(
                              Icons.location_city,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          FormHelper.textInput(
                            context,
                            usersignup.pinCode ?? "",
                            (value) => {this.usersignup.pinCode = value},
                            onValidate: (value) => value.length < 6
                                ? "Please Enter PinCode"
                                : null,
                            hintText: "PinCode",
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 20),
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(6),
                            ],
                            prefixIcon: Icon(
                              Icons.local_post_office,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          // FormHelper.textInput(context, usersignup.password,
                          //     (value) => {this.usersignup.password = value},
                          //     onValidate: (value) => value.length < 4
                          //         ? "Password should be more than 4 characters"
                          //         : null,
                          //     hintText: "Password",
                          //     hintStyle:
                          //         TextStyle(color: Colors.black, fontSize: 20),
                          //     obscureText: hidePassword,
                          //     prefixIcon: Icon(
                          //       Icons.lock,
                          //       color: Colors.black,
                          //       size: 30,
                          //     ),
                          //     suffixIcon: IconButton(
                          //       onPressed: () {
                          //         setState(() {
                          //           hidePassword = !hidePassword;
                          //         });
                          //       },
                          //       color: Colors.red,
                          //       icon: Icon(hidePassword
                          //           ? Icons.visibility_off
                          //           : Icons.visibility),
                          //     )),
                          SizedBox(
                            height: 20,
                          ),
                          new Center(
                            child: FormHelper.saveButton("Generate OTP", () {
                              if (validateandSave()) {
                                usersignup.nearbyCity = _mySelection;
                                setState(() {
                                  isApicallProcess = true;
                                });
                                apiService
                                    .regWithOTP(usersignup.mobileNumber ?? "")
                                    .then((ret) {
                                  setState(() {
                                    isApicallProcess = false;
                                  });
                                  if (ret) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OTP(
                                          key: UniqueKey(),
                                          user: usersignup,
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
                                    FormHelper.showMessage(context, "SUYOGA",
                                        "Mobile No. already exists", "OK", () {
                                      Navigator.of(context).pop();
                                    });
                                  }
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
              )))
    ]);
  }

  bool validateandSave() {
    final form = _formkey.currentState;
    _dropdownFormKey.currentState?.validate();
    if (form != null && form.validate()) {
      form.save();

      return true;
    }
    return false;
  }
}

class SignUPThroughLogin extends StatefulWidget {
  final String? mobileNumber;
  const SignUPThroughLogin({this.mobileNumber, Key? key}) : super(key: key);
  @override
  _SignUPThroughLoginState createState() => _SignUPThroughLoginState();
}

class _SignUPThroughLoginState extends State<SignUPThroughLogin> {
  final dbHelper = DBProvider.instance;
  late APIService apiService;
  bool isApicallProcess = false;
  bool hidePassword = true;
  late User usersignup;

  late SharedPreferences sharedPrefs;

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    usersignup = new User();
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
            backgroundColor: Color.fromRGBO(123, 212, 165, 1),
            title: Text(
              "SUYOGA",
              style: TextStyle(color: Colors.black),
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
          body: SingleChildScrollView(
            reverse: true,
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
                        child: Image.asset('assets/images/logo.png',
                            width: 100, height: 100, fit: BoxFit.fill),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FormHelper.textInput(
                        context,
                        (usersignup.mobileNumber ?? ""),
                        (value) => {this.usersignup.mobileNumber = value},
                        onValidate: (value) => value.length < 10
                            ? "Please Enter Valid Mobile Number"
                            : null,
                        hintText: "Mobile Number",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(10),
                        ],
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        usersignup.name ?? "",
                        (value) => {this.usersignup.name = value},
                        onValidate: (value) {
                          if (value.toString().isEmpty) {
                            return "Please Enter Your Name";
                          }
                          return null;
                        },
                        hintText: "Name",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 30,
                        ),
                        //style: TextStyle(color: Colors.white),
                      ),
                      FormHelper.textInput(
                        context,
                        usersignup.city ?? "",
                        (value) => {this.usersignup.city = value},
                        onValidate: (value) {
                          if (value.toString().isEmpty) {
                            return "Please Enter Your City";
                          }
                          return null;
                        },
                        hintText: "City",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        usersignup.pinCode ?? "",
                        (value) => {this.usersignup.pinCode = value},
                        onValidate: (value) =>
                            value.length < 6 ? "Please Enter PinCode" : null,
                        hintText: "PinCode",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(6),
                        ],
                        prefixIcon: Icon(
                          Icons.local_post_office,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      new Center(
                        child: FormHelper.saveButton("Generate OTP", () {
                          if (validateandSave()) {
                            setState(() {
                              isApicallProcess = true;
                            });
                            apiService
                                .regWithOTP(usersignup.mobileNumber ?? "")
                                .then((ret) {
                              setState(() {
                                isApicallProcess = false;
                              });
                              if (ret) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OTP(
                                      key: UniqueKey(),
                                      user: usersignup,
                                    ),
                                  ),
                                );
                              } else {
                                FormHelper.showMessage(context, "SUYOGA",
                                    "Mobile No. already exists", "OK", () {
                                  Navigator.of(context).pop();
                                });
                              }
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
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

//   Widget formui() {
//     return Stack(children: [
//       // BackgroundImage(
//       //   image: 'assets/images/grocery.jpg',
//       // ),
//       Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.green,
//             title: Text("SUYOGA"),
//             centerTitle: true,
//             elevation: 2,
//             leading: IconButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(
//                 //     builder: (context) => LoginPage(),
//                 //   ),
//                 // );
//               },
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           backgroundColor: Colors.blueGrey[100],
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.all(8),
//               child: Container(
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: Column(
//                     children: [
//                       SizedBox(height: 40),
//                       CircleAvatar(
//                         backgroundColor: Colors.transparent,
//                         radius: 50,
//                         child: Image.asset('assets/images/vahana-logo.png',
//                             width: 100, height: 100, fit: BoxFit.fill),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       FormHelper.textInput(
//                         context,
//                         usersignup.firstName,
//                         (value) => {this.usersignup.firstName = value},
//                         onValidate: (value) {
//                           if (value.toString().isEmpty) {
//                             return "Please Enter First Name";
//                           }
//                           return null;
//                         },
//                         hintText: "First Name",
//                         hintStyle: TextStyle(color: Colors.black, fontSize: 20),
//                         prefixIcon: Icon(
//                           Icons.person,
//                           color: Colors.black,
//                           size: 30,
//                         ),
//                         //style: TextStyle(color: Colors.white),
//                       ),
//                       FormHelper.textInput(
//                         context,
//                         usersignup.lastName,
//                         (value) => {this.usersignup.lastName = value},
//                         onValidate: (value) {
//                           if (value.toString().isEmpty) {
//                             return "Please Enter Last Name";
//                           }
//                           return null;
//                         },
//                         hintText: "Last Name",
//                         hintStyle: TextStyle(color: Colors.black, fontSize: 20),
//                         prefixIcon: Icon(
//                           Icons.person,
//                           color: Colors.black,
//                           size: 30,
//                         ),
//                       ),
//                       FormHelper.textInput(
//                         context,
//                         usersignup.mobileNumber,
//                         (value) => {this.usersignup.mobileNumber = value},
//                         onValidate: (value) => value.length < 10
//                             ? "Please Enter Valid Mobile Number"
//                             : null,
//                         hintText: "Phone No",
//                         hintStyle: TextStyle(color: Colors.black, fontSize: 20),
//                         prefixIcon: Icon(
//                           Icons.phone,
//                           color: Colors.black,
//                           size: 30,
//                         ),
//                       ),
//                       FormHelper.textInput(
//                         context,
//                         usersignup.emailId,
//                         (value) => {this.usersignup.emailId = value},
//                         onValidate: (value) {
//                           if (value.toString().isEmpty) {
//                             return "Please Enter Email Id";
//                           }
//                           if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
//                               .hasMatch(value)) {
//                             return 'Please Enter a valid Email';
//                           }
//                           return null;
//                         },
//                         hintText: "Mail Id",
//                         hintStyle: TextStyle(color: Colors.black, fontSize: 20),
//                         prefixIcon: Icon(
//                           Icons.mail,
//                           color: Colors.black,
//                           size: 30,
//                         ),
//                       ),
//                       FormHelper.textInput(
//                         context,
//                         usersignup.city,
//                         (value) => {this.usersignup.city = value},
//                         onValidate: (value) {
//                           if (value.toString().isEmpty) {
//                             return "Please Enter Your City";
//                           }
//                           return null;
//                         },
//                         hintText: "City",
//                         hintStyle: TextStyle(color: Colors.black, fontSize: 20),
//                         prefixIcon: Icon(
//                           Icons.location_city,
//                           color: Colors.black,
//                           size: 30,
//                         ),
//                       ),
//                       FormHelper.textInput(
//                         context,
//                         usersignup.city,
//                         (value) => {this.usersignup.pinCode = value},
//                         onValidate: (value) =>
//                             value.length < 6 ? "Please Enter PinCode" : null,
//                         hintText: "PinCode",
//                         hintStyle: TextStyle(color: Colors.black, fontSize: 20),
//                         prefixIcon: Icon(
//                           Icons.local_post_office,
//                           color: Colors.black,
//                           size: 30,
//                         ),
//                       ),
//                       FormHelper.textInput(context, usersignup.password,
//                           (value) => {this.usersignup.password = value},
//                           onValidate: (value) => value.length < 4
//                               ? "Password should be more than 4 characters"
//                               : null,
//                           hintText: "Password",
//                           hintStyle:
//                               TextStyle(color: Colors.black, fontSize: 20),
//                           obscureText: hidePassword,
//                           prefixIcon: Icon(
//                             Icons.lock,
//                             color: Colors.black,
//                             size: 30,
//                           ),
//                           suffixIcon: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 hidePassword = !hidePassword;
//                               });
//                             },
//                             color: Colors.red,
//                             icon: Icon(hidePassword
//                                 ? Icons.visibility_off
//                                 : Icons.visibility),
//                           )),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       new Center(
//                         child: FormHelper.saveButton("Continue", () {
//                           if (validateandSave()) {
//                             setState(() {
//                               isApicallProcess = true;
//                             });
//                             apiService
//                                 .regWithOTP(usersignup.mobileNumber)
//                                 .then((ret) {
//                               setState(() {
//                                 isApicallProcess = false;
//                               });
//                               if (ret) {
//                                 FormHelper.showMessage(context, "SUYOGA",
//                                     "OTP Sent Successfull", "OK", () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => OTP(
//                                         user: usersignup,
//                                       ),
//                                     ),
//                                   );
//                                 });
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //     builder: (context) => OTP(
//                                 //       user: usersignup,
//                                 //     ),
//                                 //   ),
//                                 // );
//                               } else {
//                                 FormHelper.showMessage(context, "SUYOGA",
//                                     "Mobile No. already exists", "OK", () {
//                                   Navigator.of(context).pop();
//                                 });
//                               }
//                             });
//                           }
//                         }),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ))
//     ]);
//   }

//   bool validateandSave() {
//     final form = _formkey.currentState;
//     if (form.validate()) {
//       form.save();
//       return true;
//     }
//     return false;
//   }
// }
