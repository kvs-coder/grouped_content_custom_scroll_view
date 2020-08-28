# sliver_grouped_list

SliverGroupedList Widget

Build a beautiful sliver with a custom header, footer and body, which can be divided by groups with a header for each group and a list of entries.

![Alt Text](assets/demo.gif)

## Getting Started

- Go inside pubspec.yaml file<br/>
- Add this to your package's pubspec.yaml file:<br/>
<i>dependencies:<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sliver_grouped_list: ^1.0.3</i>
- Run <b>flutter pub get</b>

## How to use

Go to your widget .dart file and do import<br/>
<b>import 'package:sliver_grouped_list/sliver_grouped_list.dart';</b>

Inside your widget's <b>Widget build(BuildContext context)</b> method
set as body the <b>SliverGroupedList</b> and implement all required constructor parameters.
As a result the custom scroll view will contain the content of the passed data.
Optionally you may add a <b>RenderObjectWidget</b> widget like <b>SliverGrid</b> or <b>SliverGrid</b> header section to the scroll view, and a footer as well.<br/>

Here is an example which is displayed in the GIF from above.

``` Dart
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
  static const double _kHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: SliverGroupedList<String, String>(
        data: {
          'A': ['My best friend', 'Good friend of mine', 'Guy I do not know'],
          'B': ['My cat', 'My dog', 'My fish', 'My bird'],
          'C': ['My mom', 'My dad', 'My sis']
        },
        header: SliverGrid.count(
          crossAxisCount: 3,
          children: [
            Container(color: Colors.white, height: _kHeight),
            Container(color: Colors.black, height: _kHeight),
            Container(color: Colors.grey, height: _kHeight),
            Container(color: Colors.grey, height: _kHeight),
            Container(color: Colors.white, height: _kHeight),
            Container(color: Colors.black, height: _kHeight),
            Container(color: Colors.black, height: _kHeight),
            Container(color: Colors.grey, height: _kHeight),
            Container(color: Colors.white, height: _kHeight),
          ],
        ),
        bodyHeaderMinHeight: 60.0,
        bodyHeaderMaxHeight: 100.0,
        bodyHeaderPinned: true,
        bodyHeaderFloating: false,
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
                height: _kHeight,
                alignment: Alignment.center,
                child: Text(
                  item,
                  style: TextStyle(color: Colors.white),
                ))),
        onItemTap: (item) => print(item),
        footer: SliverFixedExtentList(
          itemExtent: _kHeight,
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
```