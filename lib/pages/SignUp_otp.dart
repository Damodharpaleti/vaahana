import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaahana/model/LoginRespose.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:vaahana/api_service.dart';
import 'package:vaahana/model/User_Signup_Model.dart';
import 'package:vaahana/pages/loggin.dart';
import 'package:vaahana/style.dart';
import 'package:vaahana/utils/ProgressHUD.dart';
import 'package:vaahana/utils/dataBase.dart';
import 'package:vaahana/utils/form_helper.dart';

@immutable
class OTP extends StatefulWidget {
  final User user;

  OTP({required Key key, required this.user}) : super(key: key);

  // final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> with TickerProviderStateMixin {
  final dbHelper = DBProvider.instance;
  late APIService apiService;
  bool isApicallProcess = false;
  late String accesscode;
  late AnimationController _controller;
  int levelClock = 120;
  late Animation<int> animation;
  int counter = 0;


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    setState(() {
      _controller = AnimationController(
          vsync: this,
          duration: Duration(
              seconds:
                  levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
          );
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
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
              "We sent Verification code To +91 " +
                  " " +
                  (this.widget.user.mobileNumber ?? ''),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("This code valid Upto "),

                Countdown(
                  key: UniqueKey(),
                  animation: StepTween(
                    begin: levelClock, // THIS IS A USER ENTERED NUMBER
                    end: 0,
                  ).animate(_controller),
                ),
                // TweenAnimationBuilder(
                //   tween: Tween(
                //     begin: 120.0,
                //     end: 0,
                //   ),
                //   duration: Duration(seconds: 120),
                //   builder: (BuildContext context, value, child) => Text(
                //     " ${value.toInt()}" + " " + "Seconds",
                //     style: TextStyle(color: Colors.red),
                //   ),
                //   onEnd: () {},
                // ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: PinFieldAutoFill(
                codeLength: 4,
                onCodeChanged: (val) {
                  if (val?.isNotEmpty ?? false) {
                    accesscode = this.widget.user.acessCode = val ?? "";
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
              //         builder: (context) => SignUP(),
              //       ),
              //     );
              //   });
              // }),
              // SizedBox(
              //   width: 25,
              // ),
              FormHelper.saveButton("Submit", () {
                setState(() {
                  isApicallProcess = true;
                });
                apiService.userRegister(this.widget.user).then((ret) {
                  setState(() {
                    isApicallProcess = false;
                  });
                  if (ret) {
                    FormHelper.showMessage(
                        context,
                        "SUYOGA",
                        "Thank you for your registration! Your account is now ready to use",
                        "OK", () {
                      apiService.Otplogin(this.widget.user.mobileNumber ?? "",
                              this.widget.user.acessCode ?? "")
                          .then((value) {
                        {
                          dbHelper
                              .userdelete()
                              .whenComplete(() => _insert(value));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        }
                                            });
                    });
                  } else {
                    FormHelper.showMessage(
                        context, "SUYOGA", "Enter Valid OTP", "OK", () {
                      Navigator.of(context).pop();
                    });
                  }
                });
                            }),
            ]),
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
                            apiService
                                .loginWithOTP(this.widget.user.mobileNumber ?? "");
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

  Future<void> _insert(LoginResponse cp) async {
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
    await dbHelper.userinsert(row);
  }
}

@immutable
class Countdown extends AnimatedWidget {
  final Animation<int> animation;
  
  Countdown({required Key key, required this.animation}) : super(key: key, listenable: animation);

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
