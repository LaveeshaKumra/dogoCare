import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  var data;
  _DiscoverPageState(){
    _getdata();
  }
  @override
  void initState() {
    super.initState();
    _getdata();
  }

  _getdata() async{
    String url = 'http://10.0.2.2:4300/discover';
    Response response = await get(url);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String bodyText = response.body;
      var x = json.decode(bodyText);
      setState(() {
        data=x;
        print(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(
        children: <Widget>[
          SizedBox(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text("Facts about dogs",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.teal[400]),textAlign: TextAlign.center,),
          ),
          data!=null? Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            height: MediaQuery.of(context).size.height * 0.68,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: <Widget>[
                     Container(

                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/bg.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ListView(
                                children: <Widget>[
                                  Text(
                                    data[index]["title"].toString(),
                                    style: TextStyle(color: Colors.black, fontSize: 20.0,fontWeight: FontWeight.bold,),
                                  ),
                                  SizedBox(height: 30,),
                                  Text(
                                    data[index]["description"].toString(),
                                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                    ),
                    ],
                  );
                }),
          ):Container(),
        ],
      )
    );
  }
}
