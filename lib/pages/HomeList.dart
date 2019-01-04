import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_learning/constant/Api.dart';
import 'package:flutter_learning/pages/ContentDetail.dart';
import 'package:flutter_learning/widget/ListItem.dart';

class HomeList extends StatefulWidget {
  HomeList({Key key, this.flag}) : super(key: key);
  final int flag;

  @override
  _HomeListState createState() => new _HomeListState();
}

class _HomeListState extends State<HomeList>
    with AutomaticKeepAliveClientMixin {
  var result;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, int) {
          return Divider(height: 1);
        },
        itemCount: result == null ? 0 : result.length,
        itemBuilder: (context, i) {
          return InkWell(
            child: ListItem(result: result[i]),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return ContentDetail(
                  topicId: result[i]["id"],
                  avatar: result[i]["member"]["avatar_large"],
                  title: result[i]["title"],
                  topicTag:
                      "${result[i]["node"]["parent_node_name"]}/${result[i]["node"]["title"]}",
                  username: result[i]["member"]["username"],
                  createTime: result[i]["created"],
                );
              }));
            },
          );
        });
  }

  _decodeData() async {
    var res = await _getLatestData();
    if (!mounted) return;
    setState(() {
      this.result = json.decode(res);
    });
  }

  Future<String> _getLatestData() async {
    var url = widget.flag == 0 ? Api.LATEST_URL : Api.HOT_URL;
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  @override
  void initState() {
    super.initState();
    _decodeData();
  }

  @override
  bool get wantKeepAlive => true;
}
