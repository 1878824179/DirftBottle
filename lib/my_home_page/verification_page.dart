///验证页面
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'loginPage.dart';

class Verification extends StatefulWidget {
  final String? userName;

  const Verification({Key? key, required this.userName}) : super(key: key);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  late var question = " ";
  final TextEditingController answerControl = TextEditingController();

  _getData() async {
    var url = Uri.parse(
        'http://47.108.217.36:8086/security?question=$question&username=${widget.userName}');
    await http.get(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "安全验证",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: _question(),
    );
  }

  Widget _question() {
    return Column(
      children: [
        const SizedBox(
          height: 94,
        ),
        _myQuestion(),
        const SizedBox(
          height: 23,
        ),
        _answer(),
        const SizedBox(
          height: 34.5,
        ),
        _finishBottom(),
      ],
    );
  }

  Widget _myQuestion() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 23, right: 23),
      child: const Center(
        child: Text(
          "请输出你最喜欢的城市、食物、以及动物",
          style: TextStyle(fontSize: 16),
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _answer() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 23, right: 23),
      child: TextField(
        controller: answerControl,
        decoration: InputDecoration(
          hintText: "请设置你的答案（如：大连、草莓、狗）",
          hintStyle: const TextStyle(fontSize: 15),
          contentPadding: const EdgeInsets.only(left: 5),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (test) {
          question = test;
        },
      ),
    );
  }

  Widget _finishBottom() {
    return Container(
        margin: const EdgeInsets.only(left: 23, right: 23),
        alignment: const Alignment(0, 0),
        height: 44.5,
        width: 360,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 1, color: Colors.black),
        ),
        child: InkWell(
          child: const Center(
            child: Text(
              '完成',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          onTap: () {
            _getData();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const LoginPage();
            }));
            Fluttertoast.showToast(
              textColor: Colors.red,
              msg: "注册成功",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.white,
              fontSize: 12,
            );
          },
        ));
  }
}
