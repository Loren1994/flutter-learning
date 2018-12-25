import 'package:flutter/material.dart';

class Person extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(20),
          child: FlatButton(
              child: Text("按钮1"),
              color: Colors.orangeAccent,
              highlightColor: Colors.orangeAccent[700],
              colorBrightness: Brightness.dark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () => {}),
        )
      ],
    );
  }
}
