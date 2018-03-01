import 'package:flutter/material.dart';
import '../utils/v2_request.dart';
import '../utils/request.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:typed_data';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userController = new TextEditingController();
  TextEditingController _passwdController = new TextEditingController();
  TextEditingController _authController = new TextEditingController();

  String imgUrl;
  File file;
  bool finishedLoadImg;

  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/verify.png');
  }

  Future<int> _writeByteString(Uint8List content) async {
    try {
      file = await _getLocalFile();
      // read the variable as a string from the file.
      file.writeAsBytes(content);
      return 1;
    } on FileSystemException {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    finishedLoadImg = false;

    V2Request req = new V2Request();
    req.getLoginInfo((resp) {
      imgUrl = resp['authImg'];
      Request reqq = new Request(imgUrl, {}, RequestMethod.ReadBytes);
      reqq.start((list) {
        _writeByteString(list).then((int i){
          setState(() {
            finishedLoadImg = true;
          });
        });
      });
      setState(() {
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('登录'),
          ),
        body: new Padding(
          padding: new EdgeInsets.all(20.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new TextField(
                controller: _userController,
                decoration: new InputDecoration(
                  hintText: 'Input user name',
                  ),
                ),
              new TextField(
                controller: _passwdController,
                decoration: new InputDecoration(
                  hintText: 'Input password',
                  ),
                ),
              new _AuthCodeState(_authController, imgUrl, file, finishedLoadImg),
            ]
            )
          ),
          );
  }
}

class _AuthCodeState extends StatelessWidget {
  final TextEditingController controller;
  final String imgUrl;
  final File file;
  final bool canload;


  _AuthCodeState(this.controller, this.imgUrl, this.file, this.canload);

  Widget _getAuthImage() {
    if (canload) {
      return new Image.file(file);
    }
    return new Container();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        // height: 100.0,
        color: new Color.fromRGBO(100,100,100, 0.5),
        // padding: const EdgeInsets.all(32.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            new TextField(
              controller: controller,
              decoration: new InputDecoration(
                icon: new Icon(Icons.print),
                hintText: "验证码",
                fillColor: new Color.fromRGBO(100, 100, 100, 1.0),
                )
              ),
            _getAuthImage(),
          ]
          )
        );
  }
}
