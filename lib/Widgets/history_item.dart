import 'package:flutter/material.dart';
import 'package:hismart/history_detail.dart';
import 'package:hismart/profilescreen.dart';

class HistoryPdt extends StatelessWidget {
  final String id;
  final String HistoryId;
  final String time;
  final int total;
  final String detail;

  HistoryPdt(this.id, this.HistoryId, this.time, this.total, this.detail);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      child: Card(
        child: ListTile(
          onTap: (){
            print(detail);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryDetail(detail: detail)),
            );
          },
          leading: CircleAvatar(
            child: FittedBox(child: Text('$id')),
          ),
          title: Text('Order : '+id+' - '+time),
          subtitle: Text('Total: $total'+'k'),
          trailing: Text('Đã hoàn thành'),
        ),
      ),
    );
  }
}

