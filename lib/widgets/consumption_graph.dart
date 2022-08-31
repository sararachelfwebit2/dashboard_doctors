import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_doctors/services/garmin_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsumptionChart extends StatefulWidget {
  const ConsumptionChart({Key? key}) : super(key: key);

  @override
  State<ConsumptionChart> createState() => _ConsumptionChartState();
}

class _ConsumptionChartState extends State<ConsumptionChart> {
  int _numButtonSelected = 0;
  String _selectedGraphPeriod = "השבוע";
  bool _pointsLoaded = false;
  double _sunHeartRate = 0;
  double _monHeartRate = 0;
  double _tueHeartRate = 0;
  double _wedHeartRate = 0;
  double _thuHeartRate = 0;
  double _friHeartRate = 0;
  double _satHeartRate = 0;

  double _sunSleepingRange = 0;
  double _monSleepingRange = 0;
  double _tueSleepingRange = 0;
  double _wedSleepingRange = 0;
  double _thuSleepingRange = 0;
  double _friSleepingRange = 0;
  double _satSleepingRange = 0;

  double _sunSteps = 0;
  double _monSteps = 0;
  double _tueSteps = 0;
  double _wedSteps = 0;
  double _thuSteps = 0;
  double _friSteps = 0;
  double _satSteps = 0;

  double _sunTHC = 0;
  double _monTHC = 0;
  double _tueTHC = 0;
  double _wedTHC = 0;
  double _thuTHC = 0;
  double _friTHC = 0;
  double _satTHC = 0;
  double _sunCBD = 0;
  double _monCBD = 0;
  double _tueCBD = 0;
  double _wedCBD = 0;
  double _thuCBD = 0;
  double _friCBD = 0;
  double _satCBD = 0;

