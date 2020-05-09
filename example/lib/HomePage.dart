
import 'package:flutter/material.dart';
import 'package:zefyr_quill/EditorPage.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: EditorPage()),
    );
  }
}

