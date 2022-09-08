import 'package:dashboard_doctors/colors.dart';
import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:dashboard_doctors/widgets/home/chat/bubble_image.dart';
import 'package:dashboard_doctors/widgets/home/chat/question_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class QuestionChatBubble extends StatelessWidget {
  const QuestionChatBubble({Key? key, required this.text, required this.time/* required this.question*/ })
      : super(key: key);

 // final Question question;
 final String text;
 final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 13.h),
      child: Column(
        children: [
          Row(
            children: [
              const BubbleImage(isLeema: true),
              const SizedBox(width: 10),
              QuestionBox(text:text,isChat:true,isDoctor: true,time:time),
              const Expanded(child: SizedBox()),
            ],
          ),
         // Align(child: time!=""? Text(time):Container(),
         // alignment: Alignment.centerLeft)
        ],
      ),
    );
  }
}
