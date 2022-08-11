import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:dashboard_doctors/widgets/home/chat/bubble_image.dart';
import 'package:dashboard_doctors/widgets/home/chat/question_box.dart';
import 'package:flutter/material.dart';


class QuestionChatBubble extends StatelessWidget {
  const QuestionChatBubble({Key? key, required this.question})
      : super(key: key);

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const BubbleImage(isLeema: true),
          const SizedBox(width: 10),
          QuestionBox(question: question),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
