import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_learning/constant/Api.dart';
import 'package:flutter_learning/constant/Utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentDetail extends StatefulWidget {
  ContentDetail({
    Key key,
    this.topicId,
    this.avatar,
    this.title,
    this.username,
    this.topicTag,
    this.createTime,
  }) : super(key: key);
  var topicId;
  var avatar;
  var title;
  var username;
  var topicTag;
  var createTime;

  @override
  State<StatefulWidget> createState() {
    return _ContentDetail();
  }
}

class _ContentDetail extends State<ContentDetail> {
  var result = "";
  var node;
  var noContent = false;
  var repliesList = [];

  @override
  void initState() {
    getDetailData();
    getRepliesData();
    super.initState();
  }

  getDetailData() async {
    var res = await _getTopicData();
    if (!mounted) return;
    setState(() {
      this.node = json.decode(res)[0];
      this.result = json.decode(res)[0]["content_rendered"];
      this.noContent = json.decode(res)[0]["content_rendered"].isEmpty;
    });
  }

  getRepliesData() async {
    var res = await _getRepliesData();
    if (!mounted) return;
    setState(() {
      this.repliesList = json.decode(res);
    });
  }

  Future<String> _getTopicData() async {
    var url = "${Api.TOPIC_URL}?id=${widget.topicId}";
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  Future<String> _getRepliesData() async {
    var url = "${Api.REPLY_URL}?topic_id=${widget.topicId}";
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  Widget _buildTitle() {
    var urlHead = "https:${widget.avatar}";
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
                        backgroundImage: NetworkImage(urlHead),
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
                  Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 8),
                      child: Text(
                        Utils.transToDate(widget.createTime),
                        style: TextStyle(color: Colors.grey),
                      )),
                ]),
          )
        ],
      ),
    );
  }

  Widget _buildReplies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            "${repliesList == null ? 0 : repliesList.length} 回复 | 直到 ${Utils.transToDateNow()}",
            style: TextStyle(fontSize: 14, color: Colors.blueGrey),
          ),
        ),
        ListView.separated(
            shrinkWrap: true, //否则list占全屏导致不显示
            physics: new NeverScrollableScrollPhysics(),//嵌套时禁止滑动,否则不能触摸回复列表来滑动
            separatorBuilder: (context, int) {
              return Divider(height: 1);
            },
            itemCount: repliesList == null ? 0 : repliesList.length,
            itemBuilder: (context, i) {
              return _buildRepliesItem(i);
            })
      ],
    );
  }

  Widget _buildRepliesItem(int index) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                    "https:${repliesList[index]["member"]["avatar_large"]}"),
                radius: 12,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    "${repliesList[index]["member"]["username"]} 回复于 ",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )),
              Text(
                Utils.transToDate(repliesList[index]["created"]),
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(repliesList[index]["content"]),
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
                          margin: EdgeInsets.all(30),
                          child: Text(
                            "无内容",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : Html(
                          onLinkTap: (url) {
                            _launchURL(url);
                          },
                          data: this.result,
                        ),
                  _buildReplies()
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
