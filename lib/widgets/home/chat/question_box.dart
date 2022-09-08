import 'dart:ui';

import 'package:dashboard_doctors/colors.dart';
import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionBox extends StatelessWidget {
  const QuestionBox({
    Key? key,
    /* required this.question,*/ required this.text,
    required this.isChat,
    required this.isDoctor,
    required this.time,
  }) : super(key: key);

  // final Question question;
  final String text;
  final bool isChat;
  final bool isDoctor;
  final String time;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    Locale myLocale = window.locale;

    return Column(
      mainAxisSize: MainAxisSize.max,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              color: isDoctor
                  ? /*Colors.lightBlue[900]*/ HexaColor('#4E7AC7')
                  : HexaColor("#EBEBEB"),
              borderRadius: BorderRadius.circular(16),
            ),
            constraints: BoxConstraints(
              maxWidth: isChat ? 366.w * 0.65 : size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            alignment: !isChat
                ? myLocale.languageCode == 'he'
                    ? Alignment.centerRight
                    : Alignment.centerLeft
                : isDoctor
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            // myLocale.languageCode == 'he'
            //     ? Alignment.centerRight
            //     : Alignment.centerLeft,
            child: Text(
              text,
              style: TextStyle(
                  color: isDoctor ? Colors.white : Colors.black, fontSize: 12),
              //textAlign: isDoctor ? TextAlign.right : TextAlign.left,
            )),
        // Container(
        //   color: Colors.red,
        //   child: Align(
        //     alignment:Alignment.centerLeft,
        //     child: Text('data',style: TextStyle(color: HexaColor('#838383'),
        //         fontSize: 10),textAlign: TextAlign.left)
        //   ),
        // )
        Container(
          padding: EdgeInsets.only(top: 7.h),
          constraints: BoxConstraints(
            maxWidth: isChat ? 366.w * 0.65 : size.width * 0.7,
          ),
          child: Align(
              child: Text(time,
                  style: TextStyle(color: HexaColor('#838383'), fontSize: 10),
              textAlign: TextAlign.left),
              alignment:isDoctor? Alignment.centerLeft: Alignment.centerRight),
        )
      ],
    );
  }
}
