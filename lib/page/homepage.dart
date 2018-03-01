import 'package:flutter/material.dart';
import '../utils/request.dart';
import 'dart:convert';
import 'login.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _ContentItem extends StatelessWidget {
  final String _author;
  final String _content;

  _ContentItem(this._author, this._content);
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          Navigator.of(context).push(new PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return new LoginPage();
                },
                transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                  return new FadeTransition(
                      opacity: animation,
                      child: new RotationTransition(
                        turns: new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
                        child: child,
                        ),
                      );
                }
                ));
        },
        child: new Container(
                 margin: const EdgeInsets.only(top: 5.0),
                 color: Colors.red[300],
                 child: new Padding(
                   padding: new EdgeInsets.all(8.0),
                   child: new Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       new Text(_author),
                       new Text(_content),
                     ]
                     )
                   )
                 )
          );
  }
}

class _ContentView  extends StatelessWidget {
  final List<Widget> _list;

  _ContentView(this._list);

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.green[300],
        padding: const EdgeInsets.all(12.0),
        child: new ListView(
          children:  _list

          ),
        );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List v2List;

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
    if (v2List != null) {
      for (var i = 0, len = v2List.length; i < len; ++i) {
        String author = v2List[i]['member']['username'];
        String content = v2List[i]['title'];
        _ContentItem item = new _ContentItem(author, content);
        _v2List.add(item);
      }
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
        body: new _ContentView(_getV2Feed()),
        );
  }
}
