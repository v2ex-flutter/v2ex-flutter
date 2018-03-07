import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:typed_data';

typedef void BaseCallBack(response);

enum RequestMethod {
  Get,
  Post,
  ReadBytes,
}

class Request {
  RequestMethod method;
  String url;
  Map params;
  Map headers = {
    "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
    "accept-encoding": "gzip, deflate, br",
    "upgrade-insecure-requests": "1",
    "accept-language": "en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7",
    "cache-control": "max-age=0",
    "user-agent": "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Mobile Safari/537.36",

    // Implement cookie module later.
    "cookie": "PB3_SESSION=\"2|1:0|10:1519881745|11:PB3_SESSION|40:djJleDoyMjAuMTgxLjM4LjExMzoyMjcxNzE5Nw==|753ac08b016ba89bc104fed3db7e3f0820c48d010442681f06ffda29c5c30ba0\"; V2EX_LANG=zhcn; V2EX_REFERRER=\"2|1:0|10:1519881917|13:V2EX_REFERRER|12:eWVlbG9uZQ==|ad53dd75370a4acc6f48a29d6c54a9ecc28c76ea475f8abc64fff37b6c2d4f58\"; A2=\"2|1:0|10:1519882019|2:A2|56:MjJhODNiZDQ2OWUxZjQ4Zjk1MzEwOTUzNjBjNWE2NzQ0MDE4YjEzOQ==|067a4d138e68a42578a0417a19fd4f9bf60ee6b25fd08fcd08bb246cf23d6ee2\"; V2EX_TAB=\"2|1:0|10:1519883432|8:V2EX_TAB|8:am9icw==|b8da291467cb489c20c56197d0838b1f48788579b79541c3730295de2b495776\"",
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
      case RequestMethod.ReadBytes:
        http.readBytes(url, headers: headers).then(
            (Uint8List list) {
              callback(list);
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
