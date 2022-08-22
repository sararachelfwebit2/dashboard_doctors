import 'package:dashboard_doctors/colors.dart';
import 'package:dashboard_doctors/models/bar.dart';
import 'package:dashboard_doctors/models/consumption_record.dart';
import 'package:dashboard_doctors/models/week_bar.dart';
import 'package:dashboard_doctors/services/garmin_services.dart';
import 'package:dashboard_doctors/customScrollBehavior.dart';
import 'package:dashboard_doctors/widgets/webImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';


class ConsumptionTable extends StatefulWidget {
  final List<ConsumptionRecord> reords;
  final Bar? clickedBar;
  final WeekBar? clickedWeekBar;
  const ConsumptionTable({
    Key? key,
    required this.reords,
    required this.clickedBar,
    this.clickedWeekBar,
  }) : super(key: key);

  @override
  State<ConsumptionTable> createState() => _ConsumptionTableState();
}

class _ConsumptionTableState extends State<ConsumptionTable> {
  TextStyle titleStyle = const TextStyle(
    fontSize: 16,
    color: MyColors.textBlueColor,
    fontWeight: FontWeight.bold,
    fontFamily: 'Assistant',
  );

  Widget spaceBetweenTitles = const SizedBox(
    width: 10,
  );

  @override
  Widget build(BuildContext context) {
    bool isHebrew = AppLocalizations.of(context)!.languageName == 'Hebrew';
    final garminServices = Provider.of<GarminServices>(context, listen: false);
    var screenSize = MediaQuery.of(context).size;
ScrollController controller=new ScrollController();
    List<Widget> children2 = [
      Row(
        textDirection: isHebrew ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            // height: 80,
            height: 33,
            child: Center(
              child: Text(
                garminServices.garminSentences['Date'] ?? '',
                style: titleStyle.copyWith(fontSize:isHebrew?16:13 ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            height: 30,
            child: Center(
              child: Text(
                garminServices.garminSentences['Hour'] ?? '',
                style: titleStyle.copyWith(fontSize:isHebrew?16:13 ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            height: 30,
            child: Center(
              child: Text(
                garminServices.garminSentences['Product picture'] ?? '',
                style: titleStyle.copyWith(fontSize:isHebrew?16:13 ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            height: 30,
            child: Center(
              child: Text(
                garminServices.garminSentences['Product name'] ?? '',
                style: titleStyle.copyWith(fontSize:isHebrew?16:13 ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            height: 30,
            child: Center(
              child: Text(
                garminServices.garminSentences['Product category'] ?? '',
                style: titleStyle.copyWith(fontSize:isHebrew?16:13 ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            height: 30,
            child: Center(
              child: Text(
                garminServices.garminSentences['Type'] ?? '',
                style: titleStyle.copyWith(fontSize:isHebrew?16:13 ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            height: 30,
            child: Center(
              child: Text(
                garminServices.garminSentences['Character'] ?? '',
                style: titleStyle.copyWith(fontSize:isHebrew?16:13 ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            height: 30,
            child: Center(
              child: Text(
                garminServices.garminSentences['Consumed quantity'] ?? '',
                style: titleStyle.copyWith(fontSize:isHebrew?16:13 ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            height: 30,
            child: Center(
              child: Text(
                garminServices.garminSentences['Consumption method'] ?? '',
                style: titleStyle.copyWith(fontSize:isHebrew?16:13 ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            height: 30,
            child: Center(
              child: Text(
                garminServices.garminSentences[
                        'Symptom severity before consumption'] ??
                    'Symptom severity before consumption',
                style: titleStyle.copyWith(fontSize:12 ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            height: 30,
            child: Center(
              child: Text(garminServices.garminSentences[
                        'Symptom severity after consumption'] ??
                    '',
                style: titleStyle.copyWith(fontSize:12 ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ];
    children2.addAll(buildConsumptionsRows());
    if(!isHebrew)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller
          .animateTo(controller.position.maxScrollExtent,
          duration: Duration(seconds: 1), curve: Curves.ease);});
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          alignment: isHebrew ? Alignment.centerRight : Alignment.centerLeft,
          padding: EdgeInsets.only(
              left: isHebrew ? 0 : 30, right: isHebrew ? 30 : 0),
          child: Text(
            garminServices.garminSentences['ConsumptionRecords'] ?? '',
            style: titleStyle.copyWith(fontSize: 19),
          ),
        ),
        const SizedBox(height: 15),
        // const SizedBox(height: 20),
         Container(
           // height: screenSize.height*0.3,
           // width:screenSize.width*1.55,
           padding: const EdgeInsets.only(left: 10,right: 10),
           child:
           ScrollConfiguration(
             behavior: MyCustomScrollBehavior(), child:
             SingleChildScrollView(
                scrollDirection: Axis.horizontal,


controller: controller,
                // child: Container(
                //   constraints: BoxConstraints(maxWidth: screenSize.width*0.55, maxHeight: screenSize.height*0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children2,
                  ),
                ),
           ),
         ),
         // ),
      ],
    );
  }

  List<Widget> buildConsumptionsRows() {
    TextStyle textStyle = const TextStyle(
      fontSize: 14,
      fontFamily: 'Assistant',
      fontWeight: FontWeight.bold,
    );
    if (widget.clickedBar == null && widget.clickedWeekBar == null) {
      return [];
    }

    final List<Widget> records = widget.reords.map((consumption) {
      if (widget.clickedBar != null && widget.clickedWeekBar == null) {
        if (widget.clickedBar!.dateTime.year !=
                consumption.consumptionTime.year ||
            widget.clickedBar!.dateTime.month !=
                consumption.consumptionTime.month ||
            widget.clickedBar!.dateTime.day !=
                consumption.consumptionTime.day) {
          return Container();
        }
      } else if (widget.clickedBar == null && widget.clickedWeekBar != null) {
        if (widget.clickedWeekBar!.dateTime.start
                .isAfter(consumption.consumptionTime) ||
            widget.clickedWeekBar!.dateTime.end
                .isBefore(consumption.consumptionTime)) {
          return Container();
        }
      } else if (widget.clickedBar == null && widget.clickedWeekBar == null) {
        return Container();
      }

      String date = beautyDate(consumption.consumptionTime);

      String hour = beatyHour(consumption.consumptionTime);

      String productName = consumption.productName;

      String consumptionMethod = consumption.consumptionMethod;

      String consumptionMethodImage = '';

      String smoking = AppLocalizations.of(context)?.smoking ?? 'Smoking';

      String oil = AppLocalizations.of(context)?.oil ?? 'Oil';

      String vaping = AppLocalizations.of(context)?.vaping ?? 'Vaping';
      if (smoking == consumptionMethod) {
        consumptionMethodImage = 'Smoking';
      } else if (oil == consumptionMethod) {
        consumptionMethodImage = 'Oil1';
      } else if (vaping == consumptionMethod) {
        consumptionMethodImage = 'Vaping';
      }

      String type = consumption.type;

      String character = consumption.character;

      String category = consumption.category;

      double amount = consumption.amount;

      String amountOfSmoking = '';

      if (AppLocalizations.of(context)!.languageName == 'Hebrew') {
        amountOfSmoking =
            '${consumption.consumptionMethod != AppLocalizations.of(context)!.oil ? amount : amount.toInt()}  ${consumption.consumptionMethod != AppLocalizations.of(context)!.oil ? AppLocalizations.of(context)!.grams : AppLocalizations.of(context)!.drops}';
      } else {
        amountOfSmoking =
            '${consumption.consumptionMethod != AppLocalizations.of(context)!.oil ? amount : amount.toInt()}  ${consumption.consumptionMethod != AppLocalizations.of(context)!.oil ? AppLocalizations.of(context)!.grams : AppLocalizations.of(context)!.drops}';
      }

      int severityBefore = consumption.symptomSeverityBeforeConsumption;

      int severityAfter = consumption.symptomSeverityAfterConsumption;

      String productImage = !consumption.productImage.startsWith('https')
          ? 'https://www.thc.mba${consumption.productImage}'
          : consumption.productImage;

      return Column(
        children: [
          const SizedBox(height: 5),
          Container(
            alignment: Alignment.center,
            height: 36,
            color: Colors.grey[200],
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection:
                    AppLocalizations.of(context)!.languageName == 'Hebrew'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                children: [
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  // Date.
                  Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 36,
                    child: Text(
                      date,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  // Hour.
                  Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 36,
                    child: Text(
                      hour,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                  // Product image.
                  Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 36,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (states) => Colors.transparent),
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                          ((states) => Colors.transparent),
                        ),
                        shadowColor: MaterialStateProperty.resolveWith<Color>(
                          ((states) => Colors.transparent),
                        ),
                      ),
                      onPressed: () async {
                        await showImageViewer(
                            context, Image.network(productImage).image);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: 80,
                        // decoration: BoxDecoration(
                        //   image: DecorationImage(
                        //     fit: BoxFit.fill,
                        //     image: NetworkImage(productImage),
                        //   ),
                        // ),
                        child: WebImage(imageUrl: productImage),
                      ),
                    ),
                  ),
                  // Product name.
                  Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 36,
                    child: Text(
                      productName,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                  // Product category.
                  Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 36,
                    child: Text(
                      category,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                  // Product type.
                  Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 36,
                    child: Text(
                      type,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                  // Product character.
                  Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 36,
                    child: Text(
                      character,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                  // Consumed quantity.
                  // const SizedBox(width: 15),
                  Container(
                    alignment: Alignment.center,
                    width: 120,
                    height: 36,
                    child: Text(
                      amountOfSmoking,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 120,
                    height: 36,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/$consumptionMethodImage.png',
                          width: 20,
                          height: 20,
                        ),
                        Text(
                          consumptionMethod,
                          textAlign: TextAlign.center,
                          style: textStyle.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(width: 25),
                  Container(
                    alignment: Alignment.center,
                    width: 110,
                    height: 36,
                    child: Text(
                      severityBefore.toString(),
                      textAlign: TextAlign.center,
                      style: textStyle.copyWith(
                          fontSize: 15,
                          color: severityBefore <= 2
                              ? Colors.red
                              : severityBefore == 3
                                  ? Colors.orange
                                  : Colors.green),
                    ),
                  ),
                  // const SizedBox(width: 60),
                  Container(
                    alignment: Alignment.center,
                    width: 110,
                    height: 36,
                    child: Text(
                      severityAfter.toString(),
                      textAlign: TextAlign.center,
                      style: textStyle.copyWith(
                          fontSize: 15,
                          color: severityAfter <= 2
                              ? Colors.red
                              : severityAfter == 3
                                  ? Colors.orange
                                  : Colors.green),
                    ),
                  ),
                  // const SizedBox(width: 60)
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();

    return records;
  }

  String beautyDate(DateTime consumptionTime) {
    int day1 = consumptionTime.day;
    String day = day1 < 10 ? '0$day1' : '$day1';
    day1 = consumptionTime.month;
    String month = day1 < 10 ? '0$day1' : '$day1';

    return '$day/$month/${consumptionTime.year}';
  }

  String beatyHour(DateTime consumptionTime) {
    int day1 = consumptionTime.hour;
    String hour = day1 < 10 ? '0$day1' : '$day1';
    day1 = consumptionTime.minute;
    String minute = day1 < 10 ? '0$day1' : '$day1';
    return '$hour:$minute';
  }
}