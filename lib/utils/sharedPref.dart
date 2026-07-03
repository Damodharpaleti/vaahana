// import 'package:vaahana/model/ProductLocal.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class SharedPref {
//   List<ProductLocal> productlocal = new List<ProductLocal>();
//   double get totalAmount => productlocal != null
//       ? productlocal
//           .map<double>((e) => e.totalPrice)
//           .reduce((value, element) => value + element)
//       : 0;
//   read(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     return json.decode(prefs.getString(key));
//   }

//   save(String key, value) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString(key, json.encode(value));
//   }

//   remove(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove(key);
//   }

//   Future<double> totalcount() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String data = prefs.getString("Eachproduct");
//     // print(data);

//     if (data != null) {
//       List l = json.decode(data);
//       l.forEach((i) {
//         ProductLocal data2 = new ProductLocal.fromJson(i);
//         productlocal.add(data2);
//       });
//     }
//     return totalAmount;
//   }
// }
