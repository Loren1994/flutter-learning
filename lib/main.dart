import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/pages/ContentDetail.dart';
import 'package:flutter_learning/pages/HomePage.dart';
import 'package:flutter_learning/pages/Person.dart';
import 'package:flutter_learning/widget/HomeDrawer.dart';
import 'package:flutter_learning/widget/PtrList.dart';

/** TODO-LIST
 * 1.网络请求的封装
 * 2.SP封装
 * 3.tab保存状态
 * 4.下拉列表组件
 * 5.?tab/nav behavior
 */

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
          //定义静态路由，但不能传递参数
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
    new Text('列表', style: new TextStyle(fontSize: 12.0)),
    new Text('我的', style: new TextStyle(fontSize: 12.0))
  ];
  int selectNavIndex = 0;

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
              icon: new Icon(Icons.view_list), title: itemTexts[index]);
        case 2:
          return new BottomNavigationBarItem(
              icon: new Icon(Icons.account_circle), title: itemTexts[index]);
      }
    });
    return new DefaultTabController(
        child: new Scaffold(
          appBar: new AppBar(
              backgroundColor: Colors.orangeAccent, title: _getTitle()),
          body: new IndexedStack(
            children: <Widget>[new HomePage(), new PtrList(), new Person()],
            index: this.selectNavIndex,
          ),
          drawer: new HomeDrawer(),
          bottomNavigationBar: new BottomNavigationBar(
              items: items,
              onTap: _selectPosition,
              currentIndex: selectNavIndex,
              iconSize: 24.0),
        ),
        length: items.length);
  }

  _selectPosition(int index) {
    if (this.selectNavIndex == index) return;
    setState(() {
      this.selectNavIndex = index;
    });
  }

  _getTitle() {
    return new Text(this.itemTexts[selectNavIndex].data,
        style: new TextStyle(fontSize: 20.0, color: Colors.white));
  }
}
