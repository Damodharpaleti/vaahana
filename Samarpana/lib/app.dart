import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/pages/Order_detailsPage.dart';
import 'package:Samarpana/pages/loggin.dart';
import 'package:Samarpana/pages/orderdetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'style.dart';
import 'pages/home.dart';

const LocationsRoute = '/';
const LocationDetailRoute = '/location_detail';
const CategoryRoute = '/category_detail';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
            child: OrderDetails(),
          ),
        ],
        child: MaterialApp(
          onGenerateRoute: _routes(),
          routes: <String, WidgetBuilder>{
            //    '/PayPal': (BuildContext context) => new PaypalPayment()
          },
          theme: _theme(),
        ));
  }

  RouteFactory _routes() {
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case LocationsRoute:
          screen = LoginPage();
          break;
        case CategoryRoute:
          //screen = LocationDetail(arguments['id']);
          screen = HomePage();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }

  ThemeData _theme() {
    return ThemeData(
        appBarTheme: AppBarTheme(textTheme: TextTheme(title: AppBarTextStyle)),
        textTheme: TextTheme(
          title: TitleTextStyle,
          body1: Body1TextStyle,
        ));
  }
}
