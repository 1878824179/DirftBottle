//启动页
import 'package:flutter/material.dart';
import 'dart:async';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      //3秒后跳转到其他路由
      Navigator.of(context).pushReplacementNamed("/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    //启动图片
    return Image.asset("assets/Image/启动页.png", fit: BoxFit.cover);
  }
}
