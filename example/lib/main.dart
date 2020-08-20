import 'package:flutter/material.dart';
import 'package:sliver_grouped_list/sliver_grouped_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: SliverGroupedList<String, String>(
        data: {
          'A': ['My best friend', 'Good friend of mine', 'Guy I do not know']
        },
        header: SliverGrid.count(
          crossAxisCount: 3,
          children: [
            Container(color: Colors.white, height: 150.0),
            Container(color: Colors.black, height: 150.0),
            Container(color: Colors.grey, height: 150.0),
            Container(color: Colors.grey, height: 150.0),
            Container(color: Colors.white, height: 150.0),
            Container(color: Colors.black, height: 150.0),
            Container(color: Colors.black, height: 150.0),
            Container(color: Colors.grey, height: 150.0),
            Container(color: Colors.white, height: 150.0),
          ],
        ),
        bodyHeaderBuilder: (_, header) => Container(
          alignment: Alignment.center,
          child: Text(
            header,
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
        ),
        bodyEntryBuilder: (_, item) => Card(
            color: Colors.lightBlueAccent,
            child: Container(
                height: 150,
                alignment: Alignment.center,
                child: Text(
                  item,
                  style: TextStyle(color: Colors.white),
                ))),
        onItemTap: (item) => print(item),
        footer: SliverFixedExtentList(
          itemExtent: 150.0,
          delegate: SliverChildListDelegate(
            [
              Container(color: Colors.black),
              Container(color: Colors.white),
              Container(color: Colors.grey),
              Container(color: Colors.black),
              Container(color: Colors.white),
              Container(color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
