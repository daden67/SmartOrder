import 'coffee_data.dart';
import 'coffee_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Model/cart.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CoffeeItem extends StatelessWidget {
  final int index;

  CoffeeItem({this.index});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CoffeeDetails(
            index: index,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: coffee_list[index].backgroundColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    coffee_list[index].name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: new LinearGradient(
                      colors: [
                        Colors.black12,
                        coffee_list[index].backgroundColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      cart.addItem(
                          index.toString(),
                          coffee_list[index].name + ' - Cold',
                          1,
                          coffee_list[index].price);
                      Fluttertoast.showToast(
                        msg: "1 cold ${coffee_list[index].name} added",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: Hero(
                tag: coffee_list[index].image,
                child: Image.asset(
                  coffee_list[index].image,
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
