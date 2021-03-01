import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PopMessage {
  static void showMessage(
    BuildContext context,
    String title,
    String message,
    String ButtonText,
    Function onPressed, {
    bool isconformationDialog = false,
    String buttonText2 = "",
    Function onPressed2,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            content: new Text(message),
            actions: [
              new FlatButton(
                  onPressed: () {
                    return onPressed();
                  },
                  child: new Text(ButtonText)),
              Visibility(
                visible: isconformationDialog,
                child: new FlatButton(
                  onPressed: () {
                    return onPressed2();
                  },
                  child: new Text(buttonText2),
                ),
              ),
            ],
          );
        });
  }
}
