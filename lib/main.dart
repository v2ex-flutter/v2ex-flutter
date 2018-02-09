import 'package:flutter/material.dart';
import 'page/homepage.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'V2EX',
        theme: new ThemeData(
          primarySwatch: Colors.red,
          ),
        home: new MyHomePage(title: 'V2EX'),
        routes: <String, WidgetBuilder> {
          // '/a': (BuildContext context) => new DetailPage(title: 'page a'),
          // '/b': (BuildContext context) => new DetailPage(title: 'page b'),
          // '/c': (BuildContext context) => new DetailPage(title: 'page c'),
        }
        );
  }
}

