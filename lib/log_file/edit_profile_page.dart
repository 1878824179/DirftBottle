import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'my_home_page.dart';

class EditData extends StatefulWidget {
  const EditData({Key? key}) : super(key: key);

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  List occupations = [
    "计算机/互联网/通信",
    "生产/工艺/制造",
    "医疗/护理/制药",
    "金融/银行/投资/保险",
    "商业/服务业/个体经营",
    "文化/广告/传媒",
    "娱乐/艺术/表演",
    "律师/法务",
    "教育/培训",
    "公务员/行政/事业单位",
    "模特",
    "空姐",
    "学生",
    "老师",
    "其他职业",
  ];
///for循环遍历 传给children
  List<Widget> get listOfProfessions {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < occupations.length; i++) {
      list.add(
        buildItem(occupations[i], onTap: () {
          setState(() {
            occupation = occupations[i];
          });
        }),
      );
    }
    return list.toList();
  }
  String? address = '';
  String? username = " ";
  String? sex = " ";
  String? state = " ";
  String? token = " ";
  String? password = " ";
  String? occupation = " ";

  Future _readShared() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString('username');
    state = preferences.getString('state');
    token = preferences.getString('token');
    sex = preferences.getString("sex");
    password = preferences.getString("password");
    address = preferences.getString("address");
    occupation = preferences.getString("occupation");
  }

  var headers = <String, String>{};

  Future _postData() async {
    var apiUrl = Uri.parse(
        "http://47.108.217.36:8086/admin/update_Person_Infor?address=$address&occupation=$occupation&username=$username");
    headers["token"] = token!;
    headers["state"] = state!;
    headers["username"] = username!;
    await http.get(apiUrl, headers: headers);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("occupation",occupation!);
    prefs.setString("address",address! );
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
      appBar: AppBar(
        leading: IconButton(onPressed: (){
              _comFirmChange();
        }, icon:const  Icon(Icons.arrow_back_ios,color: Colors.black,size: 20,)),
        title:const  Text("编辑资料"),
        centerTitle: true,
      ),
      body: _compile(),
    );
  }

  Widget _compile() {
    return ListView(
      children: [
        Container(
          margin:const  EdgeInsets.only(top: 90),
          //color: Colors.blue,
          height: 50,
          child: Row(
            children: [
              Container(
                  margin:const  EdgeInsets.only(left: 23),
                  height: 30,
                  width: 60,
                  //color: Colors.red,
                  child:const Center(
                    child: Text(
                      "昵称:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )),
              const SizedBox(
                width: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                //color: Colors.red,
                height: 30,
                width: 200,
                child: Text(
                  username!,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Container(
          margin: const EdgeInsets.only(top: 20),
          //color: Colors.blue,
          height: 50,
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 23),
                  height: 30,
                  width: 60,
                  //color: Colors.red,
                  child: const Center(
                    child: Text(
                      "性别:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )),
              const SizedBox(
                width: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                //color: Colors.red,
                height: 30,
                width: 200,
                child: Text(
                  sex!,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Container(
          margin: const EdgeInsets.only(top: 20),
          height: 50,
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 23),
                  height: 30,
                  width: 60,
                  child:const  Center(
                    child: Text(
                      "家乡:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
              ),
              Container(
                  margin:const  EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  //color: Colors.red,
                  height: 30,
                  width: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Text(
                        address!,
                        style:const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )),
              Container(
                  margin:const  EdgeInsets.only(right: 20),
                  child: InkWell(
                    child:const  Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      //   return MyApps();
                      // }));
                      Result? result = await CityPickers.showCityPicker(
                          context: context,
                          cancelWidget:const Text(
                            "取消",
                            style: TextStyle(color: Colors.black),
                          ),
                          confirmWidget:const Text(
                            "确定",
                            style: TextStyle(color: Colors.black),
                          ));
                      setState(() {
                        address =
                            "${result?.provinceName}/${result?.cityName}/${result?.areaName}";
                      });
                    },
                  )),
            ],
          ),
        ),
        const Divider(),
        Container(
          margin:const  EdgeInsets.only(top: 20),
          height: 50,
          child: Row(
            children: [
              Container(
                  margin:const EdgeInsets.only(left: 23),
                  height: 30,
                  width: 60,
                  child:const Center(
                    child: Text(
                      "职业:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )),
              Container(
                margin:const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                //color: Colors.red,
                height: 30,
                width: 200,
                child: Text(
                  occupation!,
                  style:const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin:const EdgeInsets.only(right: 20),
                child: InkWell(
                  child:const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showBottomSheet();
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
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
          ...listOfProfessions,
          Container(color: Colors.grey[300],height: 8,),
          //取消按钮
          //添加个点击事件
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child:const Center(
                child: Text("取消"),
              ),
              height: 40,
              alignment: Alignment.center,
            ),)
        ],
      ),
    );
  }

  Widget buildItem(String occupation, {required Function onTap}) {
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
            Text(occupation),
          ],
        ),
      ),
    );
  }
  Future _comFirmChange() {
    return  showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("是否保存信息？"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MyHome()),
                          (route) => false,
                    );
                  },
                  child: const Text("取消")),
              TextButton(
                  onPressed: () {
                    _postData().then((value){
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MyHome()),
                            (route) => false,
                      );
                    });
                  },
                  child: const Text("确定")),
            ],
          );
        });
  }
}
