import 'package:dog/main.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class LoginForm extends StatefulWidget {
  const LoginForm({
    Key key,

  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var email;
  var pass;
  var user;
  var emailrgex= RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final _formkey=GlobalKey<FormState>();

  setUser(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user',email);
  }

  login(email,password) async{
    Map<String, String> headers = {"Content-type": "application/json"};
    //var json = {"email": email, "password": password};
    String url = 'http://10.0.2.2:4300/login';
    final msg = jsonEncode({"email": email, "password": password});
    Response response = await post(url, headers: headers, body: msg);
    int statusCode = response.statusCode;
    print(statusCode);
    String bodyText = response.body;
    print(bodyText);
    if(statusCode==200){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context)=>MyHomePage(),
        )
    );
    }
    else{
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please enter valid credentials"),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (val)=>val.isNotEmpty && emailrgex.hasMatch(val)?null:"Enter correct email",
              decoration: InputDecoration(
                hintText: "Enter email",
                border: OutlineInputBorder(),
              ),
              onChanged: (val){
                setState(() {
                  email=val;
                });
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              validator: (val)=>val.isNotEmpty && val.length>=6 ? null:"Enter a password 6+ chars long",
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter password",
                border: OutlineInputBorder(),
              ),
              onChanged: (val){
                setState(() {
                  pass=val;
                });
              },
            ),
            const SizedBox(height: 10.0),

            RaisedButton(
              color: Colors.pink,
              textColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text("Login"),
              onPressed: () async {
                if(_formkey.currentState.validate()){
//                  dynamic result =await _auth.signin(email, pass);
//                  if(result==null){
//                    Scaffold.of(context).showSnackBar(SnackBar(
//                      content: Text("Please enter valid credentials"),
//                    ));
//                  }
//                  else{
//                    print("login hogya");
//                  }
                setUser(email);
                await login(email,pass);

                }

              },
            ),
          ],

        ),
      ),
    );
  }
}
