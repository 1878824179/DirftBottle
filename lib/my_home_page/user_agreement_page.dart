import 'package:flutter/material.dart';

class UserAgreement extends StatelessWidget {
  const UserAgreement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "用户协议",
          style: TextStyle(color: Colors.black54, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: const Text(
        "用户协议",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
