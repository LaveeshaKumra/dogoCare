import 'package:dog/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:dog/Authentication/authpage.dart';

class Wrapper extends StatelessWidget {

  Future<String> getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }

  showDialogIfFirstLoaded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('user');
    if (data == null) {
      return AuthThreePage();
    }
    else {
      return MyHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {

    return MyHomePage();

  }


}
