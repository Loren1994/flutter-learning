import 'dart:convert';
import 'dart:io';

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
  var usernameController = TextEditingController(text: "Loren1994");
  var passwordController = TextEditingController();
  var personInfo;

  getPersonData() async {
    var res = await _getPersonData();
    var jsonRes = json.decode(res);
    if (jsonRes["status"] != "found") {
      Fluttertoast.showToast(msg: jsonRes["message"]);
      return;
    }
    if (!mounted) return;
    setState(() {
      this.personInfo = jsonRes;
    });
  }

  Future<String> _getPersonData() async {
    var url = "${Api.MEMBER_INFO_URL}?username=${usernameController.text}";
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  Widget _buildPerson() {
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(
              personInfo != null ? "https:${personInfo["avatar_large"]}" : ""),
          radius: 30,
        ),
        Text(personInfo != null ? personInfo["username"] : ""),
        Text(personInfo != null && personInfo["bio"] != null
            ? personInfo["bio"]
            : ""),
        Text(
            personInfo != null ? "V2EX第${personInfo["id"].toString()}位会员" : ""),
      ],
    );
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
                  Fluttertoast.showToast(msg: "登录API未开放");
//                  login();
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
                    if (usernameController.text.trim().isEmpty) {
                      Fluttertoast.showToast(msg: "请填入正确用户名");
                      return;
                    }
                    getPersonData();
                    this.setState(() {
                      vis = true;
                    });
                  },
                  colorBrightness: Brightness.dark,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 90, vertical: 10),
                    child: Text("用户信息"),
                  )),
            ),
          ],
        ),
      ),
      Offstage(
        offstage: !vis,
        child: Center(
            child: Column(
          children: <Widget>[
            FlatButton(
                color: Colors.grey,
                highlightColor: Colors.grey[700],
                onPressed: () {
                  this.setState(() {
                    vis = false;
                  });
                },
                colorBrightness: Brightness.dark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 90, vertical: 10),
                  child: Text("返回"),
                )),
            _buildPerson()
          ],
        )),
      )
    ]);
  }

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
}
