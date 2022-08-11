import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_doctors/colors.dart';
import 'package:dashboard_doctors/models/user.dart';
import 'package:flutter/material.dart';
import 'package:textfield_search/textfield_search.dart';
import 'searchWidget.dart';

class UserList extends StatefulWidget {
  UserList({Key? key, required this.myUsers, required this.onChoose})
      : super(key: key);
  List<UserStats> myUsers;
  Function onChoose;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  TextEditingController searchController = TextEditingController();
  late List<UserStats> myUsers;

  String chosenId = '';

  @override
  void initState() {
    print('kkkk===');
    myUsers = widget.myUsers;
    chosenId = myUsers[0].id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'מטופלים פעילים ',
                style: TextStyle(
                    color: MyColors.textBlueColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              Text(widget.myUsers.length.toString(),
                  style: const TextStyle(
                      color: MyColors.textBlueColor, fontSize: 20))
            ],
          ),
          // const TextField(decoration: InputDecoration(
          //   suffixIcon: Icon(Icons.search),
          //  fillColor: Colors.white,
          //   focusColor:Colors.white,
          //   border: OutlineInputBorder(
          //     borderRadius:
          //     BorderRadius.all(Radius.circular(7.0)),
          //   ),
          //   hintText: 'חיפוש לפי מייל',
          // ),
          // ),

          SearchWidget(
            hintText: 'חיפוש לפי מייל',
            onChanged: onSearchTextChanged,
            text: 'ghku',
          ),
          Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: myUsers.length,
                  itemBuilder: (ctx, i) {
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                chosenId = myUsers[i].id;
                              });
                              widget.onChoose(myUsers[i].id, myUsers[i].email);
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                color: chosenId == myUsers[i].id
                                    ? Colors.blueAccent.shade100
                                    : const Color.fromRGBO(234, 240, 254, 1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Center(
                                            child: Text(myUsers[i].email))),
                                    Image.asset(
                                        myUsers[i].isGarminConnectedIn24
                                            ? 'assets/icons/clock_on.png'
                                            : 'assets/icons/clock_off.png',
                                        width: 30,
                                        height: 30)
                                  ],
                                )),
                          ),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(color: Colors.black)))
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      myUsers = widget.myUsers;
      setState(() {});
      return;
    }

    final _search = widget.myUsers.where((user) {
      final titleLower = user.email.toLowerCase();
      final searchLower = text.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      myUsers = _search;
    });
  }
}
