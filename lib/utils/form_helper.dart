import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormHelper {
  static Widget textInput(
    BuildContext context,
    Object initialValue,
    Function onChanged, {
    bool isTextArea = false,
    bool isNumberInput = false,
    bool obscureText = false,
    Function? onValidate,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? hintText,
    TextStyle? hintStyle,
    List<TextInputFormatter>? inputFormatters,
    TextEditingController? controller,
  }) {
    return TextFormField(
      initialValue: initialValue.toString(),
      decoration: fieldDecoration(
        context,
        hintText,
        "",
        hintStyle: hintStyle,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      maxLines: !isTextArea ? 1 : 3,
      keyboardType: isNumberInput ? TextInputType.number : TextInputType.text,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      onChanged: (String value) {
        return onChanged(value);
      },
      validator: (value) {
        return onValidate?.call(value);
      },
      controller: controller,
    );
  }

  static Widget textcomment(
    BuildContext context,
    Object initialValue,
    Function onChanged, {
    bool isTextArea = true,
    bool isNumberInput = false,
    bool obscureText = false,
    Function? onValidate,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? hintText,
    TextStyle? hintStyle,
  }) {
    return TextFormField(
      inputFormatters: [
        new LengthLimitingTextInputFormatter(300),
      ],
      initialValue: initialValue.toString(),
      cursorColor: Colors.black,
      maxLines: 5,
      decoration: InputDecoration(
          helperStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          hintStyle: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          helperText: "Maximum 300 characters",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
          hintText: 'Add your comments'),
      onChanged: (String value) {
        return onChanged(value);
      },
      validator: (value) {
        return onValidate?.call(value);
      },
    );
  }

  static InputDecoration fieldDecoration(
    BuildContext context,
    String? hintText,
    String helperText, {
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextStyle? hintStyle,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(6),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintStyle: hintStyle,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(
          color: Colors.green,
          width: 2,
        ),
      ),
      errorStyle: TextStyle(color: Colors.black),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
    );
  }

  static Widget fieldLabel(String labelName) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Text(
        labelName,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
    );
  }

  static Widget fieldLabelValue(BuildContext context, String labelname) {
    return FormHelper.textInput(
      context, labelname, (value) => {},
      onValidate: (value) {
        return null;
      },
      // readOnly: false,
    );
  }

  static Widget saveButton(String buttonText, Function onTap,
      {String? color, String? textColor, bool? fullWidth}) {
    return Container(
      height: 50.0,
      width: 150,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(255, 95, 167, 1),
              style: BorderStyle.solid,
              width: 1.0,
            ),
            color: Color.fromRGBO(123, 212, 165, 1),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget cancelButton(String buttonText, Function onTap,
      {String? color, String? textColor, bool? fullWidth}) {
    return Container(
      height: 50.0,
      width: 150,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.greenAccent,
              style: BorderStyle.solid,
              width: 1.0,
            ),
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showMessage(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    Function onPressed,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: [
            new TextButton(
              onPressed: () {
                return onPressed();
              },
              child: new Text(buttonText),
            )
          ],
        );
      },
    );
  }
}
