import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static showSnackbar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Directionality(
            textDirection: TextDirection.rtl, child: Text(message))));
  }
}
