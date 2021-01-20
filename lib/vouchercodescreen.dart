import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hismart/Model/cart.dart';
import 'cartscreen.dart';

class VCScreen extends StatefulWidget {


  @override
  _VCScreen createState() => new _VCScreen();
}
class _VCScreen extends State<VCScreen> {
  String _code="";
  @override
  Widget build(BuildContext context) {

    String CheckandGetvalue(String code)
    {

    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Voucher Code"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            TextFormField(
              onChanged: (value) {
                this._code = value;
              },
              controller: TextEditingController(text: _code),
              decoration: new InputDecoration(
                labelText: "Voucher code",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(
                  ),
                ),
                //fillColor: Colors.green
              ),
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(50),
              ),
              child: FlatButton(
                onPressed: () {
                  var db = FirebaseDatabase.instance.reference().child("vouchers").orderByChild("Code").equalTo(_code);
                  db.once().then((DataSnapshot snapshot) {
                    Map<dynamic, dynamic> values = snapshot.value;
                    if(values==null)
                    {
                      print("Voucher không hợp lệ");
                    }
                    else
                      values.forEach((key, values) {
                        String i=values["Value"].toString();
                        print(i);
                        setState(() {
                          _code="";
                          CartScreen.value=int.parse(i);
                        });
                      }
                      );
                  }
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: 7,
                  ),
                  child: Text(
                    "Apply",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    ),
    );
  }
}