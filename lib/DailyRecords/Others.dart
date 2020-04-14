import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class Others extends StatefulWidget {
  @override
  _OthersState createState() => _OthersState();
}

class _OthersState extends State<Others> {
  var data = [
    {"title": 'Avengers', "release_date": '1/01/2019'},
    {"title": 'Creed', "release_date": '2/01/2019'},
    {"title": 'Jumanji', "release_date": '3/10/2019'},
    {"title": 'hh', "release_date": '31/10/2019'},
    {"title": 'ff', "release_date": '1/11/2019'},
    {"title": 'rr', "release_date": '31/10/2019'},
    {"title": 'we', "release_date": '30/10/2020'},


  ];
  bool show_records;
  _OthersState(){
    show_records=false;
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
                      child: const ListTile(
                        leading: Icon(Icons.repeat, size: 30),
                        title: Text('Schedule'),
                        subtitle: Text("Repeat after every repaettime"),
                        trailing:Text("2 hours"),
                      ),
                      onTap: (){



                      },
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(8.0),
                    child:  ListTile(
                      leading: Icon(Icons.update, size: 30),
                      title: Text('Upcoming'),
                      subtitle: Text('Next time for meal\n1:00 pm'),
                      trailing: GestureDetector(
                        child: Icon(Icons.done, size: 30,color: Colors.green),
                        onTap: (){
                          print("done");
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
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Past Records'),
                    trailing:  GestureDetector(
                      child: show_records==false?Icon(Icons.arrow_upward):Icon(Icons.arrow_downward),
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

            show_records==true?Expanded(
              child: GroupedListView<dynamic, String>(
                groupBy: (element) => element['release_date'],
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
                          "assets/icons/pet.png",
                          width: 40,
                        ),
                        title: Text(element['title']),
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

