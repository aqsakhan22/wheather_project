

import 'dart:io';

import 'package:flutter/material.dart';


class TopVariables {
  static GlobalKey<NavigatorState> appNavigationKey = GlobalKey<NavigatorState>();
  static Size mediaQuery = MediaQuery.of(appNavigationKey.currentContext!).size;
}

class TopFunctions {

  static snackBar(String message) {
    SnackBar(backgroundColor: Colors.red, content: Text(message));
  }

  static showScaffold(String toastMsg) {
    ScaffoldMessenger.of(TopVariables.appNavigationKey.currentContext!).showSnackBar(SnackBar(content: Text(toastMsg)),);
  }

  static Future<bool> internetConnectivityStatus() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('Internet Status = Connected');
        return true;
      } else {
        print('Internet Status = Not Connected');
        return false;
      }
    } on SocketException catch (_) {
      print('Internet Status = Not Connected');
      return false;
    }
  }


}
