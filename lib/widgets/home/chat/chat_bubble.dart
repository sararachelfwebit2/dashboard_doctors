import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:dashboard_doctors/widgets/home/chat/answer_chat_bubble.dart';
import 'package:dashboard_doctors/widgets/home/chat/question_chat_bubble.dart';
import 'package:flutter/material.dart';



class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.question,
    required this.isGrams,
    required this.isTappable,
    required this.getAnswer,
    required this.chosenAnswers,
    required this.textEditingController,
    required this.refresh,
  }) : super(key: key);

  final Question question;
  final Function getAnswer;
  final Function refresh;
  final Map<String, dynamic> chosenAnswers;
  final TextEditingController textEditingController;
  final bool isGrams;
  final bool isTappable;

  @override
  Widget build(BuildContext context) {
    return question.question == ''
        ? Container()
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QuestionChatBubble(text: question.question,time: "",),
              if (question.anwersType != 'None')
                AnswerChatBubble(
                  question: question,
                  isGrams: isGrams,
                  refresh: refresh,
                  isTappable: isTappable,
                  getAnswer: getAnswer,
                  chosenAnswers: chosenAnswers,
                  textEditingController: textEditingController,
                ),
            ],
          );
  }
}
