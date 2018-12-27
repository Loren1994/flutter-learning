import 'dart:_http';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_learning/constant/Api.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PtrList extends StatefulWidget {
  @override
  _PtrListState createState() => new _PtrListState();
}

class _PtrListState extends State<PtrList> {
  List list;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var _scrollController = new ScrollController();
  var hasMore = true;
  var pageIndex = 1;

  @override
  void initState() {
    super.initState();
    refreshList(true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (pageIndex >= 2) {
          setState(() {
            hasMore = false;
          });
        }
        setState(() {
          pageIndex++;
        });
        refreshList(false);
      }
    });
  }

  Future<Null> refreshList(flag) async {
    if (flag) {
      setState(() {
        hasMore = true;
        pageIndex = 1;
      });
    }
    if (!hasMore) {
      Fluttertoast.showToast(msg: "暂无更多");
      debugPrint("暂无更多");
      return null;
    }
    debugPrint("请求页数:$pageIndex");
    if (flag) {
      refreshKey.currentState?.show(atTop: true);
    }
    var res = await _getLatestData();
    setState(() {
      if (flag) {
        this.list = json.decode(res);
      } else {
        this.list.addAll(json.decode(res));
      }
    });
    return null;
  }

  Future<String> _getLatestData() async {
    var url = Api.LATEST_URL;
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      child: ListView.builder(
        itemCount: list?.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(list[i]["title"]),
            ),
        controller: _scrollController,
      ),
      onRefresh: () => refreshList(true),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
