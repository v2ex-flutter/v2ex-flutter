import 'request.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the UTF8.encode method
import 'cookie.dart';


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
        List keyList = document.getElementsByClassName('sl');
        if (keyList.length < 3) {
          ret['statusCode'] = 500;
          ret['statusMsg'] = 'Wrong format!';
          callback(ret);
          return;
        }
        ret['name'] = keyList[0].attributes['name'];
        ret['passwd'] = keyList[1].attributes['name'];
        ret['auth'] = keyList[2].attributes['name'];
        // Get auth image.
        Node imgNode = keyList[2].parentNode.parentNode.previousElementSibling.children[0].children[0];
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
        ret['imgName'] = sha1.convert(UTF8.encode(imgUrl)).toString();
        print(ret);
        callback(ret);
      } catch (e) {
        print(e);
      }
    });
  }
}
