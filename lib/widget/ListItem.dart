import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {

  var result;

  ListItem(this.result);

  @override
  _ListItemState createState() => new _ListItemState(this.result);
}

class _ListItemState extends State<StatefulWidget> {
  var result;

  _ListItemState(this.result);

  @override
  Widget build(BuildContext context) {
    return new Text(result["title"]);
  }
}
