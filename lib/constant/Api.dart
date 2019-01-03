class Api {
  //具体参数参考: https://github.com/djyde/V2EX-API
  static final host = "https://www.v2ex.com/";

  //LOGIN
  static final LOGIN_URL = "${host}signin";

  //sign up
  static final REGISTER_URL = "${host}signup";

  //最新主题
  static final LATEST_URL = "${host}api/topics/latest.json";

  //最热主题
  static final HOT_URL = "${host}api/topics/hot.json";

  //网站信息
  static final WEB_INFO_URL = "${host}api/site/info.json";

  //网站状态
  static final WEB_STATE_URL = "${host}api/site/stats.json";

  //取所有节点
  static final ALL_NODE_URL = "${host}api/nodes/all.json";

  //取节点信息
  static final NODE_INFO_URL = "${host}api/nodes/show.json";

  //主题信息
  static final TOPIC_URL = "${host}api/topics/show.json";

  //主题回复
  static final REPLY_URL = "${host}api/replies/show.json";

  //用户信息
  static final MEMBER_INFO_URL = "${host}api/members/show.json";
}
