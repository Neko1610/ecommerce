import 'package:flutter/material.dart';

const Duration appSnackBarDuration = Duration(seconds: 2);

void showAppSnackBar(BuildContext context, SnackBar snackBar) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: snackBar.content,
        action: snackBar.action,
        backgroundColor: snackBar.backgroundColor,
        behavior: snackBar.behavior,
        duration: appSnackBarDuration,
        elevation: snackBar.elevation,
        margin: snackBar.margin,
        padding: snackBar.padding,
        shape: snackBar.shape,
        width: snackBar.width,
      ),
    );
}
