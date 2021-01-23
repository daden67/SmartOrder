import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hismart/Widgets/history_item.dart';
import 'package:provider/provider.dart';
import 'Model/cart.dart';


class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreen createState() => new _HistoryScreen();
}
class _HistoryScreen extends State<HistoryScreen> {
  @override
  void initState() {
    FirebaseHistory.getProfileStream(update);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (ctx, i) => HistoryPdt(list[i].id.toString(), list[i].name,list[i].time,list[i].total,list[i].detail)),
          ),
        ],
      ),
    );
  }
  void update()
  {
    setState(() {
    });
  }
}
class History {
  int id;
  String name;
  String time;
  int total;
  String detail;

  History({
    @required this.id,
    this.name,
    this.time,
    this.total,
    this.detail
  });
}
List<History> list=[];

class FirebaseHistory {
  static Future<void> getProfileStream(void update()) async {
    String accountKey = FirebaseAuth.instance.currentUser.uid;
    list.clear();
    print(accountKey);
    var db = FirebaseDatabase.instance.reference().child("orders").orderByChild("id").equalTo(accountKey);
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if(values==null)
      {
        return;
      }
      int i=0;
      values.forEach((key, values) {
        i++;
        list.add(
          History(
            id: i,
            name: 'Order:$i',
            time: values["dateTime"],
            total: values["amount"],
            detail: values["products"].toString(),
          ),
        );
      }
      );
      update();
    }
    );
  }
}