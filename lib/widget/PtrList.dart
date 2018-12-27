import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_learning/constant/Api.dart';

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
      debugPrint("暂无更多");
      return null;
    }
    debugPrint("请求页数:$pageIndex");
    if (flag) {
      refreshKey.currentState?.show(atTop: true);
    }
    var res = await _getLatestData();
    if (!mounted) return null;
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
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: list.length + 1,
        itemBuilder: (context, i) {
          if (i == list.length) {
            return _buildListFooter();
          } else {
            return ListTile(
              title: Text(list[i]["title"]),
            );
          }
        },
        controller: _scrollController,
        separatorBuilder: (BuildContext context, int index) {
          return new Divider();
        },
      ),
      onRefresh: () => refreshList(true),
    );
  }

  Widget _buildListFooter() {
    return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: hasMore
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 12,
                    width: 12,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.grey),
                      strokeWidth: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text("加载中", style: TextStyle(color: Colors.grey)),
                  ),
                ],
              )
            : Center(
                child: Text(
                "暂无更多",
                style: TextStyle(color: Colors.grey),
              )));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
