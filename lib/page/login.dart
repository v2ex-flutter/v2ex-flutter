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
  bool finishedLoadImg = false;

  Future<File> _getLocalFile(String fileName) async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/$fileName');
  }

  Future<int> _writeByteString(Uint8List content, String fileName) async {
    try {
      file = await _getLocalFile(fileName);
      // read the variable as a string from the file.
      file.writeAsBytes(content);
      return 1;
    } on FileSystemException {
      return 0;
    }
  }

  void _onPressLogin() {
    print('login');
  }

  void _onPressRegister() {
    print('register');
  }
  
  void _requestAuthCode() {
    finishedLoadImg = false;
    file = null;
    V2Request req = new V2Request();
    req.getLoginInfo((resp) {
      imgUrl = resp['authImg'];
      Request reqq = new Request(imgUrl, {}, RequestMethod.ReadBytes);
      reqq.start((list) {
        _writeByteString(list, resp['imgName']).then((int i){
          setState(() {
            finishedLoadImg = true;
          });
        });
      });
      setState(() {
      });

    });
  }

  void _onPressReload() {
    _requestAuthCode();
  }

  @override
  void initState() {
    super.initState();
    _requestAuthCode();
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
                  hintText: '用户名',
                  icon: new Icon(Icons.verified_user),
                  ),
                ),
              new TextField(
                controller: _passwdController,
                decoration: new InputDecoration(
                  hintText: '密码',
                  icon: new Icon(Icons.security),
                  ),
                ),
              new _AuthCodeState(_authController, imgUrl, file, finishedLoadImg, _onPressReload),
              new _ConfirmState(_onPressLogin, _onPressRegister),
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
  final Function tapAuthCodeAction;

  _AuthCodeState(this.controller, this.imgUrl, this.file, this.canload, this.tapAuthCodeAction);

  Widget _getAuthImage() {
    if (canload) {
      print(file);
      return new GestureDetector(
          child: new Image.file(
            file,
            width: 100.0, 
            height: 40.0,
            ),
          onTap: tapAuthCodeAction,
          );
    }
    return new Container();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 50.0,
        child:
        new Row(
          mainAxisAlignment: MainAxisAlignment.start, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new Container(
              width: 230.0,
              height: 100.0,
              child: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                  icon: new Icon(Icons.autorenew),
                  hintText: "验证码",
                  fillColor: new Color.fromRGBO(100, 100, 100, 1.0),
                  )),
              ),
            _getAuthImage(),
        ]));
  }
}

class _ConfirmState extends StatelessWidget {
  final Function _loginAction;
  final Function _registerAction;

  _ConfirmState(this._loginAction, this._registerAction);

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 100.0,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            new Container(
              padding: const EdgeInsets.only(right: 50.0),
              child: new RaisedButton(
                child: new Text('登录'),
                onPressed: _loginAction,
                ),
              ),
            new RaisedButton(
              child: new Text('注册'),
              onPressed: _registerAction,
              ),
          ],
          ),
        );
  }

}
