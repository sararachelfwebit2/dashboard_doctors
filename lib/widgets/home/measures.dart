import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_doctors/models/bar.dart';
import 'package:dashboard_doctors/models/consumption_record.dart';
import 'package:dashboard_doctors/models/product.dart';
import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:dashboard_doctors/models/week_bar.dart';
import 'package:dashboard_doctors/screens/home/home_page.dart';
import 'package:dashboard_doctors/services/garmin_services.dart';
import 'package:dashboard_doctors/widgets/consumption_graph.dart';
import 'package:dashboard_doctors/widgets/consumption_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Measure extends StatefulWidget {
  const Measure({
    Key? key,
  }) : super(key: key);

  @override
  State<Measure> createState() => _MeasureState();
}

class _MeasureState extends State<Measure> {
  bool dayPressed = true;
  DateTime now =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late final List<ConsumptionRecord> records = [];
  late final List<Bar> bars = [];
  late final List<WeekBar> weekBars = [];
  int duration = 7;
  bool isLoadingGragh = true;
  bool garminConnected = false;
  List<DateTime> presentWeek = [];

  Bar? clickedBar;

  List<String> months = [];
  List<DateTime> presentMonth = [];
  String? chosenMonth;

  WeekBar? clickedWeekBar;
  late List<Record> recordsQ = [];
  late final Products productsModel;

  late final Questionnaires questionnaireModel;
  late final garminServices;

  @override
  void initState() {
    productsModel = Provider.of<Products>(context, listen: false);
    questionnaireModel = Provider.of<Questionnaires>(context, listen: false);
    garminServices = Provider.of<GarminServices>(context, listen: false);

    chosenMonth =
        garminServices.garminSentences['ChooseMonth'] ?? 'Choose month';

    fillData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (HomePage.isNewUser) {
      HomePage.isNewUser = false;
      isLoadingGragh = true;
      questionnaireModel.clearData();
      fillData();
    }
    bool isShowingMonth = !(chosenMonth ==
        (garminServices.garminSentences['ChooseMonth'] ?? 'Choose month'));

    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      margin: const EdgeInsets.only(right: 3, left: 3),
      // padding: const EdgeInsets.only(right: 35),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 8),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 30, right: 35),
            child: Text('המטופל ביחס לטיפול',
                style: TextStyle(
                    color: Color.fromRGBO(78, 122, 199, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
          ),
          isLoadingGragh
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    controller: ScrollController(),
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /*ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) => Colors.transparent),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                ((states) => Colors.transparent),
                              ),
                              shadowColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                ((states) => Colors.transparent),
                              ),
                            ),
                            onPressed: () async {
                              DateTime? newFirstDay = await showDatePicker(
                                // fontFamily: 'NunitoSans',
                                // description: garminServices.garminSentences[
                                // 'ChooseStartDayToShowData'] ??
                                //     'Choose Start Day To Show Data',
                                // height: 350,
                                context: context,
                                initialDate: presentWeek.first,
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 120)),
                                lastDate: DateTime.now()
                                    .subtract(const Duration(days: 6)),
                              );

                              if (newFirstDay != null) {
                                newFirstDay = DateTime(newFirstDay.year,
                                    newFirstDay.month, newFirstDay.day);
                                DateTime last = newFirstDay
                                    .add(const Duration(hours: 24 * 6));
                                presentWeek = [
                                  DateTime(newFirstDay.year, newFirstDay.month,
                                      newFirstDay.day),
                                  newFirstDay.add(const Duration(hours: 24)),
                                  newFirstDay
                                      .add(const Duration(hours: 24 * 2)),
                                  newFirstDay
                                      .add(const Duration(hours: 24 * 3)),
                                  newFirstDay
                                      .add(const Duration(hours: 24 * 4)),
                                  newFirstDay
                                      .add(const Duration(hours: 24 * 5)),
                                  newFirstDay
                                      .add(const Duration(hours: 24 * 6)),
                                  // DateTime(last.year, last.month, last.day, 23, 59, 59,
                                  //     999, 999),
                                ];

                                chosenMonth = garminServices
                                        .garminSentences['ChooseMonth'] ??
                                    'Choose month';
                                presentMonth.clear();
                                clickedWeekBar = null;
                                clickedBar = null;

                                isLoadingGragh = true;
                                setState(() {});
                                fillData();
                              }
                            },
                            child: Text(
                              showingDates(),
                              style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                                color: Colors.blue.shade400,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),*/
                          const SizedBox(width: 10),
                        ],
                      ),
                      Center(
                        child: ConsumptionChart(),
                      ),
                      ConsumptionTable(),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  setPrefs(String str) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedTimePeriod", str);
  }

