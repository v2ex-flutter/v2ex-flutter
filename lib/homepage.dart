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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  int _counter = 0;
  AppLifecycleState _notification;


  void initState() {
    super.initState();
    // WidgetBuilder.instance.addObserver(self);

  }

  void dispose() {
    // WidgetBuilder.instance.removeObserver(self);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print('$state');
    // setState(() { _notification = state; });
  }
 
  // @override
  // Future<bool> didPushRoute(String route) {
    // print('$route');
    // return null;
  // }

  void _incrementCounter() async {
    Request req = new Request('http://mmmmmax.cn/list' ,{}, RequestMethod.Get);
    req.start((response) {
      print(response.bodyBytes);
    });
  }

  List<Widget> _getV2Feed() {
    List<Widget> _v2List = <Widget>[];

    return _v2List;
  }

  @override
  Widget build(BuildContext context) {
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
        floatingActionButton: new FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: new Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
