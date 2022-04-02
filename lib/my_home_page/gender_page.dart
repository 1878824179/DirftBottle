//性别选择页面
import 'dart:ui';
import 'package:flutter/material.dart';
import 'register_page.dart';

class Sex extends StatefulWidget {
  const Sex({Key? key}) : super(key: key);

  @override
  _SexState createState() => _SexState();
}

class _SexState extends State<Sex> {
  String _gender = ' ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _background(),
    );
  }

  Widget _background() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 1000,
          child: Image.asset(
            "assets/Image/主页.png",
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: ClipRect(
            //使图片模糊区域仅在子组件区域中
            child: BackdropFilter(
              //背景过滤器
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), //设置图片模糊度
              child: Opacity(
                //悬浮的内容
                opacity: 0.5,
                child: Container(
                  color: Colors.grey.shade200,
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment(0.1, -0.5),
                        child: SizedBox(
                          width: 150,
                          height: 50,
                          child: Center(
                            child: Text(
                              "你的性别？",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(-0.6, -0.1),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset("assets/Image/男生.png"),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0.6, -0.1),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset("assets/Image/女生.png"),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(-0.9, 0.2),
                        child: Container(
                            margin:
                            const EdgeInsets.only(left: 23, top: 40, right: 23),
                            alignment: const Alignment(0, 0),
                            height: 50,
                            width: 122,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                              border:
                              Border.all(width: 1, color: Colors.red),
                            ),
                            child: InkWell(
                              child: const Center(
                                child: Text('男生'),
                              ),
                              onTap: () {
                                _gender = '男';
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return Register(
                                        sex: _gender,
                                      );
                                    }));
                              },
                            )),
                      ),
                      Align(
                        alignment: const Alignment(0.9, 0.2),
                        child: Container(
                            margin:
                            const EdgeInsets.only(left: 23, top: 40, right: 23),
                            alignment: const Alignment(0, 0),
                            height: 50,
                            width: 122,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                              border:
                              Border.all(width: 1, color: Colors.red),
                            ),
                            child: InkWell(
                              child: const Center(
                                child: Text('女生'),
                              ),
                              onTap: () {
                                _gender = "女";
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return Register(
                                        sex: _gender,
                                      );
                                    }));
                              },
                            )),
                      ),
                      Align(
                        alignment: const Alignment(0, 0.5),
                        child: Container(
                          child: const Text(
                            "注意哦，一旦选择不可修改哦！",
                            style:
                            TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                          decoration: BoxDecoration(
                            border:
                            Border.all(width: 1, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
