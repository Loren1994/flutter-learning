import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/constant/Api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart' show parse;

class Person extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VisLayout();
  }
}

class VisLayout extends State<Person> {
  var vis = false;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  Future<String> login() async {
    var dio = Dio();
    dio.options.validateStatus = (int status) {
      print("status code = $status");
      return true;
    };
    var resp = await dio.get(Api.LOGIN_URL);
    var dom = parse(resp.data.toString()).getElementsByClassName("sl");
    print(dom);
    var nameArr = dom[0].attributes["name"];
    var pwdArr = dom[1].attributes["name"];
    var temp = parse(resp.data.toString()).getElementsByClassName("cell")[0];
    var onceValue = temp.children[0].attributes["onclick"]
        .split("?once=")[1]
        .substring(0, 5);
    print(onceValue);
    dio.options.headers = {
      "Origin": Api.host,
      "Referer": Api.LOGIN_URL,
      "Content-Type": "application/x-www-form-urlencoded"
    };
    var response = await dio.post(Api.LOGIN_URL, data: {
      nameArr: usernameController.text,
      "once": onceValue,
      pwdArr: passwordController.text
    });
    print(response.data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Offstage(
        offstage: vis,
        child: Column(
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                  labelText: "用户名",
                  hintText: "用户名",
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.person)),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "登录密码",
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.lock)),
              obscureText: true,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 100),
              child: InkWell(
                onTap: () {
                  if (usernameController.text.trim().isEmpty ||
                      passwordController.text.trim().isEmpty) {
                    Fluttertoast.showToast(msg: "请填入完整账号信息");
                    return;
                  }
                  print(login());
                },
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
                  onPressed: () {
                    Fluttertoast.showToast(msg: "注册");
                    this.setState(() {
                      vis = true;
                    });
                  },
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
