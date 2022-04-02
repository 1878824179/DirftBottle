///捞捞看
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/get_a_bottle_model.dart';
import 'my_home_page.dart';

class GetScoop extends StatefulWidget {
  const GetScoop({Key? key}) : super(key: key);

  @override
  _GetScoopState createState() => _GetScoopState();
}

class _GetScoopState extends State<GetScoop> {
  int? _id = 12;
  String? information = " ";
  String? time = " ";
  String? _bottleMasterName = " ";
  String sex = " ";
  String username = " ";
  String state = " ";
  String token = " ";
  String link = " ";
  String reportReasons = " ";
  final TextEditingController writeControl = TextEditingController();
  List reason = [
    "低俗色情",
    "政治敏感",
    "垃圾广告",
    "不文明用语",
    "暴恐违法",
    "涉嫌欺诈",
    "其他职业",
  ];

  ///for循环遍历 传给children
  List<Widget> get listOfReason {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < reason.length; i++) {
      list.add(
        buildItem(reason[i], onTap: () {
          setState(() {
            reportReasons = reason[i];
          });
        }),
      );
    }
    return list.toList();
  }

  ///本地保存
  Future _readShared() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString('username')!;
    sex = preferences.getString("sex")!;
    state = preferences.getString('state')!;
    token = preferences.getString('token')!;
  }

  ///注销账户数据请求
  ///headers 用于保存请求头
  var getBottleHeaders = <String, String>{};
  var throwInTheSeaHeaders = <String, String>{};
  GetABottle? _getABottle;

  Future<bool> _getBottle() async {
    var apiUrl = Uri.parse(
        "http://47.108.217.36:8086/admin/selectone?username=$username");
    getBottleHeaders["token"] = token;
    getBottleHeaders["state"] = state;
    getBottleHeaders["username"] = username;
    var _response = await http.get(apiUrl, headers: getBottleHeaders);
    // GetABottle _getABottle;
    if (_response.body.isNotEmpty) {
      _getABottle =
          GetABottle.fromMap(jsonDecode(utf8.decode((_response.bodyBytes))));
      information = _getABottle!.information!;
      _id = _getABottle!.id!;
      time = _getABottle!.time!.toString();
      time = time!.replaceFirst("T", " ");
      _bottleMasterName = _getABottle!.username!;
      link = "assets/Image/" + _getABottle!.link.toString();
      return true;
    }
    return false;
  }

  Future<void> _throwInTheSea() async {
    var apiUrl = Uri.parse("http://47.108.217.36:8086/admin/throw?id=$_id");
    throwInTheSeaHeaders["token"] = token;
    throwInTheSeaHeaders["state"] = state;
    throwInTheSeaHeaders["username"] = username;
    await http.get(apiUrl, headers: throwInTheSeaHeaders);
  }

  @override
  void initState() {
    _readShared().then((value) async {
      await _getBottle().then((value) {
        setState(() {});
      });
    });
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
        body: _getABottle == null ? _nullBottle() : _top(),
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
        const SizedBox(
          height: 60,
        ),
        _theBody(),
        const SizedBox(
          height: 30,
        ),
        _theButton(),
      ],
    );
  }

  Widget _topControl() {
    return SizedBox(
      width: 360,
      height: 50,
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 50,
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
            child: Center(
              child: Text(
                "捞捞看",
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

  Widget _theBody() {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      width: 360,
      height: 400,
      // color: Colors.white,
      child: Column(
        children: [
          ///头像框以及举报按钮
          Container(
            width: 360,
            height: 60,
            //color: Colors.black,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              //border: Border.all(width: 1, color: Colors.black),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(80),
                    ),
                    width: 60,
                    height: 60,
                    //color: Colors.red,
                    child: Center(
                      child: Image.asset(
                        link,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                      height: 38,
                      width: 24,
                      //color: Colors.black,
                      child: InkWell(
                        child: Column(
                          children: [
                            InkWell(
                              child: const Icon(
                                Icons.warning,
                                color: Colors.red,
                              ),
                              onTap: () {
                                showBottomSheet();
                              },
                            ),
                            const Text(
                              "举报",
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),

          ///处理文字输入
          Container(
            margin: const EdgeInsets.only(top: 1),
            height: 260,
            width: 360,
            //color: Colors.red,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              color: Colors.white,
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Text(
                  "\t\t\t\t" + information!,
                  style: const TextStyle(
                    fontSize: 22,
                    height: 1.3,
                  ),
                );
              },
            ),
          ),
          Container(
            width: 360,
            height: 77,
            margin: const EdgeInsets.only(top: 1),
            decoration: const BoxDecoration(),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 180,
                    height: 32,
                    // color: Colors.red,
                    //margin: const EdgeInsets.only(top: 1),
                    child: Text(
                      "瓶子主人：" + _bottleMasterName!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 150,
                    height: 32,
                    //color: Colors.red,
                    margin: const EdgeInsets.only(top: 1),
                    child: Text(
                      time!,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _theButton() {
    return Row(
      children: [
        Container(
            margin: const EdgeInsets.only(left: 28, top: 18),
            alignment: const Alignment(0, 0),
            height: 50,
            width: 120,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: InkWell(
              child: const Center(
                child: Text(
                  '扔回海里',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              onTap: () {
                _throwInTheSea().then((value) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHome()),
                    (route) => false,
                  );
                });
              },
            )),
        Container(
            margin: const EdgeInsets.only(left: 72, top: 18),
            alignment: const Alignment(0, 0),
            height: 50,
            width: 120,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: InkWell(
              child: const Center(
                child: Text(
                  '关闭',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            )),
      ],
    );
  }

  Widget _nullBottle() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          "捞捞看",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
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
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 108, right: 108),
                        width: 150,
                        height: 150,
                        //color: Colors.grey,
                        child: ClipOval(
                          child: Image.asset(
                            "assets/Image/投放页面-瓶子(2).png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 210, left: 25, right: 25),
                        height: 80,
                        width: 500,
                        //color: Colors.blue,
                        child: const Center(
                          child: Text(
                            "啊哦，漂流瓶被捞空了，快去扔一个吧！",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showBottomSheet() {
    //用于在底部打开弹框的效果
    showModalBottomSheet(
        builder: (BuildContext context) {
          //构建弹框中的内容
          return buildBottomSheetWidget(context);
        },
        context: context);
  }

  Widget buildBottomSheetWidget(BuildContext context) {
    //弹框中内容  310 的调试
    return SizedBox(
      height: 300,
      child: ListView(
        children: [
          ...listOfReason,
          Container(
            color: Colors.grey[300],
            height: 8,
          ),
          //取消按钮
          //添加个点击事件
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: const Center(
                child: Text("取消"),
              ),
              height: 40,
              alignment: Alignment.center,
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem(String reportReasons, {required Function onTap}) {
    //添加点击事件
    return InkWell(
      //点击回调
      onTap: () {
        //关闭弹框
        Navigator.of(context).pop();
        //外部回调
        onTap();
      },
      child: SizedBox(
        height: 30,
        //左右排开的线性布局
        child: Row(
          //所有的子Widget 水平方向居中
          mainAxisAlignment: MainAxisAlignment.center,
          //所有的子Widget 竖直方向居中
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Image.asset(imagePath,width: 20,height: 20,),
            const SizedBox(
              width: 10,
            ),
            Text(reportReasons),
          ],
        ),
      ),
    );
  }
}
