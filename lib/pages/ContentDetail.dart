import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_learning/constant/Api.dart';

class ContentDetail extends StatefulWidget {
  ContentDetail({
    Key key,
    this.topicId,
    this.avatar,
    this.title,
  }) : super(key: key);
  var topicId;
  var avatar;
  var title;

  @override
  State<StatefulWidget> createState() {
    return _ContentDetail();
  }
}

class _ContentDetail extends State<ContentDetail> {
  var result = "";
  var node;
  var hasContent = false;

  @override
  void initState() {
    getDetailData();
    super.initState();
  }

  getDetailData() async {
    var res = await _getLatestData();
    if (!mounted) return;
    setState(() {
      this.node = json.decode(res)[0];
      this.result = json.decode(res)[0]["content_rendered"];
      this.hasContent = json.decode(res)[0]["content_rendered"].isEmpty;
    });
  }

  Future<String> _getLatestData() async {
    var url = "${Api.TOPIC_URL}?id=${widget.topicId}";
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  Widget _buildTitle() {
    var url_head = "https://${widget.avatar.toString().substring(2)}";
    return Container(
      child: Row(children: <Widget>[
        Image(
          image: NetworkImage(url_head),
          width: 24.0,
        ),
        Text(widget.title),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return null != widget.topicId
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "主题详情",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  _buildTitle(),
                  this.hasContent
                      ? Center(
                          child: Text("无内容"),
                        )
                      : Html(
                          data: this.result,
                        )
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "主题详情",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Center(
              child: Text("参数错误"),
            ),
          );
  }
}
