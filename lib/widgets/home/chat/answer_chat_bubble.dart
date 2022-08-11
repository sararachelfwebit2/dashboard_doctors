import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:dashboard_doctors/widgets/home/chat/answer_box.dart';
import 'package:dashboard_doctors/widgets/home/chat/answers/pick_product.dart';
import 'package:dashboard_doctors/widgets/home/chat/bubble_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class AnswerChatBubble extends StatelessWidget {
  const AnswerChatBubble({
    Key? key,
    required this.question,
    required this.getAnswer,
    required this.isGrams,
    required this.isTappable,
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
    // final userProvider = Provider.of<UserStats>(context, listen: false);

    return question.anwersType == 'PickProduct'
        ? PickProduct(
            chosenAnswers: chosenAnswers,
            getAnswer: getAnswer,
            question: question.question,
            isTappable: isTappable,
            refresh: refresh,
          )
    // Container(child: ,)
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                AnswerBox(
                  question: question,
                  getAnswer: getAnswer,
                  chosenAnswers: chosenAnswers,
                  controller: textEditingController,
                  isGrams: isGrams,
                  isTappable: isTappable,
                ),
                const SizedBox(width: 10),
                BubbleImage(isLeema: false/*, imageUrl: userProvider.imageUrl*/),
              ],
            ),
          );
  }
}
