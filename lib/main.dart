import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'V2EX',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new HomePage(title: 'V2EX'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static const platform = const MethodChannel('samples.flutter.io/battery');
  String _batteryLevel = "";
  int index = 0;

  //获取原生电量
  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
      // ignore: non_type_in_catch_clause
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  final List<Text> tabTexts = <Text>[
    new Text('最新', style: new TextStyle(fontSize: 15.0)),
    new Text('最热', style: new TextStyle(fontSize: 15.0))
  ];
  final List<Text> itemTexts = <Text>[
    new Text('首页', style: new TextStyle(fontSize: 12.0)),
    new Text('我的', style: new TextStyle(fontSize: 12.0))
  ];

  @override
  Widget build(BuildContext context) {
    final List<Tab> tabs = [];
    for (int i = 0; i < tabTexts.length; i++) {
      tabs.add(new Tab(
        child: tabTexts[i],
      ));
    }
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
            backgroundColor: Colors.orange,
            title: _getTitle(),
            bottom: new TabBar(
              key: Key('home_tab'),
              isScrollable: false,
              tabs: tabs,
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.white,
            ),
          ), // 标题
          body: new TabBarView(children: [
            new Icon(Icons.directions_car),
            new Icon(Icons.directions_transit)
          ]),
//          drawer: null, //抽屉
          bottomNavigationBar: new BottomNavigationBar(
              onTap: _selectPosition,
              currentIndex: index,
              iconSize: 24.0,
              items: items),
        ),
        length: tabs.length);
  }

  _selectPosition(int index) {
    if (this.index == index) return;
    //TODO navigation

    setState(() {
      this.index = index;
    });
  }

  _getTitle() {
    return new Center(
        child: new Text(this.itemTexts[index].data,
            style: new TextStyle(fontSize: 20.0, color: Colors.white)));
  }
}
