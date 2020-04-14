import 'package:dog/DailyRecords/excercise.dart';
import 'package:dog/DailyRecords/hygiene.dart';
import 'package:flutter/material.dart';
import 'Others.dart';

class Records extends StatefulWidget {
  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Colors.teal[200],
            bottom: TabBar(

              indicatorColor: Colors.white,
              tabs: [
                Tab(child: Text('Fitness'),),
                Tab(child: Text('Hygiene'),),
                Tab(child: Text('Others'),),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Excercise(),
            Hygiene(),
            Others(),
          ],
        ),
      ),
    );
  }
}

