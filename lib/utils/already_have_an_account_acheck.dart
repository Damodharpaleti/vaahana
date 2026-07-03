import 'package:flutter/material.dart';


class AlreadyHaveAccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  const AlreadyHaveAccountCheck({
    required Key key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: TextStyle(
              color: Color.fromRGBO(255, 95, 167, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
