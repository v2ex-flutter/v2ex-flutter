import 'dart:convert';
import 'package:http/http.dart' as http;

typedef void BaseCallBack(http.Response response);

enum RequestMethod {
  Get,
  Post,
}

class Request {
  RequestMethod method;
  String url;
  Map params;

  Request(this.url, this.params, this.method);

  void start(BaseCallBack callback) {
    switch (method) {
      case RequestMethod.Get:
        http.get(url).then(
            (http.Response response) {
              callback(response);
            }
            );
        break;
      case RequestMethod.Post:
        http.post(url, body: params).then(
            (response) {
              callback(response);
            }
            );

    }
  }
}
