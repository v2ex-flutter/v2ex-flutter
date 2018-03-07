
class Cookie {
  static Cookie _cookie;
  static Cookie shareInstance() {
    if (null == _cookie) {
      _cookie = new Cookie();
    }
    return _cookie;
  }
  // cookieMap(String host) async{
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // Map ret = prefs.get(host);
    // if (ret is! Map) {
      // return null;
    // }
    // return ret;
  // }
  // saveCookie(String host, Map map) async{
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // Map ret = prefs.get(host);
    // if (null == ret) {
      // ret = new Map();
    // }
  // }
}
