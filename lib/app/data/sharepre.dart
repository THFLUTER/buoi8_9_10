// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:app_api/app/model/cart.dart';
import 'package:app_api/app/page/auth/login.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

Future<bool> saveUser(User objUser) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strUser = jsonEncode(objUser);
    prefs.setString('user', strUser);
    print("Luu thanh cong: $strUser");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> logOut(BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', '');
    print("Logout thành công");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

//
Future<User> getUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String strUser = pref.getString('user') ?? "";

  if (strUser.isNotEmpty) {
    try {
      return User.fromJson(jsonDecode(strUser));
    } catch (ex) {
      return User.userEmpty();
    }
  } else {
    return User.userEmpty();
  }
}
