import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:Samarpana/config.dart';


class DashBordPage extends StatefulWidget {
  @override
  _DashBordPageState createState() => _DashBordPageState();
}

class _DashBordPageState extends State<DashBordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            imageCarousel(context),
          ],
        ),
      ),
    );
  }

  Widget imageCarousel(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      child: new Carousel(
        overlayShadow: false,
        borderRadius: true,
        boxFit: BoxFit.none,
        indicatorBgPadding: 1.0,
        dotColor: Colors.green,
        autoplay: true,
        dotSize: 4.0,
        images: [
          FittedBox(
            fit: BoxFit.fill,
            child: Image.network(Config.dashboardImage + '/home.jpg'),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Image.network(Config.dashboardImage + '/Kissan2itchen.jpg'),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child:
                Image.network(Config.dashboardImage + '/FreshFarmBanner.jpg'),
          )
        ],
      ),
    );
  }
}
