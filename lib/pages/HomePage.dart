import 'package:flutter/material.dart';
import 'package:flutter_learning/pages/HomeList.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<Text> tabTexts = <Text>[
    new Text('最新', style: new TextStyle(fontSize: 15.0)),
    new Text('最热', style: new TextStyle(fontSize: 15.0))
  ];

  @override
  Widget build(BuildContext context) {
    final List<Tab> tabs = [];
    for (int i = 0; i < tabTexts.length; i++) {
      tabs.add(new Tab(
        child: tabTexts[i],
      ));
    }
    return new DefaultTabController(
        child: new Scaffold(
          appBar: new AppBar(
            titleSpacing: 0.0,
            backgroundColor: Colors.orangeAccent,
            primary: true,
            title: new TabBar(
              isScrollable: false,
              tabs: tabs,
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.white,
            ),
          ),
          body: new TabBarView(
              children: [new HomeList(flag: 0), new HomeList(flag: 1)]),
        ),
        length: tabs.length);
  }
}
