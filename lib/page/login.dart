import 'package:flutter/material.dart';
import '../utils/v2_request.dart';
import '../utils/request.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userController = new TextEditingController();
  TextEditingController _passwdController = new TextEditingController();
  TextEditingController _authController = new TextEditingController();

  String imgUrl;

  @override
  void initState() {
    super.initState();
    V2Request req = new V2Request();
    req.getLoginInfo((resp) {
      setState(() {
        imgUrl = resp['authImg'];
        // print(imgUrl);
        Request reqq = new Request('https://www.v2ex.com/_captcha?once=43930', {}, RequestMethod.Get);
        reqq.start((resp1) {
          print(111);
          print(resp1.body);
        });
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
              new _AuthCodeState(_authController, imgUrl),
            ]
            )
          ),
          );
  }
}

class _AuthCodeState extends StatelessWidget {
  final TextEditingController controller;
  final String imgUrl;

  _AuthCodeState(this.controller, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    // print(imgUrl);
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
                hintText: imgUrl,
                )
              ),
            new Image.asset('images/_captcha.png'),
            // new Image.network(
              // 'imgUrl',
              // // 'https://www.v2ex.com/_captcha?once=43930',
              // // 'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2010939026,1883625057&fm=27&gp=0.jpg',
              // width: 54.0,
              // height: 54.0,
              // color: new Color.fromRGBO(100,100,100, 0.5),
              // ),
          ]
          )
        );
  }
}
