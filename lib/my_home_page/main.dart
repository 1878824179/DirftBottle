import 'package:flutter/material.dart';
import 'start_page.dart';
import 'loginPage.dart';

///启动页
void main() {
  runApp(const StartPage());
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final routes = {
    '/login': (context) => const LoginPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //启动页组件
      title: "启动页",
      home: const Loading(),
      theme: ThemeData(
        //主题色
        primaryColor: Colors.white,
        //中间的屏幕背景色
        // scaffoldBackgroundColor: Color(0xFFebebeb),
        cardColor: Colors.white,
      ),
      routes: <String, WidgetBuilder>{
        "/login": (context) => const LoginPage(),
      },
    );
  }
}
