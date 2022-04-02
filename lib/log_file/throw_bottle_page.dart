//捞捞看
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'my_home_page.dart';

class ThrowBottle extends StatefulWidget {
  const ThrowBottle({Key? key}) : super(key: key);

  @override
  _ThrowBottleState createState() => _ThrowBottleState();
}

class _ThrowBottleState extends State<ThrowBottle>
    with SingleTickerProviderStateMixin {
  late var username = " ";
  late var state = " ";
  late var token = " ";
  late var time = " ";
  late var _bottleContent = " ";
  String link = " 123";
  final TextEditingController writeControl = TextEditingController();

  Future _readShared() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString('username')!;
    state = preferences.getString('state')!;
    token = preferences.getString('token')!;
    link = preferences.getString("link")!;
  }

  var headers = <String, String>{};

  Future _postBottle() async {
    var apiUrl = Uri.parse(
        "http://47.108.217.36:8086/admin/insert?information=$_bottleContent&username=$username");

    headers["token"] = token;
    headers["state"] = state;
    headers["username"] = username;
    await http.get(apiUrl, headers: headers);
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
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Image/主页.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: _top(),
      ),
    );
  }

  Widget _top() {
    return Column(
      children: [
        const SizedBox(
          height: 35,
        ),
        _topControl(),
        _sentence(),
        _theBody(),
      ],
    );
  }

  Widget _topControl() {
    return SizedBox(
      //color: Colors.red,
      width: 360,
      height: 50,
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 50,
            //color: Colors.grey,
            child: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            }),
          ),
          const SizedBox(
            width: 80,
          ),
          const SizedBox(
            width: 80,
            height: 50,
            //color: Colors.black54,
            child: Center(
              child: Text(
                "扔一个",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sentence() {
    return Container(
        height: 60,
        margin: const EdgeInsets.only(top: 20),
        child: Stack(
          children: [
            Image.asset(
              "assets/Image/对话框.png",
              fit: BoxFit.cover,
            ),
            const Center(
              child: Text(
                "漂流瓶在海上漂泊，最终会遇到它想遇到的人",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _theBody() {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(width: 1, color: Colors.black),
      // ),
      width: 360,
      height: 400,
      //color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          ///头像框
          SizedBox(
            width: 360,
            height: 50,
            // color: Colors.black,
            child: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: ClipOval(
                  child: ClipOval(
                    child: Image.asset(
                      link,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                //color: Colors.red,
              ),
            ),
          ),

          ///处理文字输入
          Container(
            margin: const EdgeInsets.all(1),
            width: 360,
            height: 290,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.black),
            ),
            child: TextField(
              maxLength: 800,
              controller: writeControl,
              maxLines: 12,
              textAlign: TextAlign.start,
              decoration: const InputDecoration(
                hintText: "请输入你想写的内容",
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                border: InputBorder.none,
                // suffixIcon: GestureDetector(
                //   onTap: (){
                //     writeControl.clear();
                //   },
                // ),
              ),
              onChanged: (test) {
                _bottleContent = test;
              },
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 2),
              height: 50,
              width: 170,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: InkWell(
                child: const Center(
                  child: Text(
                    '扔进海里',
                    style: TextStyle(
                      fontSize: 25,
                      //color: Colors.black54,
                    ),
                  ),
                ),
                onTap: () {
                  _postBottle().then(
                    (value) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          opaque: true,
                          transitionDuration: const Duration(seconds: 2),
                          pageBuilder: (BuildContext context, _, __) {
                            return const MyHome();
                          },
                          transitionsBuilder: (_, Animation<double> animation,
                              __, Widget child) {
                            return FadeTransition(
                              opacity: animation,
                              child: RotationTransition(
                                turns: Tween<double>(begin: 0.0, end: 1.0)
                                    .animate(animation),
                                child: child,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
