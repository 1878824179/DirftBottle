//登录页面
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../log_file/my_home_page.dart';
import '../model/login_model.dart';
import 'forgot_account_page_one.dart';
import 'gender_page.dart';
import 'package:http/http.dart' as http;

import 'privacy_policy_page.dart';
import 'user_agreement_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordState = true;
  bool checkState = false;
  bool forget = false;
  bool hasBorder = false;
  var _loginUsername = '';
  var _loginPassword = '';

  final TextEditingController accentControl = TextEditingController();
  final TextEditingController passwordControl = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  late TapGestureRecognizer _reGistProtocolRecognizer;
  late TapGestureRecognizer _privacyProtocolRecognizer;

  _saveData(LoginModel _loginModel) async {
    final prefs = await SharedPreferences.getInstance();
    if (_loginModel.image.toString() == "default.png") {
      await prefs.setString("link", "assets/Image/default.png");
    } else {
      await prefs.setString(
          "link", "assets/Image/" + _loginModel.image.toString());
    }
    if (_loginModel.occupation == null) {
      await prefs.setString("occupation", "请选择职业");
    } else {
      await prefs.setString("occupation", _loginModel.occupation.toString());
    }
    if (_loginModel.address == null) {
      await prefs.setString("address", "请选择地址");
    } else {
      await prefs.setString("occupation", _loginModel.occupation.toString());
    }
    await prefs.setString("password", _loginPassword);
    await prefs.setString("sex", _loginModel.sex.toString());
    await prefs.setString('token', _loginModel.token.toString());
    await prefs.setString('username', _loginModel.username.toString());
    await prefs.setString('state', _loginModel.state.toString());
  }

  Future<bool> _postData() async {
    var apiUrl = Uri.parse(
        "http://47.108.217.36:8086/login?password=$_loginPassword&username=$_loginUsername");
    var _response = await http.get(apiUrl);
    LoginModel _loginModel;
    if (_response.body.isNotEmpty) {
      _loginModel =
          LoginModel.fromMap(jsonDecode(utf8.decode((_response.bodyBytes))));
      if (_loginUsername == _loginModel.username) {
        _saveData(_loginModel);
        return true;
      }
    }
    return false;
  }

  ///生命周期函数 页面创建时执行一次
  @override
  void initState() {
    super.initState();
    //注册协议的手势
    _reGistProtocolRecognizer = TapGestureRecognizer();
    //隐私协议的手势
    _privacyProtocolRecognizer = TapGestureRecognizer();
  }

  ///生命周期函数 页面销毁时执行一次
  @override
  void dispose() {
    super.dispose();

    ///销毁
    _reGistProtocolRecognizer.dispose();
    _privacyProtocolRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.only(top: 74),
              width: 360,
              height: 690,
              //color: Colors.red,
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    SizedBox(
                      width: 113.5,
                      height: 140,
                      child: Image.asset(
                        "assets/Image/漂流瓶.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    _buildAccentTextField(),
                    _buildPassWordTextField(),
                    _buildButton(),
                    _registerAndForgot(),
                    _notice(),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  ///账户
  Widget _buildAccentTextField() {
    return SingleChildScrollView(
      child: Container(
        //color: Colors.black,
        height: 40,
        margin: const EdgeInsets.only(top: 90),
        child: TextField(
          controller: accentControl,
          decoration: InputDecoration(
            hintText: "请输入昵称",
            errorStyle: const TextStyle(fontSize: 12, color: Colors.black),
            contentPadding: const EdgeInsets.only(bottom: 5, left: 7),
            icon: const Icon(Icons.people),
            suffixIcon: GestureDetector(
              onTap: () {
                ///添加点击事件
                accentControl.text;
                accentControl.clear();
              },
              child: const Icon(Icons.clear),
            ),
          ),
          onChanged: (username) {
            _loginUsername = username;
          },
        ),
      ),
    );
  }

  ///密码
  Widget _buildPassWordTextField() {
    return SingleChildScrollView(
      child: Container(
        height: 40,
        //color: Colors.red,
        margin: const EdgeInsets.only(top: 40),
        child: TextField(
          controller: passwordControl,
          obscureText: passwordState,
          maxLength: 8,
          onChanged: (password) {
            _loginPassword = password;
          },

          ///通过改变变量的值改变输入是否可见
          decoration: InputDecoration(
            icon: const Icon(Icons.lock),
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
            hintText: "请输入密码",
            errorStyle: const TextStyle(fontSize: 5, color: Colors.red),
            contentPadding: const EdgeInsets.only(top: 10, left: 7),
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
        margin: const EdgeInsets.only(left: 23, right: 23, top: 30),
        alignment: const Alignment(0, 0),
        height: 44.5,
        width: 360,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 1, color: Colors.red),
        ),
        child: InkWell(
          child: const Center(
            child: Text('登陆'),
          ),
          onTap: () {
            _postData().then((success) {
              if (success) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHome()),
                  (route) => false,
                );
              } else {
                Fluttertoast.showToast(
                  textColor: Colors.red,
                  msg: "登录失败，请检查账号或密码是否正确！",
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

  Widget _registerAndForgot() {
    return Row(
      children: [
        Container(
          height: 20,
          width: 80,
          margin: const EdgeInsets.only(left: 38),
          child: InkWell(
            child: const Text(
              "注册",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Sex()),
                    (route) => false,
              );
            },
          ),
        ),
        const SizedBox(width: 130),
        Container(
          height: 20,
          width: 80,
          margin: const EdgeInsets.only(right: 30),
          child: InkWell(
            child: const Text(
              "忘记密码？",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Forgot()),
                    (route) => false,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _notice() {
    return Container(
      color: Colors.white,
      height: 20,
      margin: const EdgeInsets.only(left: 29, right: 29, top: 130),
      child: RichText(
        ///文字居中
        ///textAlign: TextAlign.center,
        ///文字区域
        text: TextSpan(
          text: "登录即表示阅读并同意",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
          children: [
            TextSpan(
              text: "《用户协议》",
              style: const TextStyle(color: Colors.blue, fontSize: 12),
              //点击事件
              recognizer: _reGistProtocolRecognizer
                ..onTap = () {
                  //打开用户协议
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const UserAgreement()),
                        (route) => false,
                  );
                },
            ),
            const TextSpan(
              text: "与",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            TextSpan(
              text: "《隐私协议》",
              style: const TextStyle(color: Colors.blue, fontSize: 12),
              //点击事件
              recognizer: _privacyProtocolRecognizer
                ..onTap = () {
                  //打开隐私协议
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Privacy()),
                        (route) => false,
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
