import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class MessageWidget {
  static void info(BuildContext context, String message, int seconds) {
    // Fluttertoast.showToast(
    //   msg: "Información: $message",
    //   toastLength: seconds > 2 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: Colors.blue.shade300,
    //   textColor: Colors.white,
    //   fontSize: 16.0,
    // );
    showToast(
      "Información: $message",
      duration: Duration(seconds: seconds > 2 ? 5 : 2),
      position: ToastPosition.bottom,
      backgroundColor: Colors.blue.shade300,
      textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
    );
  }

  static void warn(BuildContext context, String message, int seconds) {
    showToast(
      "⚠️ Advertencia: $message",
      duration: Duration(seconds: seconds > 2 ? 5 : 2),
      position: ToastPosition.bottom,
      backgroundColor: Colors.deepOrangeAccent,
      textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
    );
    // Fluttertoast.showToast(
    //   msg: "⚠️ Advertencia: $message",
    //   toastLength: seconds > 2 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: Colors.deepOrangeAccent,
    //   textColor: Colors.white,
    //   fontSize: 16.0,
    // );
  }

  static void error(BuildContext context, String message, int seconds) {
    showToast(
      "❌ Error: $message",
      duration: Duration(seconds: seconds > 2 ? 5 : 2),
      position: ToastPosition.bottom,
      backgroundColor: Colors.red,
      textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
    );
    // Fluttertoast.showToast(
    //   msg: "❌ Error: $message",
    //   toastLength: seconds > 2 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: Colors.red,
    //   textColor: Colors.white,
    //   fontSize: 16.0,
    // );
  }
}
