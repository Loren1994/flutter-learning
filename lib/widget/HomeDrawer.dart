import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text('Loren'),
            accountEmail: new Text('dayan805@163.com'),
            currentAccountPicture: new GestureDetector(
              onTap: () {},
              child: new CircleAvatar(
                backgroundImage: new NetworkImage(
                    'https://avatars3.githubusercontent.com/u/19885732?s=460&v=4'),
              ),
            ),
            decoration: new BoxDecoration(
              color: Colors.blue,
            ),
          ),
          new ListTile(
              title: new Text('首页'),
              onTap: () {
                Fluttertoast.showToast(msg: "首页");
              }),
          new ListTile(
            title: new Text('我的'),
            onTap: () {
              Fluttertoast.showToast(msg: "我的");
            },
          ),
        ],
      ),
    );
  }
}
