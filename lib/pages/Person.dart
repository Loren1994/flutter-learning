import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Person extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VisLayout();
  }
}

class VisLayout extends State<Person> {
  bool vis = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Offstage(
        offstage: vis,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 100),
              child: InkWell(
                onTap: () => this.setState(() {
                      vis = true;
                    }),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.red,
                        Colors.orange,
                        Colors.orangeAccent
                      ]),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(2, 2),
                            blurRadius: 3)
                      ]),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 120, vertical: 10),
                    child: Text(
                      "登录",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 16),
              child: RaisedButton(
                  color: Colors.orangeAccent,
                  highlightColor: Colors.orangeAccent[700],
                  onPressed: () => Fluttertoast.showToast(msg: "注册"),
                  colorBrightness: Brightness.dark,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 105, vertical: 10),
                    child: Text("注册"),
                  )),
            ),
          ],
        ),
      ),
      Offstage(
        offstage: !vis,
        child: RaisedButton(
          onPressed: () => this.setState(() {
                vis = false;
              }),
          child: Text("test text"),
        ),
      )
    ]);
  }
}
