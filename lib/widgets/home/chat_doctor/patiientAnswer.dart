import 'package:dashboard_doctors/widgets/home/chat/bubble_image.dart';
import 'package:dashboard_doctors/widgets/home/chat/question_box.dart';
import 'package:flutter/material.dart';

class PatientAnswer extends StatelessWidget {
  const PatientAnswer({
    Key? key,
    required this.text, required this.imageUrl, required this.time,
  //  required this.chosenAnswers,
   // required this.getAnswer,
   // required this.question,
   // required this.isTappable,
  }) : super(key: key);

  final String text;
  final String imageUrl;
  final String time;
 // final bool isTappable;
 // final String question;
  //final Function getAnswer;
 // final Map<String, dynamic> chosenAnswers;

  @override
  Widget build(BuildContext context) {

       return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Directionality(
        textDirection:TextDirection.ltr ,
        child: Row(
          children: [
             BubbleImage(isLeema: false,imageUrl:imageUrl ),
            const SizedBox(width: 10),
            QuestionBox(text:text,isChat:true,isDoctor: false,time: time),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
    //  return Container(
    //     decoration: BoxDecoration(
    //     color: Colors.grey[300],
    //     borderRadius: BorderRadius.circular(20),
    // ),
    // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    // alignment: Alignment.center,child:
    //   Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 5.0),
    //   child: Row(
    //     children: [
    //       Container(
    //         height: 20,
    //         width: 20,
    //         alignment: Alignment.center,
    //         decoration: BoxDecoration(
    //           shape: BoxShape.circle,
    //           color:/* chosenAnswers.containsKey(question) &&
    //               chosenAnswers[question] == text
    //               ? Colors.grey[800]
    //               : */ Colors.grey[300],
    //           border: Border.all(color: Colors.white, width: 3),
    //         ),
    //       ),
    //       const SizedBox(width: 10),
    //       Text(
    //         text,
    //         style: const TextStyle(
    //           color: Colors.black,
    //           fontSize: 14,
    //         ),
    //       ),
    //     ],
    //   ),
    // ));
  }
}