
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'loginPage.dart';

class SetPassword extends StatefulWidget {
  final String loginUserName;

  const SetPassword({Key? key, required this.loginUserName}) : super(key: key);

  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  var fitstJudge = " ";
  var secondJudge = " ";
  late var _loginPassword1 = " ";
  late var _loginPassword2 = " ";
  bool passwordState = true;
  bool affirmPasswordState = true;
  final TextEditingController affirmPassword = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  Future<void> _getData() async {
    var apiUrl = Uri.parse(
        "http://47.108.217.36:8086/updateAdmin?password=$_loginPassword1&password1=$_loginPassword2&username=${widget.loginUserName}");
    await http.get(apiUrl);
  }

  _judgePassword(String v) {
    RegExp mobile = RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8}$");
    return mobile.hasMatch(v);
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
      body: _set(),
    );
  }

  Widget _set() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          const SizedBox(
            height: 94,
          ),
          _password(),
          const SizedBox(
            height: 43,
          ),
          _affirmPassword(),
          const SizedBox(
            height: 43,
          ),
          _nextButton(),
        ],
      ),
    );
  }

  Widget _password() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 23, right: 23),
      child: TextFormField(
        controller: password,
        obscureText: passwordState,
        maxLength: 8,
        validator: (text) {
          _loginPassword1 = text!;
          fitstJudge = password.text;
          if (!_judgePassword(text) && text.trim().length == 8) {
            return "密码不符合要求、请重新设置";
          } else {
            return null;
          }
        },

        ///通过改变变量的值改变输入是否可见
        decoration: InputDecoration(
          ///小眼睛图标， GestureDetector()包裹的东西可以添加事件
          suffixIcon: GestureDetector(
            onTap: () {
              ///添加点击事件
              setState(() {
                ///setState用来刷新界面
                passwordState = !passwordState;
              });
            },
            child: Icon(
              Icons.remove_red_eye,
              color: passwordState ? Colors.black : Colors.red,
            ),

            ///Icon(Icons.remove_red_eye)为小眼睛图标
          ),

          ///GestureDetector将点击事件设置为：点击改变isvisible的值，从而改变密码的可见性
          ///没有输入时的显示内容
          hintText: "请重置8位数字及组合密码",
          hintStyle: const TextStyle(fontSize: 18),
          contentPadding: const EdgeInsets.only(top: 10, left: 7),
        ),
      ),
    );
  }

  Widget _affirmPassword() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 23, right: 23, top: 20),
      child: TextFormField(
        controller: affirmPassword,
        obscureText: affirmPasswordState,
        maxLength: 8,
        validator: (test) {
          _loginPassword2 = test!;
          secondJudge = affirmPassword.text;
          if (fitstJudge != secondJudge && test.trim().length == 8) {
            return "两次密码不一致，请重新设置密码";
          }
          return null;
        },

        ///通过改变变量的值改变输入是否可见
        decoration: InputDecoration(
          ///小眼睛图标， GestureDetector()包裹的东西可以添加事件
          suffixIcon: GestureDetector(
            onTap: () {
              ///添加点击事件
              setState(() {
                ///setState用来刷新界面
                affirmPasswordState = !affirmPasswordState;
              });
            },
            child: Icon(
              Icons.remove_red_eye,
              color: affirmPasswordState ? Colors.black : Colors.red,
            ),

            ///Icon(Icons.remove_red_eye)为小眼睛图标
          ),

          ///GestureDetector将点击事件设置为：点击改变isvisible的值，从而改变密码的可见性
          ///没有输入时的显示内容
          hintText: "请再次输入以确认密码",
          hintStyle: const TextStyle(fontSize: 18),
          contentPadding: const EdgeInsets.only(top: 10, left: 7),
        ),
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
          //border: new Border.all(width: 1,color: Colors.red),
        ),
        child: InkWell(
          child: const Center(
            child: Text('下一步'),
          ),
          onTap: () {
            _getData().then((value) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
              Fluttertoast.showToast(
                textColor: Colors.red,
                msg: "成功找回密码",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.white,
                fontSize: 12,
              );
            });
          },
        ));
  }
}
