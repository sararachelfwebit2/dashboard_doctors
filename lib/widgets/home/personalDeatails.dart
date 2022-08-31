import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_doctors/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../globals.dart' as globals;

class PersonalDetails extends StatefulWidget {
  final String mail;

  const PersonalDetails({super.key, required this.mail});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  var _data;
  String _name = "";
  int _weight = 0;
  int _height = 0;
  String _gender = "";
  int _age = 0;
  String _imageUrl = "";
  String _lastPatientId = "";

  retreivePersonalDetailsDB() async {
    try {
      _data = await FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: widget.mail)
          .get();
    } catch (e) {
      print("eeeeeeeeeeeeeee error in PersonalDetails DB query");
    }
    try {
      _name = _data.docs[0]["name"];
    } catch (e) {
      print("eeeeeeeeeeeeeee error in name field");
    }
    try {
      _weight = _data.docs[0]["weight"];
    } catch (e) {
      print("eeeeeeeeeeeeeee error in weight field");
    }
    try {
      _height = _data.docs[0]["height"];
    } catch (e) {
      print("eeeeeeeeeeeeeee error in weight field");
    }
    try {
      _gender = _data.docs[0]["gender"];
    } catch (e) {
      print("eeeeeeeeeeeeeee error in gender field");
    }
    try {
      String birth = _data.docs[0]["birth"];

      int yearBirth = int.parse(birth.substring(0, 4));

      int yearNow = DateTime.now().year;
      _age = yearNow - yearBirth;
    } catch (e) {
      print("eeeeeeeeeeeeeee error in birth field");
    }
    try {
      _imageUrl = _data.docs[0]["imageUrl"];
    } catch (e) {
      print("eeeeeeeeeeeeeee error in imageUerl field");
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //retreivePersonalDetailsDB();
  }

  @override
  Widget build(BuildContext context) {
    if (_lastPatientId != globals.chosenPatientId) {
      _lastPatientId = globals.chosenPatientId ?? "";

      retreivePersonalDetailsDB();
    }
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: screenSize.height * 33 / 1080,
                  right: screenSize.width * 70 / 1920),
              child: SizedBox(
                width: screenSize.width * 65 / 1920,
                height: screenSize.height * 65 / 1080,
                child: const Icon(
                  Icons.person,
                  size: 24.0,
                  color: Color.fromRGBO(78, 122, 199, 1),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: screenSize.width * 8.5 / 1920,
                top: screenSize.height * 46 / 1080,
              ),
              child: SizedBox(
                width: screenSize.width * 160 / 1920,
                height: screenSize.height * 40 / 1080,
                child: AutoSizeText(
                  'פרטים אישיים',
                  style: TextStyle(
                      fontSize: 30,
                      color: HexaColor(
                        "#4E7AC7",
                      ),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: screenSize.width * 73 / 1920,
                top: screenSize.height * 21 / 1080,
              ),
              child: SizedBox(
                width: screenSize.width * 62 / 1920,
                height: screenSize.height * 62 / 1080,
                child: CircleAvatar(
                    backgroundImage: NetworkImage(_imageUrl), radius: 15.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: screenSize.width * 39 / 1920,
                top: screenSize.height * 4 / 1080,
              ),
              child: SizedBox(
                width: screenSize.width * 95 / 1920,
                height: screenSize.height * 33 / 1080,
                child: AutoSizeText(
                  _name,
                  style: TextStyle(
                      fontSize: 25,
                      color: HexaColor("#4E7AC7"),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: screenSize.width * 78 / 1920,
                top: screenSize.height * 4 / 1080,
              ),
              child: SizedBox(
                  width: screenSize.width * 30 / 1920,
                  height: screenSize.height * 41 / 1080,
                  child: Image.asset(
                    "assets/icons/clock_off.png",
                  )),
            ),
          ],
        ),
        const Divider(),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: screenSize.width * 48 / 1920,
                top: screenSize.height * 25 / 1080,
              ),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: screenSize.width * 85 / 1920,
                height: screenSize.height * 70 / 1080,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: AutoSizeText(
                        "גיל",
                        style: TextStyle(
                            fontSize: 14,
                            color: HexaColor("#838383"),
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    AutoSizeText(
                      _age.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: HexaColor("#242424"),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: screenSize.width * 9 / 1920,
                top: screenSize.height * 25 / 1080,
              ),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: screenSize.width * 85 / 1920,
                height: screenSize.height * 70 / 1080,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      "מין",
                      style: TextStyle(
                          fontSize: 14,
                          color: HexaColor("#838383"),
                          fontWeight: FontWeight.w400),
                    ),
                    AutoSizeText(
                      _gender.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: HexaColor("#242424"),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: screenSize.width * 9 / 1920,
                top: screenSize.height * 25 / 1080,
              ),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: screenSize.width * 85 / 1920,
                height: screenSize.height * 70 / 1080,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      "גובה",
                      style: TextStyle(
                          fontSize: 14,
                          color: HexaColor("#838383"),
                          fontWeight: FontWeight.w400),
                    ),
                    AutoSizeText(
                      _height.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: HexaColor("#242424"),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: screenSize.width * 9 / 1920,
                top: screenSize.height * 25 / 1080,
              ),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: screenSize.width * 85 / 1920,
                height: screenSize.height * 70 / 1080,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      "משקל",
                      style: TextStyle(
                          fontSize: 14,
                          color: HexaColor("#838383"),
                          fontWeight: FontWeight.w300),
                    ),
                    AutoSizeText(
                      _weight.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: HexaColor("#242424"),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
