//找回密码1
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'forgot_account_page_two.dart';
import 'package:http/http.dart' as http;

class Forgot extends StatefulWidget {
  const Forgot({Key? key}) : super(key: key);

  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  late String _userName = " ";
  late var _question = " ";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController questionController = TextEditingController();

  Future<bool> _securityJudge() async {
    var apiUrl = Uri.parse(
        "http://47.108.217.36:8086/findpa?question=$_question&username=$_userName");
    var _response = await http.get(apiUrl);
    if (_response.body == "true") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "找回密码",
          style: TextStyle(color: Colors.black54, fontSize: 20),
        ),
      ),
      body: _questionColum(),
    );
  }

  Widget _questionColum() {
    return Column(
      children: [
        const SizedBox(
          height: 94,
        ),
        _getName(),
        const SizedBox(
          height: 23,
        ),
        _answer(),
        const SizedBox(
          height: 30,
        ),
        _nextButton(),
      ],
    );
  }

  Widget _getName() {
    return Container(
      height: 50,
      //color: Colors.blue,
      margin: const EdgeInsets.only(left: 23, right: 23),
      child: TextField(
        controller: nameController,
        decoration: InputDecoration(
            hintText: "请输入你的昵称",
            hintStyle: const TextStyle(fontSize: 18),
            contentPadding: const EdgeInsets.only(left: 7),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  nameController.clear();
                });
              },
              child: const Icon(Icons.clear),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.blue),
              borderRadius: BorderRadius.circular(10),
            )),
        onChanged: (test) {
          _userName = test;
        },
      ),
    );
  }

  Widget _answer() {
    return Container(
      margin: const EdgeInsets.only(left: 23, right: 23),
      height: 75,
      child: TextField(
        controller: questionController,
        decoration: InputDecoration(
            hintText: "请输入你最喜欢的城市、食物以及动物",
            helperText: "例如：新疆、苹果、狗",
            helperStyle: const TextStyle(fontSize: 12),
            hintStyle: const TextStyle(fontSize: 15),
            contentPadding: const EdgeInsets.only(left: 7),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  questionController.clear();
                });
              },
              child: const Icon(Icons.clear),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.blue),
              borderRadius: BorderRadius.circular(10),
            )),
        onChanged: (test) {
          _question = test;
        },
      ),
    );
  }

  Widget _nextButton() {
    return Container(
        margin: const EdgeInsets.only(left: 23, right: 23),
        alignment: const Alignment(0, 0),
        height: 44.5,
        width: 360,
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: InkWell(
          child: const Center(
            child: Text('下一步'),
          ),
          onTap: () {
            ///判断是否验证成功
            _securityJudge().then((success) {
              if (success) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return SetPassword(
                    loginUserName: _userName,
                  );
                }));
              } else {
                Fluttertoast.showToast(
                  textColor: Colors.red,
                  msg: "账号或验证信息错误，请重试！",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.white,
                  fontSize: 12,
                );
              }
            });
          },
        ));
  }
}
