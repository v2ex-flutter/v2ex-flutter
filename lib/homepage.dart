import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'request.dart';
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List v2List;

  void _incrementCounter() {
    Request req = new Request('https://www.v2ex.com/api/topics/latest.json' ,{}, RequestMethod.Get);
    req.start((response) {
      try {
        List data = JSON.decode(response.body);
      } catch(e) {
        print(e);
      }
    });
  }

  void _queryV2List() {
    if (v2List != null) {
      return;
    }
    Request req = new Request('https://www.v2ex.com/api/topics/latest.json' ,{}, RequestMethod.Get);
    req.start((response) {
      try {
        List data = JSON.decode(response.body);
        setState(() {
          v2List = data;
        });
      } catch(e) {
        print(e);
      }
    });
  }

  List<Widget> _getV2Feed() {
    List<Widget> _v2List = <Widget>[];
    for (var i = 0, len = v2List.length; i < len; ++i) {
      String t = v2List[i]['title'];
      Text wid = new Text(t);
      _v2List.add(wid);
    }

    return _v2List;
  }

  @override
  Widget build(BuildContext context) {

    _queryV2List();

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _getV2Feed(),
            ),
          ),
        // floatingActionButton: new FloatingActionButton(
          // onPressed: _incrementCounter,
          // tooltip: 'Increment',
          // child: new Icon(Icons.add),
          // ), // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
