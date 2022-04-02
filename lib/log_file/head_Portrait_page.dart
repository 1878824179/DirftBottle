import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'my_home_page.dart';

class Photo extends StatefulWidget {
  const Photo({Key? key}) : super(key: key);

  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  String username = " ";
  String token = " ";
  String state = " ";
  String sex = "";
  String link = "";
  List<String> boyPhoto = [
    "assets/Image/default.png",
    "assets/Image/boy1.png",
    "assets/Image/boy2.png",
    "assets/Image/boy3.png",
    "assets/Image/boy4.png",
    "assets/Image/boy5.png",
    "assets/Image/boy6.png",
    "assets/Image/boy7.png",
    "assets/Image/boy8.png",
  ];
  List<String> girlPhoto = [
    "assets/Image/default.png",
    "assets/Image/girl1.png",
    "assets/Image/girl2.png",
    "assets/Image/girl3.png",
    "assets/Image/girl4.png",
    "assets/Image/girl5.png",
    "assets/Image/girl6.png",
    "assets/Image/girl7.png",
    "assets/Image/girl8.png",
  ];

  var headers = <String, String>{};

  Future _readShared() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    link = preferences.getString("link")!;
    username = preferences.getString('username')!;
    state = preferences.getString('state')!;
    token = preferences.getString('token')!;
    sex = preferences.getString("sex")!;
    link = preferences.getString("link")!;
  }

  Future _postImage() async {
    link = link.substring(13);
    var apiUrl = Uri.parse(
        "http://47.108.217.36:8086/image?url=$link&username=$username");
    http.get(apiUrl, headers: headers);
    final prefs = await SharedPreferences.getInstance();
    link = "assets/Image/" + link;
    await prefs.setString("link", link.toString());
  }

  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => setState(() {
              _readShared();
            }));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _head(),
    );
  }

  Widget _head() {
    return SizedBox(
      height: 1000,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 1000,
            child: Image.asset(
              "assets/Image/P]~@P@1~FW3@H]MW9KXOJS8.jpg",
              fit: BoxFit.fitWidth,
            ),
          ),
          //height: 570,
          //color: Colors.red,
          Center(
            child: ClipRect(
              //使图片模糊区域仅在子组件区域中
              child: BackdropFilter(
                //背景过滤器
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), //设置图片模糊度
                child: Opacity(
                  //悬浮的内容
                  opacity: 0.75,
                  child: Container(
                    color: Colors.grey.shade200,
                    child: Stack(
                      children: [
                        Align(
                          alignment: const Alignment(-0.95, -0.85),
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            //color: Colors.red,
                            child: InkWell(
                              child: const Icon(Icons.arrow_back_ios),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, -0.75),
                          child: SizedBox(
                            height: 130,
                            width: 130,
                            //color: Colors.red,
                            child: Stack(
                              children: [
                                Container(
                                  height: 130,
                                  width: 130,
                                  child: Image.asset(
                                    link,
                                    fit: BoxFit.contain,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(80),
                                  ),
                                ),
                                const Align(
                                  alignment: Alignment(1, 1),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, 0.5),
                          child: SizedBox(
                            //color: Colors.red,
                            height: 420,
                            width: 360,
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      MediaQuery.of(context).size.height / 5,
                                  mainAxisSpacing: 3,
                                  crossAxisSpacing: 3,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: boyPhoto.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return itemWidget(index);
                                }),
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
      ),
    );
  }

  /// gridview小组件
  itemWidget(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          sex == "男" ? link = boyPhoto[index] : link = girlPhoto[index];
          _postImage().then((value) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyHome()),
              (route) =>false,
            );
          });
        });
      },
      child: Container(
        width: 50,
        height: 50,
        child: ClipOval(
          child: Image.asset(
            sex == "男" ? link = boyPhoto[index] : link = girlPhoto[index],
            fit: BoxFit.cover,
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(80),
        ),
      ),
    );
  }
}
