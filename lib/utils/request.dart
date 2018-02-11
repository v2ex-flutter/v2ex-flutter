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

  static String userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.3 (KHTML, like Gecko) Version/8.0 Mobile/12A4345d Safari/600.1.4";

  Map headers = {
    "user-agent": userAgent,
  };

  Request(this.url, this.params, this.method);

  void start(BaseCallBack callback) {
    switch (method) {
      case RequestMethod.Get:
        http.get(url, headers: headers).then(
            (http.Response response) {
              callback(response);
            }
            );
        break;
      case RequestMethod.Post:
        http.post(url, headers: headers, body: params).then(
            (response) {
              callback(response);
            }
            );

    }
  }
}
