import 'package:flutter/material.dart';
import 'MedicalDetail.dart';
import 'dart:ui';


class Medical extends StatefulWidget {
  @override
  _MedicalState createState() => _MedicalState();
}

class _MedicalState extends State<Medical> {
  @override
  Widget build(BuildContext context) {
    Check check=new Check();
    return new Scaffold(
      body: new GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        children: new List<Widget>.generate(check.length(), (index) {
          return new GridTile(
            child: GestureDetector(
              child:  Container(

                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(check.checkurl(index)),
                    fit: BoxFit.cover,

                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(10.0, 10.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),

                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                //color: Colors.blue[50],
                //color: Colors.grey.withOpacity(0.1),
                  child: Center(
                    child: Text (check.checktitle(index),textAlign:TextAlign.center),
                  ),
                ),
              onTap:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MedicalDetail(check.checktitle(index))),
                );
              }

            ),

            );
          }
      ),
    ),
    );

  }

}



class Check{
  var title=["Vet visits","Vaccination","Deworming","Fleas & ticks","Medications","Medical Conditions","Alergies","Diagnostic Tests","Lab Documents","Other medical Conditions"];
  var url=["assets/icons/vetvisits.png",
    "assets/icons/vaccination.png",
    "assets/icons/Deworming.png",
    "assets/icons/fleas.png",
    "assets/icons/medication.png",
    "assets/icons/mcondition.png",
    "assets/icons/alergies.png",
    "assets/icons/test.png",
    "assets/icons/lab.png",
    "assets/icons/others.png"
  ];

  checktitle(index) {
    return (title[index]);
  }

  checkurl(index) {
    return (url[index]);
  }
  length(){
    return title.length;
  }

  images(){
    return url[0];
}
}

