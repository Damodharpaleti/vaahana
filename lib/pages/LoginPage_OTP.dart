import 'package:vaahana/api_service.dart';
import 'package:vaahana/model/LoginRespose.dart';
import 'package:vaahana/model/Vendor_AccountModel.dart';
import 'package:vaahana/pages/PickupOrders.dart';
import 'package:vaahana/pages/loggin.dart';
import 'package:vaahana/style.dart';
import 'package:vaahana/utils/ProgressHUD.dart';
import 'package:vaahana/utils/dataBase.dart';
import 'package:vaahana/utils/form_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginOTP extends StatefulWidget {
  final String user;
  //APIService apiService;
  //bool isApicallProcess = false;

  LoginOTP({Key? key, required this.user}) : super(key: key);

  // final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  _LoginOTPState createState() => _LoginOTPState();
}

class _LoginOTPState extends State<LoginOTP> with TickerProviderStateMixin {
  final dbHelper = DBProvider.instance;

  bool isApiCallProcess = false;
  late APIService apiService;
  bool isApicallProcess = false;
  late String accesscode;
  int counter = 0;
  late CreateContact createContact;
  late Contactadded contactadded;
  late AnimationController _controller;
  int levelClock = 120;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    createContact = new CreateContact();
    contactadded = new Contactadded();
    apiService = new APIService();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, dynamic> user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: ProgressHUD(
            child: new Form(
              //   key: _formkey,
              child: formui(),
            ),
            inAsyncCall: isApicallProcess,
            opacity: 0.3));
  }

  Widget formui() {
    return Scaffold(
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
            FormHelper.showMessage(
                context, "SUYOGA", "Are you sure you want to back", "OK", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            });
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Text(
              "OTP Verification",
              style: headingStyle,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "We sent Verification code To +91 " + " " + this.widget.user,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("This code valid Upto "),
                Countdown(
                  animation: StepTween(
                    begin: levelClock, // THIS IS A USER ENTERED NUMBER
                    end: 0,
                  ).animate(_controller),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: PinFieldAutoFill(
                codeLength: 4,
                onCodeChanged: (val) {
                  if (val != null && (val).isNotEmpty) {
                    accesscode = val;
                  }
                },
              ),
            ),
            SizedBox(
              height: 150,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              // FormHelper.cancelButton("Cancel", () {
              //   FormHelper.showMessage(
              //       context, "SUYOGA", "Are you sure you want to back", "OK",
              //       () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => CheckoutLoginPage(),
              //       ),
              //     );
              //   });
              // }),
              FormHelper.saveButton("Submit", () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                setState(() {
                  isApicallProcess = true;
                });
                apiService.Otplogin(this.widget.user, accesscode)
                    .then((value) {
                          print(prefs.getString("ROLE"));
                          prefs.setString("ROLE", "ROLE_VAHANA_DRIVER");
                          if ((prefs.getString("ROLE") ?? '').isNotEmpty)
                            {
                              if ((prefs.getString("ROLE") ?? '').contains("ROLE_VAHANA_DRIVER") ||
                                  (prefs.getString("ROLE") ?? '').contains("ROLE_VAHANA_TRANSPORTER"))
                                {
                                  dbHelper
                                      .userdelete()
                                      .whenComplete(() => _insert(value));
                                  print(value.name);
                                  FormHelper.showMessage(
                                      context,
                                      "Suyoga Vaahana",
                                      "Login Successfull",
                                      "OK", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PickUpOrders(
                                          key: UniqueKey(),
                                          status: "P",
                                        ),
                                      ),
                                    );
                                  });
                                }
                              else
                                {
                                  prefs.remove("ROLE");
                                  FormHelper.showMessage(
                                      context,
                                      "SUYOGA",
                                      "Samarpana login Role does not assigned",
                                      "OK", () {
                                    _insert(value);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PickUpOrders(
                                          key: UniqueKey(),
                                          status: "P",
                                        ),
                                      ),
                                    );
                                  });
                                }
                            }
                          else
                            {
                              prefs.remove("ROLE");
                              FormHelper.showMessage(
                                  context,
                                  "SUYOGA",
                                  "Login Failed, Please Enter Valid Details",
                                  "OK", () {
                                _insert(value);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PickUpOrders(
                                      key: UniqueKey(),
                                      status: "P",
                                    ),
                                  ),
                                );
                              });
                            }
                        });
              }),
            SizedBox(
              height: 20,
            ),
            if (counter == 0)
              RichText(
                  text: TextSpan(
                      text: "Didn't receive OTP : ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                      children: <TextSpan>[
                    TextSpan(
                        text: "Resend",
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              counter++;
                            });
                            apiService.loginWithOTP(this.widget.user);
                          },
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color.fromRGBO(255, 95, 167, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.normal)),
                  ])),
          ],
        ),
      ]),
    ));
  }

  Future<Widget> _insert(LoginResponse cp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("Walletamt", cp.walletamt);
    prefs.setString("LoginMobNumber", cp.mobileNumber ?? '');
    Map<String, dynamic> row = {
      DBProvider.columnId: cp.id,
      DBProvider.columnName: cp.name,
      //  DBProvider.columnLastName: cp.lastName,
      DBProvider.columnAddress1: cp.address?.address1 ?? '',
      DBProvider.columnAddress2: cp.address?.address2 ?? '',
      DBProvider.columnCity: cp.address?.city ?? '',
      DBProvider.columnstate: cp.address?.state ?? '',
      DBProvider.columnPincode: cp.address?.pinCode ?? '',
      DBProvider.columnPhoneNumber: cp.mobileNumber ?? '',
      DBProvider.columnToken: cp.token ?? '',
      //   DBProvider.columnEmail: cp.emailId,
      DBProvider.columnwalletamt: cp.walletamt,
    };
    this.createContact.contact = cp.mobileNumber ?? '';
    //this.createContact.email = cp.emailId;
    this.createContact.name = cp.name ?? '';
    this.createContact.type = "vendor";
    this.createContact.referenceId = "SAM_VEN" + (cp.mobileNumber ?? '');
    apiService.getVendorBankDetails(cp.mobileNumber ?? '', cp.token ?? '').then((value) => {
          prefs.setString("cont_refId", value.rzpContactId ?? ''),
        });
    if (prefs.getString("cont_refId") == null) {
      apiService.createContact(createContact).then((value) => {
            if (prefs.getString("cont_refId") == null)
              {
                {
                  this.contactadded.rzpcontactid = value.id,
                  this.contactadded.mobileNumber = cp.mobileNumber ?? '',
                  print(value.id),
                  apiService.addrzpccontact(contactadded, cp.token ?? ''),
                  prefs.setString("cont_refId", value.id ?? ''),
                }
              }
          });
      final id = await dbHelper.userinsert(row);
      print("$id");
    }
    final id = await dbHelper.userinsert(row);
    print("$id");
    return SizedBox();
  }
}

