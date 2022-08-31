import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_doctors/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../globals.dart' as globals;

class SendRecommendation extends StatelessWidget {
  SendRecommendation({Key? key}) : super(key: key);
  late final recommendationController = TextEditingController();
  showSnackBar(BuildContext context, String text) {
    var snackdemo = SnackBar(
      content: Text(text),
      backgroundColor: Colors.green,
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackdemo);
  }

  retreiveRecommendationDB() async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(globals.chosenPatientId!)
          .get();
      recommendationController.text = doc["recommendation"];
    } catch (e) {
      print("eeeeeeeeeeeeeeee error in retreiveRecommendationDB()" +
          e.toString());
      recommendationController.text = "";
    }
  }

  saveRecommendationDB(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(globals.chosenPatientId!)
          .set({"recommendation": recommendationController.text},
              SetOptions(merge: true));

      showSnackBar(context, 'ההמלצה נשמרה!');
    } catch (e) {
      print("eeeeeeeeeeeeeeee error in saveRecommendationDB()" + e.toString());
      showSnackBar(context, "לא ניתן לשמור את ההמלצה כרגע!");
    }
  }

  @override
  Widget build(BuildContext context) {
    retreiveRecommendationDB();
    var screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width * 0.25,
      color: MyColors.backgroundColor,
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          const Text("שלח המלצות למטופל",
              style: TextStyle(
                  color: Color.fromRGBO(78, 122, 199, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: screenSize.height * 10 / 601),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: screenSize.width * 240 / 1200,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      )),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    controller: recommendationController,
                    onChanged: (value) {},
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.circleArrowLeft,
                    color: Colors.white,
                  ),
                  iconSize: 22,
                  color: Colors.transparent,
                  onPressed: () {
                    saveRecommendationDB(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
