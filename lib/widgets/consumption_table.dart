import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../globals.dart' as globals;

class ConsumptionTable extends StatefulWidget {
  const ConsumptionTable({Key? key}) : super(key: key);

  @override
  State<ConsumptionTable> createState() => _ConsumptionTableState();
}

class _ConsumptionTableState extends State<ConsumptionTable> {
  bool _isTableDataLoaded = false;

  List<String> dates = ["תאריך"];
  List<String> times = ["שעה"];
  List<String> productNames = ["שם \n המוצר"];
  List<String> productImages = [];
  List<String> productDefinitions = ["קטגורית \n המוצר"];
  List<String> productTypes = ["סוג"];
  List<String> productKinds = ["אופי"];
  List<String> consumedQuantities = ["כמות \n נצרכת"];
  List<String> consumptionMethods = ["צורת \n צריכה"];
  List<String> beforeConsumptionSeverities = ["חומרת \n לפני \n צריכה"];
  List<String> afterConsumptionSeverities = ["חומרת \n לאחר \n צריכה"];
  retreiveDataDB() async {
    try {
      //data of the selected
      //res["email"]
      final docSelectedPatient = FirebaseFirestore.instance
          .collection("Users")
          .doc(globals.chosenPatientId);

      //preparing the answers in questionnaire to be presented on "פירוט שימושים" table
      final questionnaires =
          await docSelectedPatient.collection("Questionnaires").get();
      for (final questionnaire in questionnaires.docs) {
        final dateQuestionnaire = questionnaire["date"].toString();
        Timestamp stamp = questionnaire["date"];
        DateTime dt = stamp.toDate();
        String d = "${dt.day}/${dt.month}/${dt.year}";
        String t = "${dt.hour}:${dt.minute}";
        dates.add(d);
        times.add(t);
        String json = questionnaire["answers"].toString();
        json = json.substring(1);
        json = json.substring(0, json.length - 1);
        List<String> listAnswers = json.split(",");

        for (int a = 0; a < listAnswers.length; a++) {
          int pos = listAnswers[a].indexOf("?:");
          String question = listAnswers[a].substring(0, pos + 2);
          String answer =
              listAnswers[a].substring(pos + 3, listAnswers[a].length);
          if (question.contains("מהי צורת הצריכה?")) {
            consumptionMethods.add(answer);
          } else if (question.contains("מהי הכמות הנצרכת?")) {
            consumedQuantities.add(answer);
          } else if (question
              .contains("מה חומרת הסימפטומים שלך לפני הצריכה?")) {
            beforeConsumptionSeverities.add(answer);
          } else if (question.contains("מה חומרת הסימפטומים לאחר הצריכה?")) {
            afterConsumptionSeverities.add(answer);
          } else if (question.contains("מה המוצר")) {
            //preparing the used product to be presented on "פירוט שימושים" table
            final products =
                await FirebaseFirestore.instance.collection("Products").get();
            //final products =
            //  await docSelectedPatient.collection("Products").get();
            for (final product in products.docs) {
              if (product.id == answer) {
                productNames.add(product.data()["productName"].toString());
                productImages.add(product.data()["imageUrl"].toString());
                productDefinitions
                    .add(product.data()["productDefinition"].toString());
                productTypes.add(product.data()["productType"].toString());
                productKinds.add(product.data()["productKind"].toString());
              }
            }
          }
        }
        setState(() {
          _isTableDataLoaded = true;
        });
      }
    } catch (e) {
      print("eeeeeeeeeeeee error in retreiveDataDB()");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    if (_isTableDataLoaded == false) {
      retreiveDataDB();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenSize.height * 50 / 601),
        const Padding(
          padding: EdgeInsets.only(top: 30, right: 35),
          child: Text('פירוט שימושים',
              style: TextStyle(
                  color: Color.fromRGBO(78, 122, 199, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 20.0),
        SizedBox(
          height: 100,
          child: ListView.builder(
              // the number of items in the list
              itemCount: dates.length,
              // display each item of the product list
              itemBuilder: (context, index) {
                Color c = index == 0 ? Colors.blue : Colors.black;
                return Material(
                  color: index % 2 == 0 ? Colors.white : Colors.black26,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 12,
                        child: Center(
                          child: Text(dates[index],
                              style: TextStyle(
                                  color: c,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Center(
                          child: Text(times[index],
                              style: TextStyle(
                                  color: c,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      Expanded(
                        flex: 12,
                        child: Center(
                          child: Text(productNames[index],
                              style: TextStyle(
                                  color: c,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      Expanded(
                        flex: 12,
                        child: Center(
                          child: Text(productDefinitions[index],
                              style: TextStyle(
                                  color: c,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Center(
                          child: Text(productKinds[index],
                              style: TextStyle(
                                  color: c,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Center(
                          child: Text(productTypes[index],
                              style: TextStyle(
                                  color: c,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Center(
                          child: Text(consumedQuantities[index],
                              style: TextStyle(
                                  color: c,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Center(
                          child: Text(consumptionMethods[index],
                              style: TextStyle(
                                  color: c,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Center(
                          child: Text(beforeConsumptionSeverities[index],
                              style: TextStyle(
                                  color: c,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Center(
                          child: Text(afterConsumptionSeverities[index],
                              style: TextStyle(
                                  color: c,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