  String showingDates() {
    final garminServices = Provider.of<GarminServices>(context, listen: false);

    bool isShowingMonth = !(chosenMonth ==
        (garminServices.garminSentences['ChooseMonth'] ?? 'Choose month'));

    int day = !isShowingMonth ? presentWeek.first.day : 1;
    String startDay = day < 10 ? '0$day' : '$day';
    int month = months.indexOf(chosenMonth ??
        garminServices.garminSentences['ChooseMonth'] ??
        'Choose month');
    day = !isShowingMonth ? presentWeek.first.month : month;
    String startMonth = day < 10 ? '0$day' : '$day';
    day = !isShowingMonth
        ? presentWeek.last.day
        : DateTime(DateTime.now().year, month + 1, 0).day;
    String endDay = day < 10 ? '0$day' : '$day';
    day = !isShowingMonth ? presentWeek.last.month : month;
    String endMonth = day < 10 ? '0$day' : '$day';

    setPrefs("$startDay/$startMonth-$endDay/$endMonth");
    return '$startDay/$startMonth-$endDay/$endMonth';
  }

  Future<void> fillData() async {
    print('===fillData====');

    await questionnaireModel.fetchQuestionnaires(context);
    await questionnaireModel.fetchQuestions(context);
    await questionnaireModel.fetchRecords();
    await productsModel.fetchMyProducts();
    await garminServices.fetchGarminData(context);

    await Future.delayed(const Duration(seconds: 2));

    months.clear();
    months.addAll([
      garminServices.garminSentences['ChooseMonth'] ?? 'Choose month',
      garminServices.garminSentences['January'] ?? 'January',
      garminServices.garminSentences['February'] ?? 'February',
      garminServices.garminSentences['March'] ?? 'March',
      garminServices.garminSentences['April'] ?? 'April',
      garminServices.garminSentences['May'] ?? 'May',
      garminServices.garminSentences['June'] ?? 'June',
      garminServices.garminSentences['July'] ?? 'July',
      garminServices.garminSentences['August'] ?? 'August',
      garminServices.garminSentences['September'] ?? 'September',
      garminServices.garminSentences['October'] ?? 'October',
      garminServices.garminSentences['November'] ?? 'November',
      garminServices.garminSentences['December'] ?? 'December'
    ]);
    chosenMonth = months[0];

    bool isShowingMonth = !(chosenMonth ==
        (garminServices.garminSentences['ChooseMonth'] ?? 'Choose month'));

    // bool isShowingMonth = !(chosenMonth ==
    //     (garminServices.garminSentences['ChooseMonth'] ?? 'Choose month'));

    records.clear();
    bars.clear();
    weekBars.clear();

    if (presentWeek.isEmpty && !isShowingMonth) {
      presentWeek = [
        now.subtract(const Duration(hours: 24 * 6)),
        now.subtract(const Duration(hours: 24 * 5)),
        now.subtract(const Duration(hours: 24 * 4)),
        now.subtract(const Duration(hours: 24 * 3)),
        now.subtract(const Duration(hours: 24 * 2)),
        now.subtract(const Duration(hours: 24)),
        // DateTime(now.year, now.month, now.day, 23, 59, 59, 999, 999),
        now
      ];
    } else {
      int month = months.indexOf(chosenMonth ?? 'Choose month');
      int maxDay = DateTime(now.year, month + 1, 0).day;
      presentMonth.clear();
      for (var i = 1; i <= maxDay; i++) {
        presentMonth.add(DateTime(now.year, month, i));
      }
      presentMonth.sort((date1, date2) => date1.day - date2.day);
    }
    for (Record record in (questionnaireModel.records.where(
        (element) => element.questionnaireName == 'Intake Questionnaire'))) {
      if (DateTime.tryParse(record.date) == null) continue;
      DateTime recordDateTime = DateTime.parse(record.date);
      if (!isShowingMonth &&
          (recordDateTime.isBefore(presentWeek.first) ||
              recordDateTime.isAfter(presentWeek.last))) {
        continue;
      } else if (isShowingMonth &&
          (recordDateTime.isBefore(presentMonth.first) ||
              recordDateTime.isAfter(presentMonth.last))) {
        continue;
      }
      final productModel = Provider.of<Products>(context, listen: false);

      Product? product = productModel.myProducts.firstWhereOrNull((element) =>
          element.id ==
          record.answers[AppLocalizations.of(context)!.whatProduct]);

      product ??= productModel.myProducts.firstWhereOrNull((element) =>
          element.id ==
          record.answers[record.answers.keys.firstWhereOrNull(
              (element) => element.contains('מה המוצר הנצרך'))]);

      product ??= productModel.myProducts.firstWhereOrNull((element) =>
          element.id ==
          record.answers['What product are you currenty consuming?']);

      double thc = garminServices.thcCbdQuantities[
                  '${product?.productDefinition ?? ''}-${record.isGrams ? 'smoking' : 'oil'}']
              ?['THC'] ??
          0;
      double cbd = garminServices.thcCbdQuantities[
                  '${product?.productDefinition ?? ''}-${record.isGrams ? 'smoking' : 'oil'}']
              ?['CBD'] ??
          0;

      if (thc == 0 && cbd == 0) continue;

      int simptomosBefore = int.tryParse(record
                  .answers['מה חומרת הסימפטומים שלך לפני הצריכה?'] ??
              record.answers[
                  'How severe your symptoms prior to consuming cannabis?']!) ??
          0;

      int simptomosAfter = int.tryParse(
              record.answers['מה חומרת הסימפטומים לאחר הצריכה?'] ??
                  record.answers[
                      'How severe your symptoms after consuming cannabis?']!) ??
          0;

      int influence = simptomosAfter - simptomosBefore;

      String type = product?.productType ?? '';
      String character = product?.productKind ?? '';

      String? method = record.isGrams
          ? record.answers['מהי צורת הצריכה?'] ??
              record.answers['How are you currenty consuming your cannabis?']
          : '';

      String comsumptionMethod = record.isGrams
          ? method! == 'Vaping' || method == 'אידוי'
              ? AppLocalizations.of(context)!.vaping
              : AppLocalizations.of(context)!.smoking
          : AppLocalizations.of(context)!.oil;

      String? severityBefore = record
              .answers['מה חומרת הסימפטומים שלך לפני הצריכה?'] ??
          record
              .answers['How severe your symptoms prior to consuming cannabis?'];

      int severityBeforeNumber = int.tryParse(severityBefore ?? '0') ?? 0;

      String? severityAfter = record
              .answers['מה חומרת הסימפטומים לאחר הצריכה?'] ??
          record.answers['How severe your symptoms after consuming cannabis?'];

      int severityAfterNumber = int.tryParse(severityAfter ?? '0') ?? 0;

      String productImage = product?.imageUrl ?? '';
      records.add(
        ConsumptionRecord(
          DateTime.parse(record.date),
          product?.productName ?? '',
          comsumptionMethod,
          thc,
          cbd,
          double.tryParse(record.answers[
                      AppLocalizations.of(context)!.howMuchConsuming] ??
                  record.answers['מהי הכמות הנצרכת?'] ??
                  record.answers['How much are you currenty consuming?']!) ??
              0,
          'כאבים',
          influence,
          type,
          character,
          product?.productDefinition ?? '',
          severityBeforeNumber,
          severityAfterNumber,
          productImage,
        ),
      );
    }

    for (var conumption in records) {
      Map<String, int>? garminData;
      garminServices.garminStats.forEach((key, value) {
        if (key.isBefore(conumption.consumptionTime) &&
            key
                .add(const Duration(days: 1))
                .isAfter(conumption.consumptionTime)) {
          garminData = value;
        }
      });
      int sleepScore = 0;
      if (garminData != null) {
        double sleepTime = 0;
        if ((garminData!['sleep'] ?? 0) > 0) {
          sleepTime = (garminData!['sleep']! / 1000 / 60 / 60);
          if (sleepTime <= 4) {
            sleepScore = 1;
          } else if (sleepTime <= 5) {
            sleepScore = 2;
          } else if (sleepTime <= 6) {
            sleepScore = 3;
          } else if (sleepTime <= 7) {
            sleepScore = 4;
          } else {
            sleepScore = 5;
          }
        }
      }
      if (!isShowingMonth) {
        Bar? bar = findDay(conumption.consumptionTime, bars);

        if (bar == null) {
          bars.add(
            Bar(
              conumption.thc.toDouble(),
              conumption.cbd.toDouble(),
              (garminData?['restingHr'] ?? 0) == 0
                  ? null
                  : garminData!['restingHr'],
              sleepScore == 0 ? null : sleepScore,
              (garminData?['steps'] ?? 0) == 0 ? null : garminData!['steps'],
              DateTime(
                conumption.consumptionTime.year,
                conumption.consumptionTime.month,
                conumption.consumptionTime.day,
              ),
            ),
          );
        } else {
          bar.thc += conumption.thc;
          bar.cbd += conumption.cbd;
        }
      } else {
        WeekBar? bar = findWeek(conumption.consumptionTime, weekBars);

        if (bar == null) {
          int week = conumption.consumptionTime.day ~/ 7;
          int month = conumption.consumptionTime.month;
          int year = conumption.consumptionTime.year;
          weekBars.add(
            WeekBar(
              conumption.thc,
              conumption.cbd,
              (garminData?['restingHr'] ?? 0) == 0
                  ? null
                  : garminData!['restingHr'],
              sleepScore == 0 ? null : sleepScore,
              (garminData?['steps'] ?? 0) == 0 ? null : garminData!['steps'],
              DateTimeRange(
                start: DateTime(year, month, (week * 7) + 1),
                end: DateTime(year, month, ((week + 1) * 7 + 1)),
              ),
            ),
          );
        } else {
          bar.thc += conumption.thc;
          bar.cbd += conumption.cbd;
          if ((garminData?['restingHr']) != null) {
            bar.heartbeatRate = bar.heartbeatRate == null
                ? garminData!['restingHr']
                : ((bar.heartbeatRate! * bar.amountRecords +
                            garminData!['restingHr']!) ~/
                        (bar.amountRecords + 1))
                    .ceil();
          }

          if (garminData?['sleep'] != null) {
            bar.sleepRate = bar.sleepRate == null
                ? sleepScore
                : (((bar.sleepRate!) * bar.amountRecords + sleepScore) /
                        (bar.amountRecords + 1))
                    .ceil();
          }

          if (garminData?['steps'] != null) {
            bar.steps = bar.steps == null
                ? garminData!['steps']
                : ((bar.steps! * bar.amountRecords + garminData!['steps']!) ~/
                        (bar.amountRecords + 1))
                    .ceil();
          }

          bar.amountRecords++;
        }
      }
    }

    if (!isShowingMonth) {
      bars.sort((bar1, bar2) =>
          bar1.dateTime.millisecondsSinceEpoch -
          bar2.dateTime.millisecondsSinceEpoch);
      if (bars.isEmpty) {
        clickedBar = null;
      } else {
        clickedBar = bars.last;
      }
    } else {
      weekBars.sort((bar1, bar2) =>
          bar1.dateTime.end.millisecondsSinceEpoch -
          bar2.dateTime.start.millisecondsSinceEpoch);
      if (weekBars.isEmpty) {
        clickedWeekBar = null;
      } else {
        clickedWeekBar = weekBars.last;
      }
    }
    // await getQuestionnaires();
    print('filldata bars ${bars.length}');

    isLoadingGragh = false;
    setState(() {});
  }

  void setWeekClickedBar(WeekBar bar) {
    clickedWeekBar = bar;
    setState(() {});
  }

  Bar? findDay(DateTime day, List<Bar> barss) {
    for (var bar in barss) {
      if (bar.dateTime.day == day.day &&
          bar.dateTime.month == day.month &&
          bar.dateTime.year == day.year) {
        return bar;
      }
    }
    return null;
  }

  WeekBar? findWeek(DateTime day, List<WeekBar> barss) {
    for (var bar in barss) {
      if (bar.dateTime.start.isBefore(day) && bar.dateTime.end.isAfter(day)) {
        return bar;
      }
    }
    return null;
  }

  void setClickedBar(Bar bar) {
    clickedBar = bar;
    setState(() {});
  }
}
