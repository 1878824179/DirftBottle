// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutterapp/config/app_colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'tile.dart';
// import 'grid.dart';
// import 'game.dart';
// import 'dart:async';
// import 'package:http/http.dart' as http;
//
// class HomePage extends StatefulWidget {
//   Map userData;
//   int level;
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _HomePageState();
//   }
//
//   HomePage({Key key, @required this.userData, @required this.level})
//       : super(key: key);
// }
//
// class _HomePageState extends State<HomePage> {
//   List<List<int>> grid = [];
//   List<List<int>> gridNew = [];
//   // SharedPreferences sharedPreferences;
//   int score = 0;
//   bool isgameOver = false;
//   bool isgameList = false;
//   int maxScore = 0;
//   int level = 0;
//   double cross = 0;
//   Map _rankListInfo = {};
//   Map _responseMap = {};
//
//   List<Widget> getGrid(double width, double height, int level) {
//     List<Widget> grids = [];
//     for (int i = 0; i < level; i++) {
//       for (int j = 0; j < level; j++) {
//         int num = grid[i][j];
//         String number;
//         int color;
//         switch (num) {
//           case 0:
//             color = AppColors.emptyGridBackground;
//             number = "";
//             break;
//           case 2:
//             color = AppColors.gridTwo;
//             number = "${num}";
//             break;
//           case 4:
//             color = AppColors.gridFour;
//             number = "${num}";
//             break;
//           case 8:
//             color = AppColors.gridEight;
//             number = "${num}";
//             break;
//           case 16:
//             color = AppColors.gridOneSix;
//             number = "${num}";
//             break;
//           case 32:
//             color = AppColors.gridThreeTwo;
//             number = "${num}";
//             break;
//           case 64:
//             color = AppColors.gridSixFour;
//             number = "${num}";
//             break;
//           case 128:
//             color = AppColors.gridOneTwoEight;
//             number = "${num}";
//             break;
//           case 256:
//             color = AppColors.gridTwoFiveSix;
//             number = "${num}";
//             break;
//           case 512:
//             color = AppColors.gridFiveOneTwo;
//             number = "${num}";
//             break;
//           case 1024:
//             color = AppColors.gridOneZeroTwoFour;
//             number = "${num}";
//             break;
//           case 2048:
//             color = AppColors.gridTwoZeroFourEight;
//             number = "${num}";
//             break;
//           case 4096:
//             color = AppColors.gridFourZeroNineSix;
//             number = "${num}";
//             break;
//           default:
//             color = AppColors.gridFourZeroNineSix;
//             number = "${num}";
//             break;
//         }
//         double size;
//         String n = "${number}";
//         switch (n.length) {
//           case 1:
//           case 2:
//             size = 40.0 - (level - 4) * 10;
//             break;
//           case 3:
//             size = 30.0 - (level - 4) * 10;
//             break;
//           case 4:
//             size = 20.0 - (level - 4) * 10;
//             break;
//         }
//         grids.add(Tile(number, width, height, color, size));
//       }
//     }
//     return grids;
//   }
//
//   void handleGesture(int direction) {
//     /*
//
//       0 = up
//       1 = down
//       2 = left
//       3 = right
//
//     */
//     bool flipped = false;
//     bool played = true;
//     bool rotated = false;
//     if (direction == 0) {
//       setState(() {
//         grid = transposeGrid(grid, level);
//         grid = flipGrid(grid, level);
//         rotated = true;
//         flipped = true;
//       });
//     } else if (direction == 1) {
//       setState(() {
//         grid = transposeGrid(grid, level);
//         rotated = true;
//       });
//     } else if (direction == 2) {
//     } else if (direction == 3) {
//       setState(() {
//         grid = flipGrid(grid, level);
//         flipped = true;
//       });
//     } else {
//       played = false;
//     }
//
//     if (played) {
//       print('playing');
//       List<List<int>> past = copyGrid(grid, level);
//       print('past ${past}');
//       for (int i = 0; i < level; i++) {
//         setState(() {
//           List result = operate(grid[i], score, _responseMap['data']['score'],
//               widget.userData, level);
//           score = result[0];
//           print('score in set state ${score}');
//           grid[i] = result[1];
//         });
//       }
//       setState(() {
//         grid = addNumber(grid, gridNew, level);
//       });
//       bool changed = compare(past, grid, level);
//       print('changed ${changed}');
//       if (flipped) {
//         setState(() {
//           grid = flipGrid(grid, level);
//         });
//       }
//
//       if (rotated) {
//         setState(() {
//           grid = transposeGrid(grid, level);
//         });
//       }
//
//       if (changed) {
//         setState(() {
//           grid = addNumber(grid, gridNew, level);
//           print('is changed');
//         });
//       } else {
//         print('not changed');
//       }
//
//       bool gameover = isGameOver(grid, level);
//       if (gameover) {
//         print('game over');
//         setState(() {
//           isgameOver = true;
//         });
//       }
//
//       print(grid);
//       print(score);
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     level = widget.level + 3;
//     switch (level) {
//       case 4:
//         cross = 10.0;
//         break;
//       case 5:
//         cross = 8.0;
//         break;
//       case 6:
//         cross = 6.0;
//         break;
//     }
//     grid = blankGrid(level);
//     gridNew = blankGrid(level);
//     addNumber(grid, gridNew, level);
//     addNumber(grid, gridNew, level);
//     _getRankList();
//     super.initState();
//   }
//
//   Future<String> getHighScore() async {
//     // sharedPreferences = await SharedPreferences.getInstance();
//     // int score = sharedPreferences.getInt('high_score');
//     var apiUrl = Uri.parse(
//         'http://120.77.233.123:8888/score/${widget.userData['userId']}/${widget.level}');
//     // 发起请求
//     var response = await http.get(apiUrl);
//     print('Response status: ${response.statusCode}');
//     // json转换为map类型
//     _responseMap = json.decode(utf8.decode(response.bodyBytes));
//     print('Response body: ${_responseMap}');
//     int score = _responseMap['data']['score'];
//     if (score == null) {
//       score = 0;
//     }
//     return score.toString();
//   }
//
//   // 排行榜
//   _getRankList() async {
//     var apiUrl = Uri.parse(
//         'http://120.77.233.123:8888/score/user?level=${widget.level}');
//     // 发起请求
//     var response = await http.get(
//       apiUrl,
//       headers: {'Authorization': '${widget.userData['token']}'},
//     );
//     print('Response status: ${response.statusCode}');
//     // json转换为map类型
//     _rankListInfo = json.decode(utf8.decode(response.bodyBytes));
//     print('Response body: ${_rankListInfo}');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     double width = MediaQuery.of(context).size.width;
//     double gridWidth = (width - 80) / 4;
//     double gridHeight = gridWidth;
//     double height = 30 + (gridHeight * 4) + 10;
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           '2048',
//           style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: AppColors.gridBackground,
//         // toolbarOpacity: 0.1,
//       ),
//       body: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('images/背景-游戏进行.png'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Stack(
//             children: [
//               Transform.translate(
//                 offset: Offset(0, 20),
//                 child: Container(
//                   padding: EdgeInsets.all(20.0),
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         margin: EdgeInsets.only(bottom: 10, left: 10),
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               child: Container(
//                                 height: 40,
//                                 width: 40,
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                     image: AssetImage('images/logo.png'),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               child: Container(
//                                 width: 100,
//                                 height: 35.0,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(30),
//                                   color: AppColors.lightyellow,
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     '${level}  X  ${level}',
//                                     style: TextStyle(
//                                       color: AppColors.white,
//                                       fontSize: 16.5,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               child: Container(
//                                 height: 40,
//                                 width: 40,
//                                 margin: EdgeInsets.only(left: width - 250),
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                     image: AssetImage('images/排行榜.png'),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 child: FlatButton(
//                                   child: null,
//                                   onPressed: () {
//                                     setState(() {
//                                       isgameList = !isgameList;
//                                       _getRankList();
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         color: AppColors.hinttext,
//                         margin: EdgeInsets.only(bottom: 25),
//                         padding: EdgeInsets.only(bottom: 10, top: 10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: <Widget>[
//                             Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(2.5),
//                                 color: AppColors.white,
//                               ),
//                               child: Container(
//                                 height: 70,
//                                 width:
//                                     (MediaQuery.of(context).size.width - 200) /
//                                         2,
//                                 padding: EdgeInsets.only(top: 13),
//                                 child: Column(
//                                   children: <Widget>[
//                                     Container(
//                                       margin: EdgeInsets.only(bottom: 5),
//                                       child: Text(
//                                         '最高分',
//                                         style: TextStyle(
//                                             color: AppColors.textbrown,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     FutureBuilder<String>(
//                                       future: getHighScore(),
//                                       builder: (ctx, snapshot) {
//                                         if (snapshot.hasData) {
//                                           return Text(
//                                             snapshot.data,
//                                             style: TextStyle(
//                                                 color: AppColors.textbrown,
//                                                 fontWeight: FontWeight.bold),
//                                           );
//                                         } else {
//                                           return Text(
//                                             '0',
//                                             style: TextStyle(
//                                                 color: AppColors.textbrown,
//                                                 fontWeight: FontWeight.bold),
//                                           );
//                                         }
//                                       },
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               child: Container(
//                                 width: 130.0,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(2.5),
//                                   color: AppColors.white,
//                                 ),
//                                 height: 70.0,
//                                 padding: EdgeInsets.only(top: 12),
//                                 child: Column(
//                                   children: <Widget>[
//                                     Container(
//                                       child: Text(
//                                         '得  分',
//                                         style: TextStyle(
//                                             fontSize: 15.0,
//                                             color: AppColors.textbrown,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     Container(
//                                       child: Text(
//                                         '${score}',
//                                         style: TextStyle(
//                                             fontSize: 20.0,
//                                             color: AppColors.textbrown,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(2.5),
//                                 color: AppColors.white,
//                               ),
//                               child: Container(
//                                 height: 70,
//                                 width:
//                                     (MediaQuery.of(context).size.width - 240) /
//                                         2,
//                                 padding: EdgeInsets.all(10.0),
//                                 alignment: Alignment.center,
//                                 child: IconButton(
//                                   iconSize: 35.0,
//                                   icon: Icon(
//                                     Icons.refresh,
//                                     color: AppColors.textbrown,
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       grid = blankGrid(level);
//                                       gridNew = blankGrid(level);
//                                       grid = addNumber(grid, gridNew, level);
//                                       grid = addNumber(grid, gridNew, level);
//                                       score = 0;
//                                       isgameOver = false;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         height: height,
//                         child: Stack(
//                           children: <Widget>[
//                             Padding(
//                               padding: EdgeInsets.all(10.0),
//                               child: GestureDetector(
//                                 child: GridView.count(
//                                   primary: false,
//                                   crossAxisSpacing: cross,
//                                   mainAxisSpacing: cross,
//                                   crossAxisCount: level,
//                                   children:
//                                       getGrid(gridWidth, gridHeight, level),
//                                 ),
//                                 onVerticalDragEnd: (DragEndDetails details) {
//                                   //primaryVelocity -ve up +ve down
//                                   if (details.primaryVelocity < 0) {
//                                     handleGesture(0);
//                                   } else if (details.primaryVelocity > 0) {
//                                     handleGesture(1);
//                                   }
//                                 },
//                                 onHorizontalDragEnd: (details) {
//                                   //-ve right, +ve left
//                                   if (details.primaryVelocity > 0) {
//                                     handleGesture(2);
//                                   } else if (details.primaryVelocity < 0) {
//                                     handleGesture(3);
//                                   }
//                                 },
//                               ),
//                             ),
//                             isgameOver
//                                 ? Container(
//                                     height: height,
//                                     color: AppColors.transparentWhite,
//                                     child: Center(
//                                       child: Text(
//                                         'Game over!',
//                                         style: TextStyle(
//                                             fontSize: 30.0,
//                                             fontWeight: FontWeight.bold,
//                                             color: AppColors.gridBackground),
//                                       ),
//                                     ),
//                                   )
//                                 : SizedBox(),
//                           ],
//                         ),
//                         color: AppColors.gridBackground,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               isgameList
//                   ? _rankList(MediaQuery.of(context).size.height,
//                       MediaQuery.of(context).size.width)
//                   : SizedBox(),
//             ],
//           )),
//     );
//   }
//
// // 排行榜
//   Widget _rankList(var height, var width) {
//     return Container(
//         child: Stack(
//       children: [
//         Container(
//           height: height,
//           width: width,
//           color: Color(0xff3f000000),
//         ),
//         // 主体
//         Center(
//           child: Container(
//             height: 600,
//             width: width - 60,
//             margin: EdgeInsets.only(top: 10),
//             decoration: BoxDecoration(
//               //边框
//               border: Border.all(color: AppColors.textbrown, width: 2.5),
//               //颜色填充
//               color: AppColors.lightwhite,
//               //圆角
//               borderRadius: BorderRadius.circular((6.0)),
//             ),
//             child: Column(
//               children: [
//                 _listTitle(),
//                 _currentScore(),
//                 _infoList(),
//                 _closeButton(),
//               ],
//             ),
//           ),
//         ),
//         Transform.translate(
//           offset: Offset(width / 2 - 105, 30),
//           child: Container(
//             height: 50,
//             width: 200,
//             child: Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('images/logo.png'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: 150,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('images/排行榜logo.png'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//       ],
//     ));
//   }
//
//   // 标题
//   Widget _listTitle() {
//     return Container(
//       margin: EdgeInsets.fromLTRB(5, 25, 5, 0),
//       padding: EdgeInsets.all(5.0),
//       height: 45,
//       child: Row(
//         children: [
//           Container(
//             width: 70,
//             padding: EdgeInsets.all(5.0),
//             alignment: Alignment.centerLeft,
//             child: Text(
//               '排  名',
//               style: TextStyle(
//                 fontSize: 15.5,
//                 color: AppColors.textbrown,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//           Container(
//             width: 145,
//             padding: EdgeInsets.all(5.0),
//             alignment: Alignment.centerLeft,
//             child: Text(
//               '用 户 名',
//               style: TextStyle(
//                 fontSize: 15.5,
//                 color: AppColors.textbrown,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width - 300,
//             padding: EdgeInsets.all(5.0),
//             alignment: Alignment.center,
//             child: Text(
//               '得 分',
//               style: TextStyle(
//                 fontSize: 15.5,
//                 color: AppColors.textbrown,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 个人成绩
//   Widget _currentScore() {
//     return Container(
//       margin: EdgeInsets.only(left: 5.0, right: 5.0),
//       padding: EdgeInsets.all(5.0),
//       height: 45,
//       child: Row(
//         children: [
//           Container(
//             width: 70,
//             padding: _responseMap['data']['rank'] != null
//                 ? EdgeInsets.fromLTRB(10, 5, 5, 5)
//                 : EdgeInsets.fromLTRB(5, 5, 5, 5),
//             alignment: Alignment.centerLeft,
//             child: Text(
//               _responseMap['data']['rank'] != null
//                   ? '${_responseMap['data']['rank']}'
//                   : '未上榜',
//               style: TextStyle(
//                 fontSize: 15,
//                 color: AppColors.textbrown,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//           Container(
//             width: 145,
//             padding: EdgeInsets.all(5.0),
//             alignment: Alignment.centerLeft,
//             child: Text(
//               '${widget.userData['username']}',
//               style: TextStyle(
//                 fontSize: 15,
//                 color: AppColors.textbrown,
//               ),
//             ),
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width - 300,
//             padding: EdgeInsets.all(5.0),
//             alignment: Alignment.center,
//             child: Text(
//               _responseMap['data']['score'] != null
//                   ? '${_responseMap['data']['score']}'
//                   : '0',
//               style: TextStyle(
//                 fontSize: 15,
//                 color: AppColors.textbrown,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 排行榜信息
//   Widget _infoList() {
//     List<Widget> _list = List();
//     _list.clear();
//
//     if (_rankListInfo['success'] == false) {
//       return Container(
//         height: 420,
//       );
//     }
//
//     int len = _rankListInfo['data'].length;
//     for (int i = 1; i <= 20; i++) {
//       switch (i) {
//         case 1:
//           _list.add(
//             Container(
//               margin: EdgeInsets.only(left: 5.0, right: 5.0),
//               padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
//               height: 30,
//               child: Row(
//                 children: [
//                   Container(
//                     width: 70,
//                     padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
//                     alignment: Alignment.centerLeft,
//                     child: Image.asset("images/第一名.png"),
//                   ),
//                   Container(
//                     width: 145,
//                     padding: EdgeInsets.all(5.0),
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       i <= len
//                           ? '${_rankListInfo['data'][i - 1]['name']}'
//                           : '未上榜',
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: AppColors.textbrown,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width - 300,
//                     padding: EdgeInsets.all(5.0),
//                     alignment: Alignment.center,
//                     child: Text(
//                       i <= len
//                           ? '${_rankListInfo['data'][i - 1]['score']}'
//                           : '',
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: AppColors.textbrown,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//           break;
//         case 2:
//           _list.add(
//             Container(
//               margin: EdgeInsets.only(left: 5.0, right: 5.0),
//               padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
//               height: 30,
//               child: Row(
//                 children: [
//                   Container(
//                     width: 70,
//                     padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
//                     alignment: Alignment.centerLeft,
//                     child: Image.asset("images/第二名.png"),
//                   ),
//                   Container(
//                     width: 145,
//                     padding: EdgeInsets.all(5.0),
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       i <= len
//                           ? '${_rankListInfo['data'][i - 1]['name']}'
//                           : '未上榜',
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: AppColors.textbrown,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width - 300,
//                     padding: EdgeInsets.all(5.0),
//                     alignment: Alignment.center,
//                     child: Text(
//                       i <= len
//                           ? '${_rankListInfo['data'][i - 1]['score']}'
//                           : '',
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: AppColors.textbrown,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//           break;
//         case 3:
//           _list.add(
//             Container(
//               margin: EdgeInsets.only(left: 5.0, right: 5.0),
//               padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
//               height: 30,
//               child: Row(
//                 children: [
//                   Container(
//                     width: 70,
//                     padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
//                     alignment: Alignment.centerLeft,
//                     child: Image.asset("images/第三名.png"),
//                   ),
//                   Container(
//                     width: 145,
//                     padding: EdgeInsets.all(5.0),
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       i <= len
//                           ? '${_rankListInfo['data'][i - 1]['name']}'
//                           : '未上榜',
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: AppColors.textbrown,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width - 300,
//                     padding: EdgeInsets.all(5.0),
//                     alignment: Alignment.center,
//                     child: Text(
//                       i <= len
//                           ? '${_rankListInfo['data'][i - 1]['score']}'
//                           : '',
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: AppColors.textbrown,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//           break;
//         default:
//           _list.add(
//             Container(
//               margin: EdgeInsets.only(left: 5.0, right: 5.0),
//               padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
//               height: 30,
//               child: Row(
//                 children: [
//                   Container(
//                     width: 70,
//                     padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       '${i}',
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: AppColors.textbrown,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: 145,
//                     padding: EdgeInsets.all(5.0),
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       i <= len
//                           ? '${_rankListInfo['data'][i - 1]['name']}'
//                           : '未上榜',
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: AppColors.textbrown,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width - 300,
//                     padding: EdgeInsets.all(5.0),
//                     alignment: Alignment.center,
//                     child: Text(
//                       i <= len
//                           ? '${_rankListInfo['data'][i - 1]['score']}'
//                           : '',
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: AppColors.textbrown,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//           break;
//       }
//     }
//     return Container(
//       margin: EdgeInsets.only(bottom: 10),
//       height: 420,
//       child: ListView(
//         children: _list,
//       ),
//     );
//   }
//
//   // 返回按钮
//   Widget _closeButton() {
//     return Container(
//       margin: EdgeInsets.only(left: 5.0, right: 5.0),
//       padding: EdgeInsets.all(5.0),
//       height: 40,
//       width: 150,
//       decoration: BoxDecoration(
//         color: AppColors.textbrown,
//         // border: Border.all(color: AppColors.textbrown,width: 1.5),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: OutlinedButton(
//         onPressed: () {
//           setState(() {
//             isgameList = !isgameList;
//           });
//         },
//         child: Text(
//           "返  回",
//           style: TextStyle(color: (AppColors.white), fontSize: 13),
//         ),
//       ),
//     );
//   }
// }
