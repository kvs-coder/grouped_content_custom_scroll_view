import 'package:flutter/material.dart';
import 'package:grouped_content_custom_scroll_view/grouped_content_custom_scroll_view.dart';

void main() {
  runApp(MyApp());
}

class MyData {
  const MyData(
    this.header,
    this.entries,
  );

  final int header;
  final List<String> entries;
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
    final myDataList = [
      MyData(0, ['My best friend', 'Good friend of mine', 'Guy I do not know']),
      MyData(1, ['My cat', 'My dog', 'My fish', 'My bird']),
      MyData(2, []),
    ]
        .map((e) => GroupedContentData<int, String>(
            header: e.header, entries: e.entries))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: GroupedContentCustomScrollView<int, String>(
        data: myDataList,
        appBar: SliverAppBar(
          title: Text('SliverAppBar'),
          backgroundColor: Colors.green,
          expandedHeight: 200.0,
        ),
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
            '$header',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
        ),
        bodyEntryBuilder: (_, index, item) => GestureDetector(
          onTap: () {
            print(item);
            print(index);
          },
          child: Card(
              color: Colors.lightBlueAccent,
              child: Container(
                  height: _kHeight,
                  alignment: Alignment.center,
                  child: Text(
                    item,
                    style: TextStyle(color: Colors.white),
                  ))),
        ),
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
