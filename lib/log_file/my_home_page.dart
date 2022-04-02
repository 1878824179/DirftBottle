import 'package:dirft_bottle2/log_file/the_second_throw_bottle_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../my_home_page/loginPage.dart';
import 'head_Portrait_page.dart';
import 'edit_profile_page.dart';
import 'get_bottle_page.dart';
import 'my_bottle_page.dart';
import 'suggestion_page.dart';
import 'throw_bottle_page.dart';
import 'package:http/http.dart' as http;

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin{
  late AnimationController animationController;
  DateTime dateTime = DateTime.now();
  final TextEditingController controller =  TextEditingController();
  bool isConTorThrow = false;
  bool haveContent = false;
  bool? isCancellationAccount;
  String sex = " ";
  String username = " ";
  String state = " ";
  String token = " ";
  String link = " ";
  late var _bottleContent = "";

  ///本地保存
  Future _readShared() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    link = preferences.getString("link")!;
    username = preferences.getString('username')!;
    sex = preferences.getString("sex")!;
    state = preferences.getString('state')!;
    token = preferences.getString('token')!;
  }

  ///注销账户数据请求
  ///headers 用于保存请求头
  var headers = <String, String>{};

  Future<bool> _cancellationAccount() async {
    var apiUrl =
        Uri.parse("http://47.108.217.36:8086/admin/delete?username=$username");
    headers["token"] = token;
    headers["state"] = state;
    headers["username"] = username;
    var _response = await http.get(apiUrl, headers: headers);
    if (_response.body == "true") {
      return true;
    }
    return false;
  }

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

    _readShared().then((value) {
      animationController = AnimationController(
        vsync: this,
        duration:const Duration(seconds: 2),
      );
      animationController.forward();
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: 760,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Image/主页.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                _topControl(),
                const SizedBox(
                  height: 35,
                ),
                _gameButton(),
              ],
            )),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: DrawerHeader(
                child: drawerPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topControl() {
    return SizedBox(
      // color: Colors.red,
      width: 360,
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: 50,
            //color: Colors.grey,
            child: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.black, size: 35),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            width: 50,
            height: 50,
            //color: Colors.black54,
            child: ClipOval(
              child: Image.asset(
                link,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: 130,
            height: 35,
            //color: Colors.black54,
            margin: const EdgeInsets.only(left: 20),
            child: Text(
              username,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gameButton() {
    return SizedBox(
      height: 500,
      //color: Colors.green,
      child: Stack(
        children: [
          Stack(
            children: [
              Align(
                alignment: const Alignment(0.9, -1),
                child: SizedBox(
                  //color: Colors.red,
                  width: 98.99,
                  height: 98.99,
                  child: InkWell(
                    child: Stack(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            "assets/Image/气泡.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        ClipOval(
                          child: Image.asset(
                            "assets/Image/投放页面-瓶子.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        ClipOval(
                          child: Image.asset(
                            "assets/Image/漂流瓶（斜1）.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const MyBottles();
                      }));
                    },
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.9, -0.55),
                child: SizedBox(
                  //color: Colors.black,
                  height: 40,
                  width: 98.99,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/Image/我的瓶子字体.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.9, -0.303),
                child: SizedBox(
                  //color: Colors.red,
                  width: 98.99,
                  height: 98.99,
                  child: InkWell(
                    child: Stack(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            "assets/Image/气泡.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        ClipOval(
                          child: Image.asset(
                            "assets/Image/投放页面-瓶子(2).png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        isConTorThrow = !isConTorThrow;
                      });
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) {
                      //   return const ThrowBottle();
                      // }));
                      //
                    },
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.9, 0.05),
                child: SizedBox(
                  //color: Colors.blue,
                  height: 40,
                  width: 98.99,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/Image/扔一个字体.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.9, 0.35),
                child: SizedBox(
                  width: 98.99,
                  height: 98.99,
                  //color: Colors.grey,
                  child: InkWell(
                    child: Stack(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            "assets/Image/气泡.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        ClipOval(
                          child: Image.asset(
                            "assets/Image/渔网.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const GetScoop();
                      }));
                    },
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.9, 0.60),
                child: SizedBox(
                  //color: Colors.grey,
                  height: 40,
                  width: 98.99,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/Image/捞捞看字体.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.8, 0.8),
                child: SizedBox(
                  width: 46.88,
                  height: 46.88,
                  //color: Colors.black,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/Image/全瓶.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(-0.1, 0.9),
                child: SizedBox(
                  //color: Colors.grey,
                  width: 65,
                  height: 37,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/Image/半瓶.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(-0.6, 0.1),
                child: SizedBox(
                  //color: Colors.red,
                  width: 130,
                  height: 130,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/Image/铂爵旅拍-热气球.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              isConTorThrow ? _throwContainer() : nullContainer(),
              Align(
                alignment: const Alignment(0, 0.6),
                child: isConTorThrow ? returnButtom() : nullContainer(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget drawerPage() {
    return ListView(
      children: [
        SizedBox(
          height: 180,
          //color: Colors.red,
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(-0.8, 0),
                child: SizedBox(
                  height: 80,
                  width: 80,
                  //color: Colors.grey,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const Photo();
                      }));
                    },
                    child: ClipOval(
                      child: Image.asset(link),
                    ),
                  ),
                  /*child: ClipOval(
                     child: Image.asset(""),
                   ),*/
                ),
              ),
              Align(
                child: Text(
                  username,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.5, 0),
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: ClipOval(
                    child: Image.asset(sex == "男"
                        ? "assets/Image/男性..png"
                        : "assets/Image/女性..png"),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        ListTile(
          title: const Text("编辑资料"),
          leading: const Icon(Icons.create_outlined),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const EditData();
            })); //跳转至编辑页面
          },
        ),
        ListTile(
          title: const Text("意见反馈"),
          leading: const Icon(Icons.mail_outline),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const SuggestionPage();
            }));
          },
        ),
        ListTile(
          title: const Text("注销账户"),
          leading: const Icon(Icons.cancel),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("你确定要注销账户吗？"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("取消")),
                      TextButton(
                          onPressed: () {
                            _cancellationAccount().then((value) {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const LoginPage();
                              }));
                            });
                          },
                          child: const Text("确定")),
                    ],
                  );
                });
          },
        ),
        ListTile(
          title: const Text("退出登录"),
          leading: const Icon(Icons.power_settings_new_outlined),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("你要退出登录吗"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("取消")),
                      TextButton(
                          onPressed: () {
                            //SystemNavigator.pop();
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const LoginPage();
                            }));
                          },
                          child: const Text("确定")),
                    ],
                  );
                });
          },
        ),
      ],
    );
  }

  Widget _throwContainer() {
    return Center(
      child: ScaleTransition(
        scale:Tween(begin: 1.0,end:isConTorThrow?0.0:1.0).animate(animationController),
          child: Container(
            width: 280,
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 180,
                    width: 280,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                animationController.forward();
                                isConTorThrow = !isConTorThrow;
                              });
                            },
                            child: const Icon(
                              Icons.cancel,
                              size: 25,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(1),
                          width: 280,
                          height: 130,
                          //color: Colors.red,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              return TextField(
                                maxLength: 800,
                                controller: controller,
                                maxLines: 12,
                                textAlign: TextAlign.start,
                                decoration: const InputDecoration(
                                  hintText: "请输入你想写的内容",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onChanged: (content) {
                                  _bottleContent = content;
                                  if (content.isNotEmpty) {
                                    haveContent = true;
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(dateTime.toString().substring(0, 19)),
                )
              ],
            ),
          ),

      ),
    );
  }

  Widget returnButtom() {
    return ScaleTransition(
      scale: Tween(begin: 1.0,end:isConTorThrow?0.0:1.0).animate(animationController),
        child: Container(
            width: 200 ,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              child: const Center(
                  child: Text(
                "扔进海里",
                style: TextStyle(color: Colors.black45, fontSize: 18 ),
              )),
              onTap: () {
                if (haveContent) {
                  _postBottle().then((value) {
                    setState(() {
                      animationController.forward();
                      isConTorThrow = !isConTorThrow;
                      controller.clear();
                    });
                  });
                } else {
                  Fluttertoast.showToast(
                    textColor: Colors.red,
                    msg: "请输入内容！",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.white,
                    fontSize: 12,
                  );
                }
              },
            ),
    ),
    );
  }

  Widget nullContainer() {
    return Container();
  }
  // Widget seaWave(){
  //   // return TweenAnimationBuilder(tween: Tween(), duration: Duration(, builder: builder)
  //   );
  // }
}
