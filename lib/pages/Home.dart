import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vaahana/pages/SignUp_page.dart';
import 'package:vaahana/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerWidget(),
        appBar: _buildAppBar(),
        body: Container(
          //color: Colors.white,
          child: Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUP(),
                    ),
                  );
                },
                child: Text("Sign up")),
          ),
        ));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (context) => GestureDetector(
          child: Icon(
            Icons.menu,
            color: Colors.white,
            size: 30,
          ),
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Text(
        'VAAHANA',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        Icon(
          Icons.notifications_none,
          color: Colors.white,
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          // padding: EdgeInsets.only(right: 10),
          padding: EdgeInsets.only(top: 10),
          child: new Stack(
            children: <Widget>[
              new IconButton(
                  // icon: Icon(Icons.notifications),
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () async {}),
            ],
          ),
        ),
      ], systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}
