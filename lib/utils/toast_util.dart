import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static final fToast = FToast();

  static void toastNoContent(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
    );
  }

  static void okToastNoContent(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
    );
  }

  static void errorToastNoContent(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.redAccent,
    );
  }

  static void errorToast(String text, BuildContext context, {int milliseconds = 2000}) {
    fToast.init(context);
    fToast.removeQueuedCustomToasts();
    fToast.removeCustomToast();
    fToast.showToast(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.redAccent,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Text(text),
        ),
      ),
      toastDuration: Duration(milliseconds: milliseconds),
    );
  }

  static void okToast(String text, BuildContext context, {int milliseconds = 2000}) {
    fToast.init(context);
    fToast.removeQueuedCustomToasts();
    fToast.removeCustomToast();
    fToast.showToast(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Text(text),
        ),
      ),
      toastDuration: Duration(milliseconds: milliseconds),
    );
  }

  static void cancelToast() {
    fToast.removeQueuedCustomToasts();
    fToast.removeCustomToast();
  }

  static void cancelToastNoContent() {
    Fluttertoast.cancel();
  }
}
