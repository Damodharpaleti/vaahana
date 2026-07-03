import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaahana/components/Cart_Provider.dart';
import 'package:vaahana/pages/PickupOrders.dart';
import 'package:vaahana/pages/loggin.dart';
import 'package:vaahana/style.dart';

const LocationsRoute = '/';
const LocationDetailRoute = '/location_detail';
const CityRoute = '/city_detail';
const CategoryRoute = '/category_detail';

class App extends StatelessWidget {
  final String? loginMobNumber;
  
  App({this.loginMobNumber});

  Future<String?> logindata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobNumber = prefs.getString("LoginMobNumber");
    print(mobNumber);
    return mobNumber;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: logindata(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return home();
          }
          return multi();
        });
  }

  Widget home() {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
            child: PickUpOrders(key: UniqueKey(), status: "P"),
          ),
        ],
        child: MaterialApp(
          theme: _theme(),
          home: Scaffold(
            body: LoginPage(),
          ),
          debugShowCheckedModeBanner: false,
        ));
  }

  // RouteFactory _routes() {
  //   return (settings) {
  //     final Map<String, dynamic> arguments = settings.arguments;
  //     Widget screen;
  //     switch (settings.name) {
  //       case LocationsRoute:
  //         screen = LoginPage();
  //         break;
  //       default:
  //         return null;
  //     }
  //     return MaterialPageRoute(builder: (BuildContext context) => screen);
  //   };
  // }

  ThemeData _theme() {
    return ThemeData(
        appBarTheme:
            AppBarTheme(toolbarTextStyle: TextTheme(bodyMedium: AppBarTextStyle).bodyMedium, titleTextStyle: TextTheme(displayMedium: AppBarTextStyle).displayMedium),
        textTheme: TextTheme(
          titleMedium: TitleTextStyle,
          bodyLarge: Body1TextStyle,
        ));
  }

  Widget multi() {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
            child: PickUpOrders(key: UniqueKey(), status: "P"),
          ),
        ],
        child: MaterialApp(
          theme: _theme(),
          home: Scaffold(
            body: PickUpOrders(
              key: UniqueKey(),
              status: "P",
            ),
          ),
          debugShowCheckedModeBanner: false,
        ));
  }
}
