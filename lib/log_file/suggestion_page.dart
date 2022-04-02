//意见反馈页面
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({Key? key}) : super(key: key);

  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  late var _function = " ";
  late var _performance = " ";
  late var _other = " ";
  late var _content = " ";
  late var connection = " ";
  late var username = " ";
  late var state = " ";
  late var token = " ";
  final TextEditingController functionController = TextEditingController();
  final TextEditingController connectionController = TextEditingController();
  final TextEditingController performanceController = TextEditingController();
  final TextEditingController otherController = TextEditingController();

  Future _readShared() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString('username')!;
    state = preferences.getString('state')!;
    token = preferences.getString('token')!;
  }

  var headers = <String, String>{};

  Future<bool> _postSuggestion() async {
    if (_function.isNotEmpty) {
      _content = _function;
    } else if (_other.isNotEmpty) {
      _content = _other;
    } else if (_performance.isNotEmpty) {
      _content = _performance;
    }
    var apiUrl = Uri.parse(
        "http://47.108.217.36:8086/admin/insertSuggestion?contact=$connection&content=$_content&username=$username");
    headers["token"] = token;
    headers["state"] = state;
    headers["username"] = username;
    var _response = await http.get(apiUrl, headers: headers);
    if (_response.body.isNotEmpty) {
      return true;
    } else {
      return false;
    }
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
    return DefaultTabController(
      length: 3, // tab个数
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          // Tab组件必须放到Scaffold中
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "意见反馈",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  text: "功能建议",
                ),
                Tab(
                  text: "性能建议",
                ),
                Tab(
                  text: "其他建议",
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              _suggestion(),
              _relation(),
              _connection(),
              _submitButton(),
            ],
          )),
    );
  }

  Widget _suggestion() {
    return Container(
      child: TabBarView(
        // 类似ViewPage
        children: <Widget>[
          SizedBox(
            height: 300,
            //color: Colors.black,
            child: TextField(
              maxLength: 500,
              maxLines: 12,
              controller: functionController,
              textAlign: TextAlign.start,
              decoration: const InputDecoration(
                hintText: "请输入你对漂流瓶的功能建议。",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              onChanged: (test) {
                _function = test;
              },
            ),
          ),
          SizedBox(
            height: 300,
            //color: Colors.black,
            child: TextField(
              maxLength: 500,
              maxLines: 12,
              controller: performanceController,
              textAlign: TextAlign.start,
              decoration: const InputDecoration(
                  hintText: "请输入你对漂流瓶的性能建议。",
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  )),
              onChanged: (test) {
                _performance = test;
              },
            ),
          ),
          SizedBox(
            height: 300,
            //color: Colors.black,
            child: TextField(
              maxLength: 500,
              maxLines: 12,
              controller: otherController,
              textAlign: TextAlign.start,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "请输入你对漂流瓶的其他建议。",
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  )),
              onChanged: (test) {
                _function = test;
              },
            ),
          ),
        ],
      ),
      //color: Colors.red,
      height: 280,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
      ),
    );
  }

  Widget _relation() {
    return Container(
        height: 50,
        color: Colors.black12,
        child: const Align(
          alignment: Alignment(-0.9, 0),
          child: Text(
            "联系方式",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ));
  }

  Widget _connection() {
    return SizedBox(
      height: 75,
      child: TextField(
        controller: connectionController,
        maxLength: 11,
        decoration: InputDecoration(
          hintText: "请输入您的联系方式。",
          hintStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.blue),
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        onChanged: (test) {
          _other = test;
        },
      ),
    );
  }

  Widget _submitButton() {
    return Container(
        margin: const EdgeInsets.only(left: 94.5, right: 94.5, top: 79.5),
        alignment: const Alignment(0, 0),
        height: 44.5,
        width: 360,
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          //border: new Border.all(width: 1,color: Colors.red),
        ),
        child: InkWell(
          child: const Center(
            child: Text('提交'),
          ),
          onTap: () {
            _postSuggestion().then((success) {
              if (success) {
                Navigator.of(context).pop();
                Fluttertoast.showToast(
                  textColor: Colors.red,
                  msg: "意见上传成功!",
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
