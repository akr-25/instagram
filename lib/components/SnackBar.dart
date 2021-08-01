import 'package:flutter/material.dart';

postSnackBar(String message) {
  return SnackBar(
    backgroundColor: Colors.white,
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 2),
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.blue),
    ),
  );
}

errorSnackBar(String message) {
  return SnackBar(
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 5),
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white),
    ),
  );
}
