import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_learning/constant/Api.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentDetail extends StatefulWidget {
  ContentDetail({
    Key key,
    this.topicId,
    this.avatar,
    this.title,
    this.username,
    this.topicTag,
  }) : super(key: key);
  var topicId;
  var avatar;
  var title;
  var username;
  var topicTag;

  @override
  State<StatefulWidget> createState() {
    return _ContentDetail();
  }
}

class _ContentDetail extends State<ContentDetail> {
  var result = "";
  var node;
  var noContent = false;

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
      this.noContent = json.decode(res)[0]["content_rendered"].isEmpty;
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
      child: Column(
        children: <Widget>[
          Offstage(
            offstage: this.node != null,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.grey),
              strokeWidth: 2,
            ),
          ),
          Offstage(
            offstage: this.node == null,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(url_head),
                        radius: 12,
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            "${widget.username} 发布在 ",
                            style: TextStyle(color: Colors.grey),
                          )),
                      Text(
                        widget.topicTag,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
          )
        ],
      ),
    );
  }

  Future<void> _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
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
                  this.noContent
                      ? Container(
                          margin: EdgeInsets.only(top: 200),
                          child: Text(
                            "无内容",
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : Html(
                          padding: EdgeInsets.only(top: 20),
                          onLinkTap: (url) {
                            _launchURL(url);
                          },
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
