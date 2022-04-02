import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/my_bottle_model.dart';
import 'check_my_received_bottle_page.dart';
import 'check_my_throw_bottle_information_page.dart';
import 'my_home_page.dart';

class MyBottles extends StatefulWidget {
  const MyBottles({Key? key}) : super(key: key);

  @override
  _MyBottlesState createState() => _MyBottlesState();
}

class _MyBottlesState extends State<MyBottles>
    with SingleTickerProviderStateMixin {
  String token = " ";
  String state = " ";
  String username = " ";
  late TabController tabController = TabController(length: 2, vsync: this);

  Future _readShared() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString('username')!;
    state = preferences.getString('state')!;
    token = preferences.getString('token')!;
  }

  var throwHeaders = <String, String>{};
  var getHeaders = <String, String>{};

  List<MyBottle>? myReceivedBottles = [];
  List<MyBottle>? myThrowBottles = [];

  Future<void> _getBottle() async {
    var apiUrl = Uri.parse(
        "http://47.108.217.36:8086/admin/selectOther?username=$username");
    getHeaders["token"] = token;
    getHeaders["state"] = state;
    getHeaders["username"] = username;
    var _response = await get(apiUrl, headers: getHeaders);
    if (_response.body.isNotEmpty) {
      var data = json.decode(utf8.decode(_response.bodyBytes));
      for (var i in data) {
        MyBottle oneBottle = MyBottle.fromJson(i);
        oneBottle.link = "assets/Image/" + oneBottle.link!;
        //oneBottle.time = oneBottle.time!.replaceFirst("T", " ");
        oneBottle.time = oneBottle.time!.substring(0,10);
        myReceivedBottles!.add(oneBottle);
      }
      //print(throwBottle);
      // print(myReceivedBottles[0].information.toString());
    }
  }

  Future<void> _myThrowBottle() async {
    var apiUrl = Uri.parse(
        "http://47.108.217.36:8086/admin/selectAll?username=$username");
    throwHeaders["token"] = token;
    throwHeaders["state"] = state;
    throwHeaders["username"] = username;
    var _response = await get(apiUrl, headers: throwHeaders);
    if (_response.body.isNotEmpty) {
      var data = json.decode(utf8.decode(_response.bodyBytes));
      for (var i in data) {
        MyBottle oneBottle = MyBottle.fromJson(i);
        oneBottle.link = "assets/Image/" + oneBottle.link!;
        //oneBottle.time = oneBottle.time!.replaceFirst("T", " ");
        oneBottle.time = oneBottle.time!.substring(0,10);
        myThrowBottles!.add(oneBottle);
      }
    }
  }

  @override
  void initState() {
    _readShared().then((value) async {
      await _myThrowBottle().then((value) {
        setState(() {});
      });
      await _getBottle().then((value) {
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  InkWell(
          child: const Icon(Icons.arrow_back_ios,color: Colors.white,size: 25,
          ),
          onTap: (){
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyHome()),
                  (route) => false,
            );
          },
        ),
        title: const Text(
          "我的瓶子",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          unselectedLabelColor:Colors.white,
          // labelColor:Colors.re,
          controller: tabController,
          isScrollable: true,
          tabs: const <Widget>[
            Tab(
              text: "我收到的",
            ),
            Tab(
              text: "我扔出的",
            ),
          ],
        ),
      ),
      body: _bottleListView(),
    );
  }

  Widget _bottleListView() {
    return TabBarView(controller: tabController, children: [
      myReceivedBottles!.isEmpty
          ? _nullBottleListView()
          : _receivedBottleListView(),
      myThrowBottles!.isEmpty ? _nullBottleListView() : _throwBottleListView(),
    ]);
  }

  Widget _nullBottleListView() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 80, left: 108, right: 108),
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
          margin: const EdgeInsets.only(top: 210, left: 25, right: 25),
          height: 80,
          width: 500,
          //color: Colors.blue,
          child: const Center(
            child: Text(
              "啊哦，一个漂流瓶也没有呢，快去扔一个吧！！",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _receivedBottleListView() {
    return ListView.builder(
      itemCount: myReceivedBottles?.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            child: Container(
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(2),
          ),
          child: ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                    myReceivedBottles![index].link.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            title: Text(myReceivedBottles![index].username.toString()),
            subtitle: Text(myReceivedBottles![index].information.toString(),
                overflow: TextOverflow.ellipsis),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                {
                  return ReceiveBottle(
                    username: myReceivedBottles![index].username,
                    id: myReceivedBottles![index].id,
                    information: myReceivedBottles![index].information,
                    time: myReceivedBottles![index].time.toString(),
                    link: myReceivedBottles![index].link.toString(),
                  );
                }
              }));
            },
          ),
        ));
      },
    );
  }

  ///显示出我收到的瓶子
  Widget _throwBottleListView() {
    return ListView.builder(
      itemCount: myThrowBottles?.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(2),
          ),
          child: InkWell(
            child: ListTile(
              title: Text(myThrowBottles![index].time.toString()),
              subtitle: Text(myThrowBottles![index].information.toString(),
                  overflow: TextOverflow.ellipsis),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  {
                    return ContentPage(
                      username: myThrowBottles![index].username,
                      id: myThrowBottles![index].id,
                      information: myThrowBottles![index].information,
                      time: myThrowBottles![index].time.toString(),
                      link: myThrowBottles![index].link,
                    );
                  }
                }));
              },
            ),
          ),
        );
      },
    );
  }
}
