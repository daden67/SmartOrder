import 'package:flutter/rendering.dart';
import 'package:hismart/coffee_details.dart';
import 'package:flutter/material.dart';
import 'coffee_data.dart';
import 'coffee_item.dart';


class Search extends SearchDelegate {

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Image.asset("assets/images/cancel.png"),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Image.asset("assets/images/left-arrow.png"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult;
  int selectedIndex;

  @override
  Widget buildResults(BuildContext context) {
    return CoffeeDetails(
      index: selectedIndex,
    );
  }

  final List<String> listExample;

  Search(this.listExample);

  List<String> recentList = ["Espresso", "Cafe mocha"];


  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList
        : suggestionList.addAll(
        listExample.where((element) => element.contains(query),));
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
          ),
          onTap: (){
            selectedResult=suggestionList[index];
            selectedIndex=index;
            showResults(context);
          },
        );
      },
    );
  }
}

class MenuScreen extends StatelessWidget {

  final List<String> list=List.generate(coffee_list.length, (index) => coffee_list[index].name);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 0,
            right: 0,
          ),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xffe5e5e5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 2,
                    color: Colors.black12,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                        icon: Image.asset("assets/images/search.png"),
                        onPressed: ()
                        {
                          showSearch(context: context, delegate: Search(list));
                        }
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.black26,
                          fontSize: 25,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2.5 / 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (ctx, idx) =>
                        CoffeeItem(
                          index: idx,
                        ),
                    itemCount: coffee_list.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
