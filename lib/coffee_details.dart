import 'coffee_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:provider/provider.dart';
import 'package:hismart/cartscreen.dart';
import 'Model/cart.dart';
import 'package:hismart/homescreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CoffeeDetails extends StatefulWidget {
  final int index;

  CoffeeDetails({this.index});

  @override
  _CoffeeDetailsState createState() => _CoffeeDetailsState();
}

class _CoffeeDetailsState extends State<CoffeeDetails> {
  var rating = 3.0;
  int quantity = 1;
  bool switchvalue = true;
  bool isFavourite = true;
  String text = " - Cold";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      backgroundColor: coffee_list[widget.index].backgroundColor,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 60,
                      child: IconButton(
                        icon: Image.asset("assets/images/menu.png"),
                        iconSize: 40,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 60,
                      child: IconButton(
                        icon: Image.asset("assets/images/shopping-cart.png"),
                        iconSize: 40,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartScreen()),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                70,
                              ),
                              topRight: Radius.circular(
                                70,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: 50,
                      child: Container(
                        height: 300,
                        width: 300,
                        child: Hero(
                          tag: coffee_list[widget.index].image,
                          child: Image.asset(
                            coffee_list[widget.index].image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(30),
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    iconSize: 40,
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: coffee_list[widget.index]
                                          .backgroundColor,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isFavourite = !isFavourite;
                                      });
                                    },
                                    iconSize: 40,
                                    icon: Icon(
                                      isFavourite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: coffee_list[widget.index]
                                          .backgroundColor,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    child: Text(
                                      coffee_list[widget.index].name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 45,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SmoothStarRating(
                                        rating: rating,
                                        isReadOnly: false,
                                        size: 30,
                                        filledIconData: Icons.star,
                                        halfFilledIconData: Icons.star_half,
                                        defaultIconData: Icons.star_border,
                                        starCount: 5,
                                        allowHalfRating: true,
                                        spacing: 2.0,
                                        onRated: (value) {
                                          setState(() {
                                            rating = value;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          rating.toString(),
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 45,
                                    child: Text(
                                      "${coffee_list[widget.index].price}k",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 40,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        iconSize: 40,
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: coffee_list[widget.index]
                                              .backgroundColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (quantity > 0) {
                                              quantity -= 1;
                                            }
                                          });
                                        },
                                      ),
                                      Container(
                                        height: 35,
                                        width: 35,
                                        alignment: Alignment.center,
                                        child: Text(
                                          quantity.toString(),
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        iconSize: 40,
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: coffee_list[widget.index]
                                              .backgroundColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            quantity += 1;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    child: Text(
                                      "Hot",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 40,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CupertinoSwitch(
                                    value: switchvalue,
                                    activeColor: coffee_list[widget.index]
                                        .backgroundColor,
                                    onChanged: (value) {
                                      setState(() {
                                        switchvalue = value;
                                        if (switchvalue) {
                                          text = " - Cold";
                                        } else {
                                          text = " - Hot";
                                        }
                                        print(text);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 40,
                                    child: Text(
                                      "Cold",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 40,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 70,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    decoration: BoxDecoration(
                                      color: coffee_list[widget.index]
                                          .backgroundColor,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: FlatButton(
                                      onPressed: () {
                                        int i = widget.index;
                                        if (!switchvalue) i = -i;
                                        cart.addItem(
                                            i.toString(),
                                            coffee_list[widget.index].name +
                                                text,
                                            quantity,
                                            coffee_list[widget.index].price);
                                        print(text);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CartScreen()),
                                        );
                                      },
                                      child: Container(
                                        child: Text(
                                          "Order Now",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(30),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.add_circle,
                                      size: 50,
                                      color: coffee_list[widget.index]
                                          .backgroundColor,
                                    ),
                                    onPressed: () {
                                      int i = widget.index;
                                      if (!switchvalue) i = -i;
                                      cart.addItem(
                                          i.toString(),
                                          coffee_list[widget.index].name + text,
                                          quantity,
                                          coffee_list[widget.index].price);
                                      print(text);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()),
                                      );
                                      Fluttertoast.cancel();
                                      Fluttertoast.showToast(
                                        msg: "$quantity ${coffee_list[widget.index].name}$text added",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black54,
                                        textColor: Colors.white,
                                        fontSize: 16.0,);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
