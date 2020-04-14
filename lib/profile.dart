import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool enable=false;
  String dogname;
  String color;
  String dropdownValue='Male';
  DateTime selectedDate = DateTime.now();
  int days;
  String breed;

  _ProfileState(){
    basicdetails();
  }


  @override
  void initState() {
    calculateyears();
    if(enable==false){
      //basicdetails();
    }

  }

  basicdetails() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String user= prefs.getString('user');
    Map<String, String> headers = {"Content-type": "application/json"};
    String url = 'http://10.0.2.2:4300/basicdetails';
    final msg = jsonEncode({"email": user});
    Response response = await post(url, headers: headers, body: msg);
    int statusCode = response.statusCode;
    print(statusCode);
    String bodyText = response.body;
    var injson=json.decode(bodyText);
    print(injson[0]);
    if(statusCode==200){
      DateTime todayDate = DateTime.parse(injson[0]['dateofbirth']);
      setState(() {
        dogname=injson[0]['dogname'];
        selectedDate=todayDate;
        color=injson[0]['color'];
        breed=injson[0]['breed'];
        dropdownValue=injson[0]['gender'];
      });
    }

  }

  dynamic myEncode(dynamic item) {
    if(item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  _updatedata() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user= prefs.getString('user');
    Map<String, String> headers = {"Content-type": "application/json"};
    String url = 'http://10.0.2.2:4300/updatebasicdetails';
    var date = json.encode(selectedDate, toEncodable: myEncode);
    final msg = jsonEncode({"email": user,"dogname":dogname,"dateofbirth":date,"color":color,"breed":breed,"gender":dropdownValue});
    Response response = await post(url, headers: headers, body: msg);
    int statusCode = response.statusCode;
    print(statusCode);
    if(statusCode==200){
      //basicdetails();
    }
}

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2005, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    calculateyears();
  }
int ageofdog;
  calculateyears(){
    print("aaya");
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - selectedDate.year;
    int month1 = currentDate.month;
    int month2 = selectedDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = selectedDate.day;
      if (day2 > day1) {
        age--;
      }
    }

    setState(() {
      ageofdog=age;
      days = currentDate.difference(selectedDate).inDays;
    });
  }

  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _breedController = new TextEditingController();
  final TextEditingController _colorController = new TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context){
    _nameController.text=dogname;
    _breedController.text=breed;
    _colorController.text=color;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AppBar(
            elevation: 0,
            backgroundColor: Colors.grey[300],

            actions: <Widget>[
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Upload picture"),
                  ),

                ],
                onSelected: (value){
                  print("upload");
                },
              ),
            ],
          ),
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(30.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60.0),
                      topRight: Radius.circular(60.0)
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: "Your dog's name"),
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold
                  ),
                  enabled: enable,
                    onChanged: (val){
                      setState(() {
                        dogname=val;
                      });
                    }
                    ,),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _breedController,
                    decoration: InputDecoration(hintText: "Your dog's breed"),
                    style: TextStyle(
                      fontSize: 20.0,
                  ),
                      enabled: enable,
                      onChanged: (val){
                        setState(() {
                          breed=val;
                        });
                      }
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text("Gender", style: TextStyle(
                          fontSize: 20.0
                      )),
                      Spacer(),
                    DropdownButton(

                      value: dropdownValue,
                        items: <String>['Male', 'Female']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                        .toList(),
                      onChanged: (String newValue) {
                        if(enable==false){
                          newValue=null;
                        }
                        else {
                          setState(() {
                            dropdownValue = newValue;
                          });

                        }
                      },

                    )

                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text("Date of birth", style: TextStyle(
                          fontSize: 20.0
                      )),
                      Spacer(),
                      GestureDetector(

                        child: Text("${selectedDate.toLocal()}".split(' ')[0],style: TextStyle(fontSize: 16),),
                        onTap: enable==true ?(){
                          _selectDate(context);
                      }:null
                      ,),

                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text("Age", style: TextStyle(
                          fontSize: 20.0
                      )),
                      Spacer(),
                      Text("$ageofdog years $days days", style: TextStyle(
                          fontSize: 16.0
                      )),

                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text("Color", style: TextStyle(
                          fontSize: 20.0
                      )),
                      Spacer(),
                      Container(
                        width: 80,
                        child: TextField(
                          controller: _colorController,
                          enabled: enable,
                            onChanged: (val){
                              setState(() {
                                color=val;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "color"
                            ),
                            style: TextStyle(
                            fontSize: 16.0
                        )),
                      ),

                    ],
                  ),

                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
          Positioned(
            top: 290,
            right: 40,
            child: GestureDetector(
              child: CircleAvatar(
                  radius: 20.0,
                  foregroundColor: Colors.grey,
                  backgroundColor: Colors.grey.shade200,
                  child:enable==false? Icon(Icons.edit):Icon(Icons.done),
              ),
              onTap: (){
                setState(() {
                  if(enable==false){
                    enable=true;
                  }
                  else{
                    _updatedata();
                    enable=false;
                  }
                //enable=!enable;
                });

              },
            ),
          ),
      Positioned(
        top: 80,
        left: 0,
        right: 0,
        child:Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/imageupload.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),),
        ],
      ),
    );
  }
}