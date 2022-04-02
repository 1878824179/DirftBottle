///漂流瓶信息

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'my_bottle_page.dart';

class ContentPage extends StatefulWidget {
  final String? username;
  final int? id;
  final String? information;
  final String? time;
  final String? link;

  const ContentPage(
      {Key? key,
      required this.id,
      required this.time,
      required this.information,
      required this.username,
      required this.link})
      : super(key: key);

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  late String token;
  late String state;
  late String username = " ";

  Future _readShared() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString('username')!;
    state = preferences.getString('state')!;
    token = preferences.getString('token')!;
  }

  var headers = <String, String>{};

  Future _deleteBottle() async {
    var apiUrl =
        Uri.parse("http://47.108.217.36:8086/admin/deleteone?id=${widget.id}");

    headers["token"] = token;
    headers["state"] = state;
    headers["username"] = username;
    http.get(apiUrl, headers: headers);
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.username!,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          children: [
            _headPortrait(),
            _content(),
            //Divider(),
            _timeContainer(),
            _cancelBottle(),
          ],
        ),
      ),
    );
  }

  Widget _headPortrait() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(80),
      ),
      height: 75,
      width: 75,
      margin: const EdgeInsets.only(top: 60),
      child: Image.asset(
        widget.link!,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _content() {
    return Container(
      height: 300,
      width: 360,
      //color: Colors.black,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Text(
            "\t\t\t\t" + widget.information!,
            style: const TextStyle(
              fontSize: 23,
              height: 1.3,
              // decoration: TextDecoration.underline,
            ),
          );
        },
      ),
    );
  }

  // Widget _content1() {
  //   return Container(
  //     height: 300,
  //     width: 360,
  //     //color: Colors.black,
  //     decoration: BoxDecoration(
  //       border: Border.all(width: 1, color: Colors.black),
  //     ),
  //     child: Text(
  //       widget.information!,
  //       style: const TextStyle(
  //         fontSize: 20,
  //         height: 1.3,
  //         // decoration: TextDecoration.underline,
  //       ),
  //     ),
  //   );
  // }

  Widget _timeContainer() {
    return Container(
      //margin: EdgeInsets.only(top: 1),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
      ),
      width: 360,
      height: 50,
      child: Container(
        alignment: Alignment.topRight,
        height: 25,
        width: 100,
        child: Text(
          widget.time.toString(),
        ),
      ),
    );
  }

  Widget _cancelBottle() {
    return Container(
      margin: const EdgeInsets.only(top: 50, left: 320),
      width: 45,
      height: 45,
      //color: Colors.blue,
      child: InkWell(
        child: const Center(
          child: Icon(
            Icons.delete,
            size: 50,
            color: Colors.black,
          ),
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("你确定要删除吗？"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "取消",
                        style: TextStyle(),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          _deleteBottle().then((value) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyBottles()),
                              (route) => false,
                            );
                          });
                        },
                        child: const Text("确定")),
                  ],
                );
              });
        },
      ),
    );
  }
}
