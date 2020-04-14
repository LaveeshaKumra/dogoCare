import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextStyle headerStyle = TextStyle(
    color: Colors.grey.shade800,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );

  _SettingsState(){
    _getduration();
  }

  @override
  void initState() {
    super.initState();
    _getduration();
    _controllerexer= new TextEditingController(text: detailstype['fitness']);
  }

  var dropdownValue,duration,durationtype;
  var detailstime = new Map();
  var detailstype = new Map();

  _getduration() async{
    String url = 'http://10.0.2.2:4300/alldurations';
    Response response = await get(url);
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode == 200) {
      String bodyText = response.body;
      var x = json.decode(bodyText);
      print(x);
      for(int i=0;i<x.length;i++){
        Duration d=new Duration(hours: x[i]["duration"]);
        if(x[i]["duration"]>24){
            duration=d.inDays;
            durationtype="days";
        }
        else{
            durationtype="hours";
            duration=x[i]["duration"];
        }
        setState(() {
          detailstime[x[i]["type"]]=duration;
          detailstype[x[i]["type"]]=durationtype;
        });
        print(detailstype);
        print(detailstime);
      }
    }
  }

  TextEditingController _controllerexer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
        backgroundColor: Colors.teal[200],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "ACCOUNT",
              style: headerStyle,
            ),
            const SizedBox(height: 10.0),
            Card(
              elevation: 0.5,
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 0,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("gmail"),
                    onTap: () {},
                  ),
                  _buildDivider(),
                  ListTile(
                    title: Text("Change password"),
                    trailing: Icon(Icons.navigate_next),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              "SCHEDULE TIME OF TASKS",
              style: headerStyle,
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0,),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text("Excercise"),
                          Spacer(),
                          Container(
                            width: 50,
                            child: TextField(
                              controller: _controllerexer,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: new InputDecoration(hintText: 'Enter duration'),
                              onChanged: (value) {
                              },
                            ),
                          ),
                          DropdownButton(
                            value: dropdownValue,
                            items: <String>['hours', 'days']
                                .map<DropdownMenuItem<String>>( (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                                .toList(),
                            onChanged: (newValue) {
                              },
                          )
                        ],
                      ),
                    ),
                  ),
                  _buildDivider(),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text("Excercise"),
                          Spacer(),
                          Container(
                            width: 50,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: new InputDecoration(hintText: 'Enter duration'),
                              onChanged: (value) {
                              },
                            ),
                          ),
                          DropdownButton(
                            value: dropdownValue,
                            items: <String>['hours', 'days']
                                .map<DropdownMenuItem<String>>( (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                                .toList(),
                            onChanged: (newValue) {
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  _buildDivider(),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text("Excercise"),
                          Spacer(),
                          Container(
                            width: 50,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: new InputDecoration(hintText: 'Enter duration'),
                              onChanged: (value) {
                              },
                            ),
                          ),
                          DropdownButton(
                            value: dropdownValue,
                            items: <String>['hours', 'days']
                                .map<DropdownMenuItem<String>>( (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                                .toList(),
                            onChanged: (newValue) {
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  _buildDivider(),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text("Excercise"),
                          Spacer(),
                          Container(
                            width: 50,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: new InputDecoration(hintText: 'Enter duration'),
                              onChanged: (value) {
                              },
                            ),
                          ),
                          DropdownButton(
                            value: dropdownValue,
                            items: <String>['hours', 'days']
                                .map<DropdownMenuItem<String>>( (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                                .toList(),
                            onChanged: (newValue) {
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  _buildDivider(),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text("Excercise"),
                          Spacer(),
                          Container(
                            width: 50,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: new InputDecoration(hintText: 'Enter duration'),
                              onChanged: (value) {
                              },
                            ),
                          ),
                          DropdownButton(
                            value: dropdownValue,
                            items: <String>['hours', 'days']
                                .map<DropdownMenuItem<String>>( (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                                .toList(),
                            onChanged: (newValue) {
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  _buildDivider(),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text("Excercise"),
                          Spacer(),
                          Container(
                            width: 50,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: new InputDecoration(hintText: 'Enter duration'),
                              onChanged: (value) {
                              },
                            ),
                          ),
                          DropdownButton(
                            value: dropdownValue,
                            items: <String>['hours', 'days']
                                .map<DropdownMenuItem<String>>( (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                                .toList(),
                            onChanged: (newValue) {
                            },
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              "PUSH NOTIFICATIONS",
              style: headerStyle,
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0,),
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    activeColor: Colors.purple,
                    value: true,
                    title: Text("Received notification"),
                    onChanged: (val) {},
                  ),
                  _buildDivider(),
                  SwitchListTile(
                    activeColor: Colors.purple,
                    value: true,
                    title: Text("Received App Updates"),
                    onChanged: null,
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0,),
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Logout"),
                onTap: (){},
              ),
            ),
            const SizedBox(height: 60.0),
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }
}