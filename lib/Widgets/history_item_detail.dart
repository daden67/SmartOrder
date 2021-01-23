import 'package:flutter/material.dart';

class DetailPdt extends StatelessWidget {
  final String id;
  final int price;
  final int quantity;
  final String name;

  DetailPdt(this.id, this.price, this.quantity, this.name);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(child: Text('$price'+'k')),
          ),
          title: Text(name),
          subtitle: Text('Total: ${(price * quantity)}k'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}