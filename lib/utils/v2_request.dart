import 'request.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

typedef void FunctionMap(Map map);

const String v2Host = 'https://www.v2ex.com';
/*
 * Singleton for v2ex http request.
 */
class V2Request {
  static final v2Request = new V2Request._internal();

  factory V2Request() {
    return v2Request;
  }

  V2Request._internal();

  void getLoginInfo(FunctionMap callback) {
    Request req = new Request(v2Host + '/signin', {}, RequestMethod.Get);
    req.start((response) {
      try {
        Document document = parse(response.body);
        Map ret = new Map();
        // Get auth image.
        Node imgNode = document.getElementsByClassName('sep10')[0].previousElementSibling;
        String styleUrl = imgNode.attributes['style'];
        String regStr = r"url\(\'.*\'\)";
        RegExp reg = new RegExp(regStr);
        Iterable<Match> matches = reg.allMatches(styleUrl);

        String imgUrl;
        matches.forEach((item) {
          imgUrl = item[0].substring(5 , item[0].length - 2);
          imgUrl = v2Host + imgUrl;
        });

        ret['authImg'] = imgUrl; 
        callback(ret);
      } catch (e) {
        print(1);
        print(e);
      }
    });
  }
}
