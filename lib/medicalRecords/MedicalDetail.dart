import 'package:dog/profile.dart';
import 'package:flutter/material.dart';
import 'FillDetail.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'EditRecord.dart';
import 'package:intl/intl.dart';

class MedicalDetail extends StatefulWidget {
  String apbar;
  MedicalDetail(data) {
    this.apbar = data;
  }
  @override
  _MedicalDetailState createState() => _MedicalDetailState(this.apbar);
}

class _MedicalDetailState extends State<MedicalDetail> {
  String apbar;
  var object;
  _MedicalDetailState(data) {
    this.apbar = data;
  }


  @override
  void initState() {
    super.initState();
    _basicdetails();
  }

  _basicdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user');
    Map<String, String> headers = {"Content-type": "application/json"};
    String url = 'http://10.0.2.2:4300/medicalrecords';
    final msg = jsonEncode({"email": user, "type": apbar});
    Response response = await post(url, headers: headers, body: msg);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String bodyText = response.body;
      var x = json.decode(bodyText);
      return x;
    } else
      return null;
  }

  _delete(id) async{
    Map<String, String> headers = {"Content-type": "application/json"};
    String url = 'http://10.0.2.2:4300/deletespecificmedicalrecords';
    final msg = jsonEncode({"medicalid":id});
    Response response = await post(url, headers: headers, body: msg);
    int statusCode = response.statusCode;
    if(statusCode==200) {
    }
    _basicdetails();
  }

  Future<bool> _showConfirmationDialog(BuildContext context,var id) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you to sure you want to delete this record?'),
          actions: <Widget>[
            FlatButton (
              child: const Text('Yes'),
              onPressed: () async{
                Navigator.pop(context, true);
                await _delete(id);
              },
            ),
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context, false); // showDialog() returns false
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(apbar),
        backgroundColor: Colors.teal[200],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[400],
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FillDetail(apbar)),
          );
        },
      ),
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.length);
            if (snapshot.data.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: new Image.asset(
                        "assets/icons/vetvisits.png",
                        width: 40,
                      ),
                      title: Text(snapshot.data[index]["title"]),
                      subtitle: Text(snapshot.data[index]["description"]),
                      trailing: Text(
                          "${DateFormat.yMMMMd('en_US').format(DateTime.parse(snapshot.data[index]['date']).toLocal())}"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditRecord(
                                    snapshot.data[index]["medicalid"])));
                      },
                      onLongPress: (){
                        _showConfirmationDialog(context, snapshot.data[index]['medicalid']);
                      },
                    ),
                  );
                },
              );
            } else {
              print("yee");
              return Center(
                  child: Text(
                "No data found!",
                style: TextStyle(fontSize: 22),
              ));
            }
          } else {
            return FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 2000)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return AlertDialog(
                      title: Text("No internet connection !"),
                      content: Text("Connect to internet and try again later"),
                      actions: [
                        FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  else
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 40,
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text("Loading.."),
                          )
                        ],
                      ),
                    ); // Return empty container to avoid build errors
                });
          }
        },
        future: _basicdetails(),
      ),
    );
  }
}
