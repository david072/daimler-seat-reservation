import 'package:flutter/material.dart';

class Util {
  static void showSnackbar(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  // Checks if date1 is before date2
  static bool isDateBefore(DateTime date1, DateTime date2) {
    return date2.year > date1.year ||
        date2.month > date1.month ||
        date2.day > date1.day;
  }
}
