import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_learning/constant/Api.dart';
import 'package:flutter_learning/widget/ListItem.dart';

class HomeList extends StatefulWidget {
  HomeList({Key key, this.flag}) : super(key: key);
  final int flag;

  @override
  _HomeListState createState() => new _HomeListState();
}

class _HomeListState extends State<HomeList> {
  var result;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: result == null ? 0 : result.length,
        itemBuilder: (context, i) {
          return new ListItem(result: result[i]);
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
}
