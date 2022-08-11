import 'dart:io';
import 'dart:ui';

import 'package:dashboard_doctors/widgets/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/error_dialog.dart';


class IntakeStatisticsScreen extends StatelessWidget {
  const IntakeStatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale myLocale = window.locale;

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
          iconSize: 25,
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                // if (Platform.isIOS) {
                //   showCupertinoDialog(
                //     context: context,
                //     builder: (ctx) => ErrorDialog(
                //       text: myLocale.languageCode == 'he'
                //           ? 'במסך זה תוכלו לראות המוצרים שצרכתם ואת השפעתם עליכם בהתאם לתיעוד שסימנתם. לא ניתן לשנות את התיעוד לאחר הצריכה.'
                //           : 'In this screen you can see the products you have consumed and their effect on you according to the documentation you have marked. The documentation cannot be changed after consumption.',
                //       title: AppLocalizations.of(context)!.consumptionTracking,
                //     ),
                //   );
                // } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => ErrorDialog(
                      text: myLocale.languageCode == 'he'
                          ? 'במסך זה תוכלו לראות המוצרים שצרכתם ואת השפעתם עליכם בהתאם לתיעוד שסימנתם. לא ניתן לשנות את התיעוד לאחר הצריכה.'
                          : 'In this screen you can see the products you have consumed and their effect on you according to the documentation you have marked. The documentation cannot be changed after consumption.',
                      title: AppLocalizations.of(context)!.consumptionTracking,
                    ),
                  );
               // }
              },
              color: Colors.white,
              icon:
              const ImageIcon(AssetImage('assets/icons/question-mark.png')),
            ),
          ),
        ],
        backgroundColor: Colors.lightBlue[900],
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.intakeRecords,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // body: const Calender(),
      //todo
      body: Container(),
    );
  }
}