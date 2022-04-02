import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "隐私政策",
          style: TextStyle(color: Colors.black54, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: const Text(
        "隐私政策",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
