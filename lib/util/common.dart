import 'package:flutter/material.dart';

class Common {
  static showSnackbar(BuildContext context, String text) {
    final snackBar = SnackBar(
      duration: const Duration(milliseconds: 400),
      content: Text(text, textAlign: TextAlign.center),
      padding: const EdgeInsets.all(24),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      )),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
