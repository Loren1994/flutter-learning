import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  ListItem({Key key, this.result}) : super(key: key);
  final result;

  @override
  _ListItemState createState() => new _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(12), child: Text(widget.result["title"]));
  }
}
