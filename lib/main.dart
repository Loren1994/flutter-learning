import 'package:flutter/material.dart';
import 'package:flutter_learning/pages/ContentDetail.dart';
import 'package:flutter_learning/pages/HomePage.dart';
import 'package:flutter_learning/pages/Person.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'V2EX',
        theme: new ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: new AppPage(title: 'V2EX'),
        routes: <String, WidgetBuilder>{
          '/detail': (BuildContext context) => new ContentDetail()
        });
  }
}

class AppPage extends StatefulWidget {
  AppPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AppPageState createState() => new _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final List<Text> itemTexts = <Text>[
    new Text('首页', style: new TextStyle(fontSize: 12.0)),
    new Text('我的', style: new TextStyle(fontSize: 12.0))
  ];
  var index = 0;
  var isHome = true;

  @override
  Widget build(BuildContext context) {
    final items =
        new List<BottomNavigationBarItem>.generate(itemTexts.length, (index) {
      switch (index) {
        case 0:
          return new BottomNavigationBarItem(
              icon: new Icon(Icons.home), title: itemTexts[index]);
        case 1:
          return new BottomNavigationBarItem(
              icon: new Icon(Icons.account_circle), title: itemTexts[index]);
      }
    });
    return new DefaultTabController(
        child: new Scaffold(
          appBar: new AppBar(
              elevation: 1.0,
              backgroundColor: Colors.orangeAccent,
              title: _getTitle()),
          body: isHome ? new HomePage() : new Person(),
          drawer: new Drawer(
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
          ),
          bottomNavigationBar: new BottomNavigationBar(
              onTap: _selectPosition,
              currentIndex: index,
              iconSize: 24.0,
              items: items),
        ),
        length: items.length);
  }

  _selectPosition(int index) {
    if (this.index == index) return;
    setState(() {
      this.index = index;
      this.isHome = (index == 0);
    });
  }

  _getTitle() {
    return new Text(this.itemTexts[index].data,
        style: new TextStyle(fontSize: 20.0, color: Colors.white));
  }
}
