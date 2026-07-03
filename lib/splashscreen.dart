// import 'dart:async';
// import 'package:Suyoga/api_service.dart';
// import 'package:Suyoga/pages/CityListPage.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:localstorage/localstorage.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';
// import 'app.dart';
// import 'components/cart_provider.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   final LocalStorage localStorage = new LocalStorage('userData');

//   String error;

//   String pincode = "";
//   String city = "";
//   APIService apiService;

//   @override
//   void initState() {
//     super.initState();
//     var orderProvider = Provider.of<CartProvider>(context, listen: false);
//     orderProvider.getcities();
//     getCurrentLocation();
//     apiService = new APIService();
//     // Timer(Duration(seconds: 5), () => navigateToSubPage(context));

//     ///DBProvider.
//   }

//   getCurrentLocation() async {
//     //final result = await Geolocator.isLocationServiceEnabled();
//     try {
//       final position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       // print(">>>>>>>>>>>>>>>>>>>>>>>>>>:");
//       // print('>>>>>>>>>>>>>>>>>location: ${position.latitude}');
//       final coordinates =
//           new Coordinates(position.latitude, position.longitude);
//       var addresses =
//           await Geocoder.local.findAddressesFromCoordinates(coordinates);
//       var first = addresses.first;
//       // print("++++++++++" + '${first.addressLine}');
//       // print(
//       //     ">>>>>>>>>>>>>>>>>>>>>>>>>>: ${first.adminArea}: ${first.featureName} : ${first.addressLine} : ${first.postalCode}");
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       // prefs.setString('Location', '${first.locality}');
//       prefs.setString('Pincode', '${first.postalCode}');
//       prefs.setString('Address', '${first.addressLine}');
//       prefs.setString('State', '${first.adminArea}');
//       setState(() {
//         pincode = '${first.postalCode}';
//         city = '${first.locality}';
//       });
//       apiService.getCityName('${first.locality}').then((value) =>
//           Timer(Duration(seconds: 2), () => navigateToSubPage(context)));
//     } catch (e) {
//       Timer(Duration(seconds: 1), () => navigateTocityPage(context));
//       // print(">>>>>>>>>>>>>>>>>>>> postion deny");
//     }
//   }

//   Future navigateToSubPage(BuildContext context) async {
//     Navigator.pushNamed(
//       context,
//       CategoryRoute,
//     );
//   }

//   Future navigateTocityPage(BuildContext context) async {
//     Navigator.pushNamed(
//       context,
//       CityRoute,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(color: Colors.greenAccent),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       CircleAvatar(
//                         backgroundColor: Colors.transparent,
//                         radius: 50,
//                         child: Image.asset('assets/images/logo.png',
//                             width: 100, height: 100, fit: BoxFit.fill),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(top: 20),
//                       ),
//                       Text(
//                         "WELCOME TO SUYOGA",
//                         style: TextStyle(
//                             color: Colors.redAccent,
//                             fontSize: 30.0,
//                             fontWeight: FontWeight.bold),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     CircularProgressIndicator(),
//                     Padding(padding: EdgeInsets.only(top: 20.0)),
//                     Text(
//                       "Online Store For Farm Products",
//                       style: TextStyle(
//                           color: Colors.redAccent,
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       city,
//                       style: TextStyle(
//                           color: Colors.redAccent,
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     // Text(
//                     //   pincode,
//                     //   style: TextStyle(
//                     //       color: Colors.redAccent,
//                     //       fontSize: 20.0,
//                     //       fontWeight: FontWeight.bold),
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
