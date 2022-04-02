//注册页面
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../my_home_page/verification_page.dart';

class Register extends StatefulWidget {
  final String sex;

  const Register({Key? key, required this.sex}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool? passWordIsTrue=false;
  var a = '';
  var b = '';
  late var _passWord1=" ";
  late var _passWord2=" ";
  late var _userName=" ";
  bool isFlag = true;
  bool passwordState = true;
  bool comFirmPassword = true;
  bool checkState = false;
  bool forget = false;
  bool hasBorder = false;
  final TextEditingController accentControl = TextEditingController();
  final TextEditingController passwordControl = TextEditingController();
  final TextEditingController comFirmPasswordControl = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  Future<bool> _getData() async {
    var url = Uri.parse(
        'http://47.108.217.36:8086/register?password=$_passWord1&password1=$_passWord2&sex=${widget.sex}&username=$_userName');
    var response = await http.get(url);
    if (response.body == "true") {
      passWordIsTrue=true;
       return true;
    }
    return false;
  }

  ///判断输入是否按要求输入密码
  _judgePassword(String v) {
    RegExp mobile = RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8}$");
    return mobile.hasMatch(v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "注册",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: _register(),
    );
  }

  Widget _register() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          const SizedBox(
            height: 81.5,
          ),
          _setName(),
          const SizedBox(
            height: 40,
          ),
          _setPassword(),
          const SizedBox(
            height: 40,
          ),
          _comFirmPassword(),
          const SizedBox(
            height: 49,
          ),
          _next(),
        ],
      ),
    );
  }

  Widget _setName() {
    return Container(
      height: 35,
      //color: Colors.blue,
      margin: const EdgeInsets.only(left: 23.5, right: 22.5),
      child: TextField(
          controller: accentControl,
          decoration: InputDecoration(
            hintText: "请设置昵称",
            hintStyle: const TextStyle(fontSize: 18),
            contentPadding: const EdgeInsets.only(left: 7),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  accentControl.text;
                  accentControl.clear();
                });
              },
              child: const Icon(Icons.clear),
            ),
          ),
          onChanged: (text) {
            _userName = text;
          }),
    );
  }

  Widget _setPassword() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 23.5, right: 22.5, top: 20),
      child: TextFormField(
        controller: passwordControl,
        maxLength: 8,
        validator: (text) {
          a = passwordControl.text;
          _passWord1 = passwordControl.text;
          if (!_judgePassword(text!) && text.trim().length == 8) {
            return "密码不符合要求、请重新设置";
          } else {
            return null;
          }
        },
        obscureText: passwordState,
        decoration: InputDecoration(
            hintText: "请设置8位字母级数字组合密码",
            hintStyle: const TextStyle(fontSize: 18),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  passwordState = !passwordState;
                });
              },
              child: Icon(
                Icons.remove_red_eye,
                color: passwordState ? Colors.black : Colors.red,
              ),
            )),
      ),
    );
  }

  Widget _comFirmPassword() {
    return Container(
        height: 50,
        margin: const EdgeInsets.only(left: 23.5, right: 22.5),
        child: TextFormField(
          maxLength: 8,
          controller: comFirmPasswordControl,
          validator: (k) {
            b = comFirmPasswordControl.text;
            _passWord2 = passwordControl.text;
            if (a != b && k!.trim().length == 8) {
              return "两次密码不一致、或重复昵称，请重新设置密码";
            } else {
              return null;
            }
          },
          obscureText: comFirmPassword,
          decoration: InputDecoration(
              hintText: "请再次输入以确认密码",
              hintStyle: const TextStyle(fontSize: 18),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    comFirmPassword = !comFirmPassword;
                  });
                },
                child: Icon(
                  Icons.remove_red_eye,
                  color: comFirmPassword ? Colors.black : Colors.red,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto),
        ));
  }

  Widget _next() {
    return Container(
        margin: const EdgeInsets.only(left: 23, right: 23),
        alignment: const Alignment(0, 0),
        height: 50,
        width: 360,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 1, color: Colors.black),
        ),
        child: InkWell(
          child: const Center(
            child: Text(
              '下一步',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          onTap: () {
            _getData().then((value){
              if (value&&a != ''&&b !=' ' ) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return Verification(userName: _userName);
                }));
              } else {
                Fluttertoast.showToast(
                  textColor: Colors.red,
                  msg: "注册失败，,账户已存在或请按要求进行注册",
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