class CartLoginOTP extends StatefulWidget {
  final String user;

  CartLoginOTP({Key? key, required this.user}) : super(key: key);

  @override
  _CartLoginOTPState createState() => _CartLoginOTPState();
}

class _CartLoginOTPState extends State<CartLoginOTP>
    with TickerProviderStateMixin {
  final dbHelper = DBProvider.instance;

  bool isApiCallProcess = false;
  late APIService apiService;
  bool isApicallProcess = false;

  late String accesscode;

  late AnimationController _controller;
  int levelClock = 120;
  late Animation<int> animation;
  int counter = 0;
  late CreateContact createContact;
  late Contactadded contactadded;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    createContact = new CreateContact();
    contactadded = new Contactadded();

    apiService = new APIService();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, dynamic> user = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: ProgressHUD(
            child: new Form(
              //   key: _formkey,
              child: formui(),
            ),
            inAsyncCall: isApicallProcess,
            opacity: 0.3));
  }

  Widget formui() {
    return Scaffold(
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
            FormHelper.showMessage(
                context, "SUYOGA", "Are you sure you want to back", "OK", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            });
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Text(
              "OTP Verification",
              style: headingStyle,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "We sent Verification code To +91 " + " " + this.widget.user,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("This code valid Upto "),
                Countdown(
                  animation: StepTween(
                    begin: levelClock, // THIS IS A USER ENTERED NUMBER
                    end: 0,
                  ).animate(_controller),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: PinFieldAutoFill(
                codeLength: 4,
                onCodeChanged: (val) {
                  if (val?.isNotEmpty ?? false) {
                    accesscode = val ?? "";
                  }
                },
              ),
            ),
            SizedBox(
              height: 150,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              // FormHelper.cancelButton("Cancel", () {
              //   FormHelper.showMessage(
              //       context, "SUYOGA", "Are you sure you want to back", "OK",
              //       () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => CheckoutLoginPage(),
              //       ),
              //     );
              //   });
              // }),
              FormHelper.saveButton("Submit", () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                setState(() {
                  isApicallProcess = true;
                });
                apiService.Otplogin(this.widget.user, accesscode)
                    .then((value) => {
                          print(prefs.getString("ROLE")),
                          if ((prefs.getString("ROLE") ?? '').isNotEmpty)
                            {
                              if ((prefs
                                      .getString("ROLE") ?? '')
                                      .contains("ROLE_DELIVERY_PARTNER") ||
                                  (prefs
                                      .getString("ROLE") ?? '')
                                      .contains("ROLE_SAMARPANA_ADMIN") ||
                                  (prefs
                                      .getString("ROLE") ?? '')
                                      .contains("ROLE_MANAGING_PARTNER"))
                                {
                                  dbHelper
                                      .userdelete()
                                      .whenComplete(() => _insert(value)),
                                  print(value.name),
                                                  FormHelper.showMessage(
                                      context,
                                      "Suyoga Samarpana",
                                      "Login Successfull",
                                      "OK", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PickUpOrders(
                                          key: UniqueKey(),
                                          status: "P",
                                        ),
                                      ),
                                    );
                                  }),
                                }
                              else
                                {
                                  prefs.remove("ROLE"),
                                  FormHelper.showMessage(
                                      context,
                                      "SUYOGA",
                                      "Samarpana login Role does not assigned",
                                      "OK", () {
                                    _insert(value);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  }),
                                }
                            }
                          else
                            {
                              prefs.remove("ROLE"),
                              FormHelper.showMessage(
                                  context,
                                  "SUYOGA",
                                  "Login Failed, Please Enter Valid Details",
                                  "OK", () {
                                _insert(value);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              }),
                            }
                        });
                            }),
            ]),
            SizedBox(
              height: 20,
            ),
            if (counter == 0)
              RichText(
                  text: TextSpan(
                      text: "Didn't receive OTP : ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                      children: <TextSpan>[
                    TextSpan(
                        text: "Resend",
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              counter++;
                            });
                            apiService.loginWithOTP(this.widget.user);
                          },
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color.fromRGBO(255, 95, 167, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.normal)),
                  ])),
          ],
        ),
      ),
    );
  }

  Future<Widget> _insert(LoginResponse cp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("Walletamt", cp.walletamt);
    Map<String, dynamic> row = {
      DBProvider.columnId: cp.id,
      DBProvider.columnName: cp.name,
      //  DBProvider.columnLastName: cp.lastName,
      DBProvider.columnAddress1: cp.address?.address1 ?? "",
      DBProvider.columnAddress2: cp.address?.address2 ?? "",
      DBProvider.columnCity: cp.address?.city ?? "",
      DBProvider.columnstate: cp.address?.state ?? "",
      DBProvider.columnPincode: cp.address?.pinCode ?? "",
      DBProvider.columnPhoneNumber: cp.mobileNumber,
      DBProvider.columnToken: cp.token,
      //   DBProvider.columnEmail: cp.emailId,
      DBProvider.columnwalletamt: cp.walletamt,
    };
    this.createContact.contact = cp.mobileNumber;
    //this.createContact.email = cp.emailId;
    this.createContact.name = cp.name;
    this.createContact.type = "vendor";
    this.createContact.referenceId = "SAM_VEN" + (cp.mobileNumber ?? "");
    apiService.getVendorBankDetails(cp.mobileNumber ?? "", cp.token ?? "").then((value) => {
          prefs.setString("cont_refId", value.rzpContactId ?? ""),
        });
    if (prefs.getString("cont_refId") == null) {
      apiService.createContact(createContact).then((value) => {
            if (prefs.getString("cont_refId") == null)
              {
                {
                  this.contactadded.rzpcontactid = value.id,
                  this.contactadded.mobileNumber = cp.mobileNumber,
                  print(value.id),
                  apiService.addrzpccontact(contactadded, cp.token ?? ""),
                  prefs.setString("cont_refId", value.id ?? ""),
                }
              }
          });
      final id = await dbHelper.userinsert(row);
      print("$id");
    }
    final id = await dbHelper.userinsert(row);
    print("$id");
    return SizedBox();
  }
}

class Countdown extends AnimatedWidget {
  final Animation<int> animation;
  Countdown({Key? key, required this.animation}) : super(key: key, listenable: animation);

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    // print('animation.value  ${animation.value} ');
    // print('inMinutes ${clockTimer.inMinutes.toString()}');
    // print('inSeconds ${clockTimer.inSeconds.toString()}');
    // print(
    //     'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 18,
        color: Color.fromRGBO(255, 95, 167, 1),
      ),
    );
  }
}
