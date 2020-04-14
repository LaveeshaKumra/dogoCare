import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class EditRecord extends StatefulWidget {
  var id;
  EditRecord(data){
    this.id=data;
  }
  @override
  _EditRecordState createState() => _EditRecordState(this.id);
}

class _EditRecordState extends State<EditRecord> {
  var id;
  TextEditingController _controllertitle;
  TextEditingController _controllerdate;
  TextEditingController _controllerdesc;


  String title,description,date;
  _EditRecordState(data){
    this.id=data;
  }
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

     _getdata();


  }

  _getdata() async{
    Map<String, String> headers = {"Content-type": "application/json"};
    String url = 'http://10.0.2.2:4300/specificmedicalrecords';
    final msg = jsonEncode({"medicalid":id});
    Response response = await post(url, headers: headers, body: msg);
    int statusCode = response.statusCode;
    String bodyText = response.body;
    var injson=json.decode(bodyText);
    if(statusCode==200) {
      setState(() {
        date=DateFormat('yyyy-MM-dd').format(DateTime.parse(injson[0]['date']));
        title=injson[0]['title'];
        description=injson[0]['description'];
      });
    }
    _controllertitle = new TextEditingController(text: title);
    _controllerdate = new TextEditingController(text: date);
    _controllerdesc= new TextEditingController(text: description);

  }



  _save() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String url = 'http://10.0.2.2:4300/updatespecificmedicalrecords';
    final msg = jsonEncode({"medicalid":id,"date": _controllerdate.text,"title":_controllertitle.text,"description":_controllerdesc.text});
    Response response = await post(url, headers: headers, body: msg);
    Navigator.pop(context);
  }


_delete() async{
  Map<String, String> headers = {"Content-type": "application/json"};
  String url = 'http://10.0.2.2:4300/deletespecificmedicalrecords';
  final msg = jsonEncode({"medicalid":id});
  Response response = await post(url, headers: headers, body: msg);
  int statusCode = response.statusCode;
  if(statusCode==200) {
    //await _getdata();
  }
}

  Future<bool> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to delete this record?'),
          actions: <Widget>[
            FlatButton (
              child: const Text('Yes'),
              onPressed: () async{
                Navigator.pop(context, true);
                await _delete();
                Navigator.pop(context);
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
        title: Text("Edit details"),
        backgroundColor: Colors.teal[200],
        actions: <Widget>[
          GestureDetector(child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.delete),
          ),onTap: (){
            _showConfirmationDialog(context);
          },),
        ],
      ),
      body: Builder(
        builder: (context) =>
         Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              new Form(
                  autovalidate: true,
                  child: Column(
                  children: <Widget>[
                     TextFormField(
                       controller: _controllertitle,
                      cursorColor: Colors.teal,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.edit,color: Colors.teal),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelStyle: TextStyle(color: Colors.teal),
                        hintText: 'Title',
                        labelText: 'Title',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                    ),
                     TextFormField(
                       controller: _controllerdate,
                      cursorColor: Colors.teal,
                      decoration:  InputDecoration(
                        icon: const Icon(Icons.calendar_today,color: Colors.teal,),
                        hintText: 'yyyy/mm/dd',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Date',
                        labelStyle: TextStyle(color: Colors.teal),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                     TextFormField(
                       controller: _controllerdesc,
                      maxLines: null,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.description,color: Colors.teal,),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelStyle: TextStyle(color: Colors.teal),
                        hintText: 'Desciption',
                        labelText: 'Description',
                        //errorMaxLines: 20,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    new RaisedButton(
                      color: Colors.teal[300],
                        child: const Text('Save Changes'),
                          onPressed: (){
                            if(_controllertitle.text=="" && _controllerdate.text==""){
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text("Enter date and title"),)
                              );
                            }
                           else if(_controllerdate.text=="" ){
                             Scaffold.of(context).showSnackBar(
                                 SnackBar(content: Text("Enter date"),)
                             );
                           }
                           else if(_controllertitle.text==""){
                             Scaffold.of(context).showSnackBar(
                                 SnackBar(content: Text("Enter Title"),)
                             );
                           }
                           else{
                             _save();
                           }
                          }

                        ),
                  ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

