import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class FillDetail extends StatefulWidget {
  String type;
  FillDetail(t){
    this.type=t;
  }
  @override
  _FillDetailState createState() => _FillDetailState(this.type);
}

class _FillDetailState extends State<FillDetail> {
  String type;
  _FillDetailState(t){
    this.type=t;
    _controllertitle = new TextEditingController(text: "");
    _controllerdate = new TextEditingController(text: "");
    _controllerdesc= new TextEditingController(text: "");
  }
  TextEditingController _controllertitle;
  TextEditingController _controllerdate;
  TextEditingController _controllerdesc;
  var _selectedDate;
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2005, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user= prefs.getString('user');
    Map<String, String> headers = {"Content-type": "application/json"};
    String url = 'http://10.0.2.2:4300/addmedicalrecords';
    final msg = jsonEncode({"email":user,"type":type,"date": _controllerdate.text,"title":_controllertitle.text,"description":_controllerdesc.text});
    Response response = await post(url, headers: headers, body: msg);
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fill details"),
        backgroundColor: Colors.teal[200],
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
                              errorMaxLines: 20,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          new RaisedButton(
                              color: Colors.teal[300],
                              child: const Text('Save'),
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
                                  //print(_controllertitle.text);
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

