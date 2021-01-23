import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryDetail extends StatefulWidget {
  final String detail;

  HistoryDetail({Key key, @required this.detail}) : super(key: key);
  @override
  _HistoryDetail createState() => _HistoryDetail();
}

class _HistoryDetail extends State<HistoryDetail> {
  @override
  String text="";
  void initState() {
    text=widget.detail.replaceAll("}, {","}\n\n\n{");
    text=text.replaceAll("[","");
    text=text.replaceAll("]","");
    text=text.replaceAll("{","");
    text=text.replaceAll("}","");
    text=text.replaceAll("title","name");
    text="\n"+text;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Detail Order",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
    ),
      body: Text(
        text,
        style: TextStyle(
        fontSize: 15
        ),
      ),
    );
  }
}