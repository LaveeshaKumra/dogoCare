import 'package:dog/discoverPage.dart';
import 'package:dog/homePage.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:dog/Splash.dart';
import 'package:flutter/material.dart';
import 'profile.dart';
import 'medicalRecords/Medical.dart';
import 'DailyRecords/Records.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dog/Wrapper.dart';
import 'package:dog/Settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new MyHomePage());
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final keyIsFirstLoaded = 'is_first_loaded';

  @override
  void initState() {
    _makeGetRequest();
  }


  showDialogIfFirstLoaded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
    if (isFirstLoaded == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Enter your pet's detail"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  prefs.setBool(keyIsFirstLoaded, false);
                },
              ),
            ],
          );
        },
      );
    }
  }



  Future<String> getuser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }

  _makeGetRequest() async {
    await getuser().then((ss) async {
      Map<String, String> headers = {"Content-type": "application/json"};
      String url = 'http://10.0.2.2:4300/login';
      final msg = jsonEncode({"email": ss});
      Response response = await post(url, headers: headers, body: msg);
      int statusCode = response.statusCode;
      String bodyText = response.body;
      print(bodyText);
      if(bodyText=='') {
        Future.delayed(Duration.zero, () => showDialogIfFirstLoaded());
      }
    });

  }



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex=index;
    });

  }
  @override
  Widget build(BuildContext context) {
    logout() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.setString('user',null);
    }
    return
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Scaffold(
              appBar: AppBar(
                title: Text("DogoCare"),
                backgroundColor: Colors.teal[200],
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: IconButton(
                        icon:Icon(Icons.pets),
                        color: Colors.black,
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Profile()),
                          );
                        },
                      ),
                      decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: CircleBorder(),
                    ),
                    ),
                  )


                ],
              ),
              body: checknavigation(_selectedIndex),
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text('Menu',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                    ),
                    ListTile(
                      title: Text('Home'),
                      leading: Icon(
                        Icons.home,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedIndex=0;
                        });
                        Navigator.pop(context);
                      },
                    ),
//                    ListTile(
//                      leading: Icon(
//                        Icons.favorite,
//                      ),
//                      title: Text('Favorites'),
//                      onTap: () {
//                        Navigator.pop(context);
//                      },
//                    ),
//                    ListTile(
//                      title: Text('Jaap'),
//                      leading: Icon(
//                        Icons.loop,
//                      ),
//                      onTap: () {
//                        Navigator.pop(context);
//                      },
//                    ),
                    ListTile(
                      title: Text('Settings'),
                      leading: Icon(
                        Icons.settings,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context)=>Settings(),
                            )
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Rate us'),
                      leading: Icon(
                        Icons.star,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Feedback'),
                      leading: Icon(
                        Icons.feedback,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('LogOut'),
                      leading: Icon(
                        Icons.exit_to_app,
                      ),
                      onTap: () {
                        logout();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context)=>Wrapper(),
                            )
                        );
                      },
                    ),
                  ],
                ),

              ),

              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text('Home'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.receipt),
                    title: Text('Daily Records'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.local_hospital),
                    title: Text('Medical Records'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.find_in_page),
                    title: Text('Discover'),
                  ),
                ],
                currentIndex: _selectedIndex,
                unselectedItemColor: Colors.teal[100],
                selectedItemColor: Colors.teal[300],
                onTap: _onItemTapped,
              ),
            ),
         );


          }

  checknavigation(int index) {
    if(index==0){
      return HomePage2();
    }
    else if(index==1){
      return Records();
    }
    else if(index==2){
      return Medical();
    }
    else if(index==3){
      return DiscoverPage();
    }
  }
}


