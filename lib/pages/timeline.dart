import 'package:flutter/material.dart';
import 'package:instalite/widgets/header.dart';

class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context,isTitle: true),
      body: Text("timeline"),
    );
  }
}
