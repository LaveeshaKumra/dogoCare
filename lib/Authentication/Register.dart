import 'Login.dart';
import 'package:flutter/material.dart';
import 'package:dog/Wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:dog/main.dart';



class SignupForm extends StatefulWidget {
  const SignupForm({
    Key key,
  }) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  var pswd,cpswd,email,user;
  var emailrgex= RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  //final AuthService _auth=AuthService();
  final _formkey=GlobalKey<FormState>();

  setUser(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('user',email);
  }


  register(email,password) async{
    Map<String, String> headers = {"Content-type": "application/json"};
    //var json = {"email": email, "password": password};
    String url = 'http://10.0.2.2:4300/register';
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
        content: Text("Please enter valid email"),
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
        child:

        Column(
          children: <Widget>[
            TextFormField(
              validator: (val)=>val.isNotEmpty && emailrgex.hasMatch(val)?null:"Enter correct email",
              onChanged: (val){
                setState(() {
                  email=val;
                });
              },
              decoration: InputDecoration(
                hintText: "Enter email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              validator: (val)=>val.isEmpty || val.length<6 ? "Enter a password 6+ chars long":null,
              obscureText: true,
              onChanged: (val){
                setState(() {
                  pswd=val;
                });
              },
              decoration: InputDecoration(
                hintText: "Enter password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              validator: (val)=>val.isNotEmpty && val==pswd ? null:"Confirm password must match above password",
              obscureText: true,
              onChanged: (val){
                setState(() {
                  cpswd=val;
                });
              },
              decoration: InputDecoration(
                hintText: "Confirm password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            RaisedButton(
              color: Colors.pink,
              textColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text("Signup"),
              onPressed: () async  {
                if(_formkey.currentState.validate()){
//                  dynamic result =await _auth.register(email, pswd);
//                  if(result==null){
//                    Scaffold.of(context).showSnackBar(SnackBar(
//                      content: Text("Please enter valid email"),
//                    ));
//                  }
//                  else{
//                    print("register hogya");
//                  }

//                Navigator.of(context).pushReplacement(
//                    MaterialPageRoute(
//                      builder: (BuildContext context)=>Wrapper(),
//                    )
//                );
                  setUser(email);
                  await register(email,pswd);
                }
              },
            ),
          ],
        ),

      ),
    );


  }
}