  getDataCharts() async {
    //the 7 day period we select
    List<DateTime> selectedDays = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedTimePeriod = prefs.getString(
          "selectedTimePeriod",
        ) ??
        "";
    String selectedPatient = prefs.getString(
          "selectedPatient",
        ) ??
        "";
    try {
      //Last 7 days stats
      DateTime dtDay1 = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .subtract(const Duration(days: 6));
      selectedDays.add(dtDay1);
      selectedDays.add(dtDay1.add(const Duration(days: 1)));
      selectedDays.add(dtDay1.add(const Duration(days: 2)));
      selectedDays.add(dtDay1.add(const Duration(days: 3)));
      selectedDays.add(dtDay1.add(const Duration(days: 4)));
      selectedDays.add(dtDay1.add(const Duration(days: 5)));
      selectedDays.add(dtDay1.add(const Duration(days: 6)));

      final docSelectedPatient =
          FirebaseFirestore.instance.collection("Users").doc(selectedPatient);
      final questionnaires =
          await docSelectedPatient.collection("Questionnaires").get();
      final products =
          await FirebaseFirestore.instance.collection("Products").get();
      for (final questionnaire in questionnaires.docs) {
        Timestamp stampQuestionnaire = questionnaire["date"];
        DateTime dtQuestionnaire = stampQuestionnaire.toDate();
        //going through selectedDays to check if this questionnaire wad held during the selected period
        for (final selectedDay in selectedDays) {
          if (selectedDay.day == dtQuestionnaire.day &&
              selectedDay.month == dtQuestionnaire.month) {
            String json = questionnaire["answers"].toString();
            json = json.substring(1);
            json = json.substring(0, json.length - 1);
            List<String> listAnswers = json.split(",");
            String usedProduct = "";
            String methodUse = "";
            for (int a = 0; a < listAnswers.length; a++) {
              int pos = listAnswers[a].indexOf("?:");
              String question = listAnswers[a].substring(0, pos + 2);
              String answer =
                  listAnswers[a].substring(pos + 3, listAnswers[a].length);

              if (question.contains("מה המוצר")) {
                usedProduct = answer;
              } else if (question.contains("מהי צורת הצריכה?")) {
                methodUse = answer;
              }
              //going through Products collection to find the used product

              for (final product in products.docs) {
                if (product.id == usedProduct) {
                  String productDefinition =
                      product.data()["productDefinition"].toString();

                  //getting all CBD & THC
                  final garminServices =
                      Provider.of<GarminServices>(context, listen: false);
                  String str = garminServices.thcCbdQuantities.toString();

                  String strMethod = methodUse == "אידוי" ? "oil" : "smoking";
                  int pos = str.indexOf("$productDefinition-$strMethod");
                  String temp = str.substring(pos);
                  pos = temp.indexOf("{");
                  temp = temp.substring(pos + 1);
                  pos = temp.indexOf("}");
                  temp = temp.substring(0, pos);
                  int posSpace = temp.indexOf(" ");
                  int posComma = temp.indexOf(",");
                  double thc =
                      double.parse(temp.substring(posSpace + 1, posComma));
                  temp = temp.substring(posComma + 2);
                  posSpace = temp.indexOf(" ");
                  double cbd = double.parse(temp.substring(posSpace + 1));
                  //putting values into vars according to the weekday of the questionnaire
                  if (selectedDay.weekday == 7) {
                    _sunCBD = cbd;
                    _sunTHC = thc;
                  } else if (selectedDay.weekday == 1) {
                    _monCBD = cbd;
                    _monTHC = thc;
                  } else if (selectedDay.weekday == 2) {
                    _tueCBD = cbd;
                    _tueTHC = thc;
                  } else if (selectedDay.weekday == 3) {
                    _wedCBD = cbd;
                    _wedTHC = thc;
                  } else if (selectedDay.weekday == 4) {
                    _thuCBD = cbd;
                    _thuTHC = thc;
                  } else if (selectedDay.weekday == 5) {
                    _friCBD = cbd;
                    _friTHC = thc;
                  } else if (selectedDay.weekday == 6) {
                    _satCBD = cbd;
                    _satTHC = thc;
                  }
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeee getDataCharts 1st try block=" + e.toString());
    }

    //going over selectedDays, looking for these days in GarminData collection for this patient =>
    //retreiving sleepRange, steps, restingHeartRate.
    try {
      final garmins =
          await FirebaseFirestore.instance.collection("GarminData").get();
      for (final garmin in garmins.docs) {
        if (garmin.id == selectedPatient) {
          for (final selectedDay in selectedDays) {
            String formattedSelectedDay =
                "${selectedDay.day}-${selectedDay.month}-${selectedDay.year}";
            try {
              final sleepRange = garmin.get(formattedSelectedDay)["sleepRange"];
              if (selectedDay.weekday == 7) {
                _sunSleepingRange = sleepRange;
              } else if (selectedDay.weekday == 1) {
                _monSleepingRange = sleepRange;
              } else if (selectedDay.weekday == 2) {
                _tueSleepingRange = sleepRange;
              } else if (selectedDay.weekday == 3) {
                _wedSleepingRange = sleepRange;
              } else if (selectedDay.weekday == 4) {
                _thuSleepingRange = sleepRange;
              } else if (selectedDay.weekday == 5) {
                _friSleepingRange = sleepRange;
              } else if (selectedDay.weekday == 6) {
                _satSleepingRange = sleepRange;
              }
            } catch (e) {}
            try {
              final steps = garmin.get(formattedSelectedDay)["steps"];

              if (selectedDay.weekday == 7) {
                _sunSteps = steps;
              } else if (selectedDay.weekday == 1) {
                _monSteps = steps;
              } else if (selectedDay.weekday == 2) {
                _tueSteps = steps;
              } else if (selectedDay.weekday == 3) {
                _wedSteps = steps;
              } else if (selectedDay.weekday == 4) {
                _thuSteps = steps;
              } else if (selectedDay.weekday == 5) {
                _friSteps = steps;
              } else if (selectedDay.weekday == 6) {
                _satSteps = steps;
              }
            } catch (e) {}
            try {
              final restingHeartRate =
                  garmin.get(formattedSelectedDay)["restingHeartRate"];

              if (selectedDay.weekday == 7) {
                _sunHeartRate = restingHeartRate;
              } else if (selectedDay.weekday == 1) {
                _monHeartRate = restingHeartRate;
              } else if (selectedDay.weekday == 2) {
                _tueHeartRate = restingHeartRate;
              } else if (selectedDay.weekday == 3) {
                _wedHeartRate = restingHeartRate;
              } else if (selectedDay.weekday == 4) {
                _thuHeartRate = restingHeartRate;
              } else if (selectedDay.weekday == 5) {
                _friHeartRate = restingHeartRate;
              } else if (selectedDay.weekday == 6) {
                _satHeartRate = restingHeartRate;
              }
            } catch (e) {}
          }
        }
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeee getDataCharts 2nd try block=" + e.toString());
    }

    setState(() {
      _pointsLoaded = true;
    });
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 1:
              text = 'שבת';
              break;
            case 2:
              text = 'ששי';
              break;
            case 3:
              text = 'חמישי';
              break;
            case 4:
              text = 'רביעי';
              break;
            case 5:
              text = 'שלישי';
              break;
            case 6:
              text = 'שני';
              break;
            case 7:
              text = 'ראשון';
              break;
          }

          return Text(text);
        },
      );

  String convertToHoursMinures(double milli) {
    int hours = (milli / 1000 / 60 / 60).floor();
    int remainingMilli = (milli - (hours * 60 * 60 * 1000)).floor();
    int minutes = (remainingMilli / 1000 / 60).floor();
    String strMinutes = "";
    if (minutes == 0) {
      strMinutes = "0$minutes";
    } else {
      strMinutes = minutes.toString();
    }
    return "$hours:$strMinutes";
  }

  @override
  Widget build(BuildContext context) {
    String nameSelectedButton = "";
    if (_numButtonSelected == 0) {
      nameSelectedButton = "נתוני דופק:";
    } else if (_numButtonSelected == 1) {
      nameSelectedButton = "נתוני שינה:";
    } else {
      nameSelectedButton = "נתוני צעדים:";
    }
    if (_pointsLoaded == false) {
      getDataCharts();
    }
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGraphPeriod = "היום";
                });
              },
              child: Container(
                  width: screenSize.width * 80 / 1200,
                  height: screenSize.height * 25 / 601,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(
                        color: _selectedGraphPeriod == "היום"
                            ? Colors.blue
                            : Colors.transparent,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: const Text("היום",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w200,
                          color: Colors.black))),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGraphPeriod = "השבוע";
                });
              },
              child: Container(
                  width: screenSize.width * 80 / 1200,
                  height: screenSize.height * 25 / 601,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(
                        color: _selectedGraphPeriod == "השבוע"
                            ? Colors.blue
                            : Colors.transparent,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: const Text("השבוע",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w200,
                          color: Colors.black))),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGraphPeriod = "החודש";
                });
              },
              child: Container(
                  width: screenSize.width * 80 / 1200,
                  height: screenSize.height * 25 / 601,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(
                        color: _selectedGraphPeriod == "החודש"
                            ? Colors.blue
                            : Colors.transparent,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: const Text("החודש",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w200,
                          color: Colors.black))),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGraphPeriod = "השנה";
                });
              },
              child: Container(
                  width: screenSize.width * 80 / 1200,
                  height: screenSize.height * 25 / 601,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(
                        color: _selectedGraphPeriod == "השנה"
                            ? Colors.blue
                            : Colors.transparent,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: const Text("השנה",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w200,
                          color: Colors.black))),
            ),
          ],
        ),
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _numButtonSelected = 0;
                    });
                  },
                  child: Container(
                      width: screenSize.width * 80 / 1200,
                      height: screenSize.height * 25 / 601,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          border: Border.all(
                            color: _numButtonSelected == 0
                                ? Colors.blue
                                : Colors.transparent,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            Icons.heart_broken,
                            color: Colors.red,
                            size: 14.0,
                          ),
                          Text("דופק",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black)),
                        ],
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _numButtonSelected = 1;
                    });
                  },
                  child: Container(
                      width: screenSize.width * 80 / 1200,
                      height: screenSize.height * 25 / 601,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          border: Border.all(
                            color: _numButtonSelected == 1
                                ? Colors.blue
                                : Colors.transparent,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            Icons.stars,
                            color: Colors.yellowAccent,
                            size: 14.0,
                          ),
                          Text("שינה",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black)),
                        ],
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _numButtonSelected = 2;
                    });
                  },
                  child: Container(
                      width: screenSize.width * 80 / 1200,
                      height: screenSize.height * 25 / 601,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          border: Border.all(
                            color: _numButtonSelected == 2
                                ? Colors.blue
                                : Colors.transparent,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            Icons.nordic_walking,
                            color: Colors.purple,
                            size: 14.0,
                          ),
                          Text("צעדים",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black)),
                        ],
                      )),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: screenSize.height * 0.35,
                  width: screenSize.width * 0.35,
                  child: Stack(
                    children: [
                      if (_numButtonSelected == 0) ...[
                        /*LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 8,
                        minY: 0,
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(
                                1,
                                _satHearRate,
                              ),
                              FlSpot(2, _friHearRate),
                              FlSpot(3, _thuHearRate),
                              FlSpot(4, _wedHearRate),
                              FlSpot(5, _tueHearRate),
                              FlSpot(6, _monHearRate),
                              FlSpot(7, _sunHearRate),
                            ],
                            color: Colors.green,
                            dotData: FlDotData(
                              show: true,
                            ),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          show: false,
                          //bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                        ),
                        borderData: FlBorderData(
                            border: const Border(
                                /*bottom: BorderSide(), left: BorderSide()*/)),
                      ),
                    ),*/
                      ],
                      BarChart(
                        BarChartData(
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                            topTitles: AxisTitles(sideTitles: _bottomTitles),
                          ),
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 10.0,
                          minY: 0.0,
                          //groupsSpace: 7,
                          barTouchData: BarTouchData(enabled: true),
                          borderData: FlBorderData(border: const Border()),
                          barGroups: [
                            BarChartGroupData(x: 1, barRods: [
                              BarChartRodData(
                                toY: _satTHC,
                                color: Colors.blue.shade800,
                              ),
                              BarChartRodData(
                                toY: _satCBD,
                                color: Colors.blue.shade300,
                                width: 15.0,
                              ),
                            ]),
                            BarChartGroupData(x: 2, barRods: [
                              BarChartRodData(
                                toY: _friTHC,
                                color: Colors.blue.shade800,
                                width: 15.0,
                              ),
                              BarChartRodData(
                                toY: _friCBD,
                                color: Colors.blue.shade300,
                                width: 15.0,
                              ),
                            ]),
                            BarChartGroupData(x: 3, barRods: [
                              BarChartRodData(
                                toY: _thuTHC,
                                color: Colors.blue.shade800,
                                width: 15.0,
                              ),
                              BarChartRodData(
                                toY: _thuCBD,
                                color: Colors.blue.shade300,
                                width: 15.0,
                              ),
                            ]),
                            BarChartGroupData(x: 4, barRods: [
                              BarChartRodData(
                                toY: _wedTHC,
                                color: Colors.blue.shade800,
                                width: 15.0,
                              ),
                              BarChartRodData(
                                toY: _wedCBD,
                                color: Colors.blue.shade300,
                                width: 15.0,
                              ),
                            ]),
                            BarChartGroupData(x: 5, barRods: [
                              BarChartRodData(
                                toY: _tueTHC,
                                color: Colors.blue.shade800,
                                width: 15.0,
                              ),
                              BarChartRodData(
                                toY: _tueCBD,
                                color: Colors.blue.shade300,
                                width: 15.0,
                              ),
                            ]),
                            BarChartGroupData(x: 6, barRods: [
                              BarChartRodData(
                                toY: _monTHC,
                                color: Colors.blue.shade800,
                                width: 15.0,
                              ),
                              BarChartRodData(
                                toY: _monCBD,
                                color: Colors.blue.shade300,
                                width: 15.0,
                              ),
                            ]),
                            BarChartGroupData(x: 7, barRods: [
                              BarChartRodData(
                                toY: _sunTHC,
                                color: Colors.blue.shade800,
                                width: 15.0,
                              ),
                              BarChartRodData(
                                toY: _sunCBD,
                                color: Colors.blue.shade300,
                                width: 15.0,
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(flex: 14, child: Text(nameSelectedButton)),
            Expanded(
              flex: 12,
              child: Container(
                color: Colors.blue.shade300,
                width: screenSize.width * 40 / 1200,
                height: screenSize.height * 20 / 601,
                child: _numButtonSelected == 0
                    ? Text(_sunHeartRate.toString())
                    : _numButtonSelected == 1
                        ? Text(convertToHoursMinures(_sunSleepingRange))
                        : Text(_sunSteps.toString()),
              ),
            ),
            Expanded(
              flex: 11,
              child: Container(
                color: Colors.blue.shade300,
                width: screenSize.width * 40 / 1200,
                height: screenSize.height * 20 / 601,
                child: _numButtonSelected == 0
                    ? Text(_monHeartRate.toString())
                    : _numButtonSelected == 1
                        ? Text(convertToHoursMinures(_monSleepingRange))
                        : Text(_monSteps.toString()),
              ),
            ),
            Expanded(
              flex: 11,
              child: Container(
                color: Colors.blue.shade300,
                width: screenSize.width * 40 / 1200,
                height: screenSize.height * 20 / 601,
                child: _numButtonSelected == 0
                    ? Text(_tueHeartRate.toString())
                    : _numButtonSelected == 1
                        ? Text(convertToHoursMinures(_tueSleepingRange))
                        : Text(_tueSteps.toString()),
              ),
            ),
            Expanded(
              flex: 11,
              child: Container(
                color: Colors.blue.shade300,
                width: screenSize.width * 40 / 1200,
                height: screenSize.height * 20 / 601,
                child: _numButtonSelected == 0
                    ? Text(_wedHeartRate.toString())
                    : _numButtonSelected == 1
                        ? Text(convertToHoursMinures(_wedSleepingRange))
                        : Text(_wedSteps.toString()),
              ),
            ),
            Expanded(
              flex: 12,
              child: Container(
                color: Colors.blue.shade300,
                width: screenSize.width * 40 / 1200,
                height: screenSize.height * 20 / 601,
                child: _numButtonSelected == 0
                    ? Text(_thuHeartRate.toString())
                    : _numButtonSelected == 1
                        ? Text(convertToHoursMinures(_thuSleepingRange))
                        : Text(_thuSteps.toString()),
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                color: Colors.blue.shade300,
                width: screenSize.width * 40 / 1200,
                height: screenSize.height * 20 / 601,
                child: _numButtonSelected == 0
                    ? Text(_friHeartRate.toString())
                    : _numButtonSelected == 1
                        ? Text(convertToHoursMinures(_friSleepingRange))
                        : Text(_friSteps.toString()),
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                color: Colors.blue.shade300,
                width: screenSize.width * 40 / 1200,
                height: screenSize.height * 20 / 601,
                child: _numButtonSelected == 0
                    ? Text(_satHeartRate.toString())
                    : _numButtonSelected == 1
                        ? Text(convertToHoursMinures(_satSleepingRange))
                        : Text(_satSteps.toString()),
              ),
            ),
            Expanded(flex: 10, child: Container()),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 12.0,
            left: 50.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                "Heart Rate",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
              ),
              Container(
                color: Colors.green,
                width: screenSize.width * 10 / 1200,
                height: screenSize.height * 10 / 601,
              ),
              SizedBox(width: screenSize.width * 20 / 1200),
              const Text(
                "THC",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
              ),
              Container(
                color: Colors.blue.shade800,
                width: screenSize.width * 10 / 1200,
                height: screenSize.height * 10 / 601,
              ),
              SizedBox(width: screenSize.width * 20 / 1200),
              const Text(
                "CBD",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
              ),
              Container(
                color: Colors.blue.shade300,
                width: screenSize.width * 10 / 1200,
                height: screenSize.height * 10 / 601,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
