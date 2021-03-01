import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class BasePage extends StatefulWidget {
  BasePage({Key key}) : super(key: key);

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  bool isApiCallProcess = false;
  List list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ModalProgressHUD(
        inAsyncCall: isApiCallProcess,
        child: pageUI(),
        opacity: 0.3,
      ),
    );
  }

  Widget pageUI() {
    return null;
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      brightness: Brightness.dark,
      elevation: 0,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: true,
      title: Text(
        'SUYOGA',
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        Icon(
          Icons.notifications_none,
          color: Colors.white,
        ),
        SizedBox(
          width: 20,
        ),
        new IconButton(
            icon: new Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {}),
        list.length == 0
            ? new Container()
            : new Positioned(
                child: new Stack(
                  children: <Widget>[
                    new Icon(
                      Icons.brightness_1,
                      size: 20,
                      color: Colors.red[600],
                    ),
                    new Positioned(
                      top: 4.0,
                      right: 4.0,
                      child: new Center(
                        child: new Text(
                          '10',
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
