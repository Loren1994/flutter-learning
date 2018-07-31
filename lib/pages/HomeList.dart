import 'package:flutter/material.dart';

class HomeList extends StatefulWidget {
  HomeList({Key key, this.flag}) : super(key: key);
  final int flag;

  @override
  _HomeListState createState() => new _HomeListState(flag: flag);
}

class _HomeListState extends State<StatefulWidget> {
  _HomeListState({this.flag});

  final int flag;

  @override
  Widget build(BuildContext context) {
    return new Text("列表$flag");
  }
}
