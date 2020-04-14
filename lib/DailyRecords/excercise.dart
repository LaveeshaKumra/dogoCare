import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Excercise extends StatefulWidget {
  @override
  _ExcerciseState createState() => _ExcerciseState();
}

class _ExcerciseState extends State<Excercise> {
  var data ;
  var nexttime,nextdate;
  var duration;
  var durationtype="hours";
  var time;
  var nextdatetime;


  _ExcerciseState(){
     show_records=false;
     _getdetails();
     _getduration();
  }

  bool show_records=false;
  @override
  void initState() {
    super.initState();
    _getdetails();
    _getduration();
  }

  _getdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user');
    Map<String, String> headers = {"Content-type": "application/json"};
    String url = 'http://10.0.2.2:4300/fitnessrecords';
    final msg = jsonEncode({"email": user, "type": "fitness"});
    Response response = await post(url, headers: headers, body: msg);
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode == 200) {
      String bodyText = response.body;
      var x = json.decode(bodyText);
      if(x.length>0)
      {
        setState(() {
          time=x[0]["time"];
          data=x;
          nexttime=_getnexttime(x[0]["nexttime"]);
          nextdate=_getnextdate(x[0]["nexttime"]);
        });
        _savingnexttime(x[0]["time"]);
      }
      else{
        _savingnexttime(DateTime.now().toString());
      }

    }
  }

  _addnew() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user');
    Map<String, String> headers = {"Content-type": "application/json"};
    String url = 'http://10.0.2.2:4300/insertfitnessrecord';
    print("yyhyu$nextdatetime");
    final msg = jsonEncode({"email": user, "type": "fitness","nexttime":nextdatetime.toString(),"time":DateTime.now().toString()});
    await post(url, headers: headers, body: msg);
    _getdetails();
  }

  _getdate(value){
    var x=DateTime.parse(value);
    var y=formatDate(x, [dd, '/', mm, '/', yyyy]);
    return y;
  }



  _gettime(value){
    var x=DateTime.parse(value);
    var y=DateFormat.jm().format(x.toLocal());
    return y;
  }

  _getnexttime(value){
    var y=DateTime.parse(value);
    var z=DateFormat.jm().format(y);
    print(z);
    return z;
  }

  _getnextdate(value){
    var y=DateTime.parse(value);
    var z=DateFormat.yMMMMd('en_US').format(y);
    print("yy"+z);
    return z;
  }

  var timeperiod;
  _getduration() async{
    Map<String, String> headers = {"Content-type": "application/json"};
    String url = 'http://10.0.2.2:4300/getduration';
    final msg = jsonEncode({"type": "fitness"});
    Response response = await post(url, headers: headers, body: msg);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String bodyText = response.body;
      var x = json.decode(bodyText);
      print(x[0]["duration"]);
      setState(() {
        duration = x[0]["duration"];
        Duration d=new Duration(hours: duration);
        if(duration>24){
          var days=d.inDays;
          print(days);
          timeperiod=days;
          durationtype="days";
        }
      });
    }
  }

  _savingnexttime(value) {
    print(value);
    var y=DateTime.parse(value);
    var x=y.toLocal().add(new Duration(hours: duration));
    setState(() {
      nextdatetime=x;
    });
  }

  Future<bool> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you to sure to mark it as done?'),
          actions: <Widget>[
            FlatButton (
              child: const Text('Yes'),
              onPressed: () async{
                Navigator.pop(context, true);
                await _addnew();
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

  _showalertdialog() async{
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change duration of tasks from settings'),
          actions: <Widget>[
            FlatButton (
              child: const Text('Ok'),
              onPressed: () async{
                Navigator.pop(context);
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
        body: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            show_records==false?Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child:  ListTile(
                        leading: Icon(Icons.repeat, size: 30),
                        title: Text('Schedule'),
                        subtitle: Text("Repeat after every repaettime"),
                        trailing:Text("$duration $durationtype"),
                      ),
                      onTap: () async{
                        _showalertdialog();
                      },
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: (data!=null)? ListTile(
                      leading: Icon(Icons.update, size: 30),
                      title: Text('Upcoming'),
                      subtitle:Text('Next time for excercise \n$nexttime\non $nextdate'),
                      trailing: GestureDetector(
                        child: Icon(Icons.done, size: 30,color: Colors.green),
                        onTap: (){
                          _showConfirmationDialog(context);
                        },
                      ),
                    ):
                    ListTile(
                      leading: Icon(Icons.update, size: 30),
                      title: Text('Record'),
                      trailing: GestureDetector(
                        child: Icon(Icons.done, size: 30,color: Colors.green),
                        onTap: (){
                          _showConfirmationDialog(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ):SizedBox(height: 0,),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Column(
               // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Past Records'),
                    trailing:  GestureDetector(
                      child: show_records==false?Icon(Icons.arrow_downward):Icon(Icons.arrow_upward),
                      onTap: (){
                        print("heyy");
                        setState(() {
                          show_records=!show_records;
                        });

                      },),
                  ),
                ],
              ),
            ),

            show_records==true && data!=null?Expanded(
              child: GroupedListView<dynamic, String>(
                groupBy: (element) => _getdate(element['time']).toString(),
                elements: data,
                groupSeparatorBuilder: (String value) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 16,
                        ), //fontWeight: FontWeight.bold),
                      )),
                ),
                itemBuilder: (c, element) {
                  return Card(
                    elevation: 0.5,
                    margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      child: ListTile(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        leading: new Image.asset(
                          "assets/icons/excercise.png",
                          width: 40,
                        ),
                        title: Text(_gettime(element['time'])),
                      ),
                    ),
                  );
                },
                //order: GroupedListOrder.DESC,
              ),
            ):SizedBox(height: 20,),
          ],
        ));
  }
}

