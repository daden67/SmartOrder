import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hismart/profilescreen.dart';
import 'package:hismart/vouchercodescreen.dart';
import 'package:provider/provider.dart';
import 'Model/cart.dart';
import 'historyscreen.dart';
import 'widgets/cart_item.dart';
import 'Model/orders.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CartScreen extends StatelessWidget {
  //static const routeName = '/cart';
  static int value = 0;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) => CartPdt(
                    cart.items.values.toList()[i].id,
                    cart.items.keys.toList()[i],
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity,
                    cart.items.values.toList()[i].name)),
          ),
        ],
      ),
        bottomNavigationBar: CheckoutCart(cart: cart, value: value),
    );
  }
}
class CheckoutButton extends StatefulWidget {
  final Cart cart;

  const CheckoutButton({@required this.cart});
  @override
  _CheckoutButtonState createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Checkout'),
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () async {
        await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cart.items.values.toList(), widget.cart.totalAmount);
        widget.cart.clear();
      },
    );
  }
}


class CheckoutCart extends StatefulWidget {
  final Cart cart;
  final int value;

  const CheckoutCart({@required this.cart, @required this.value});
  @override
  _CheckoutCart createState() => _CheckoutCart();
}

class _CheckoutCart extends State<CheckoutCart>
{
  bool Checkinfo()
  {
    String accountKey = FirebaseAuth.instance.currentUser.uid;
    print(accountKey);
    var db = FirebaseDatabase.instance.reference().child("accounts").orderByChild(
        "UID").equalTo(accountKey);
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if(values==null)
        {
          print("values la null");
          return true;
        }
    }
    );
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 30,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 30),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Order amount",
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Text.rich(
                        TextSpan(
                          text: widget.cart.totalAmount.toString()+'k',
                          style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                        ),
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Coupon discount",
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Text.rich(
                    TextSpan(
                      text: (widget.cart.totalAmount*widget.value/100).round().toString()+'k',
                      style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Total",
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Text.rich(
                    TextSpan(
                      text: (widget.cart.totalAmount*(1-widget.value/100)).round().toString()+'k',
                      style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [

                Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset("assets/images/receipt.svg"),
                ),
                Spacer(),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VCScreen()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 7,
                      ),
                      child: Row(
                        children: [
                          Text("Add voucher code"),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.blueAccent,
                          )
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: (widget.cart.totalAmount*(1-widget.value/100)).round().toString()+'k',
                        style: TextStyle(fontSize: 20, color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: (190),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: Colors.blueAccent,
                    onPressed:
                    widget.cart.totalAmount <= 0
                        ? null
                        : () async {
                      String accountKey = FirebaseAuth.instance.currentUser.uid;
                      print(accountKey);
                      var db = FirebaseDatabase.instance.reference().child("accounts").orderByChild(
                          "UID").equalTo(accountKey);
                      db.once().then((DataSnapshot snapshot) async {
                        Map<dynamic, dynamic> values = snapshot.value;
                        if(values==null)
                        {
                          print("Ban chua nhap thong tin dia chi de giao");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfileScreen()),
                          );
                        }
                        else
                          {
                            await Provider.of<Orders>(context, listen: false)
                                .addOrder(
                                widget.cart.items.values.toList(),
                                (widget.cart.totalAmount*(1-widget.value/100)).round());
                            widget.cart.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HistoryScreen()),
                            );
                          }
                      });
                    },
                    child: Text(
                      "Place order",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}