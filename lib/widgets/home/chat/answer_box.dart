import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:dashboard_doctors/widgets/home/chat/answers/buttons_answers.dart';
import 'package:dashboard_doctors/widgets/home/chat/answers/emoji_answers.dart';
import 'package:dashboard_doctors/widgets/home/chat/answers/image_answers.dart';
import 'package:dashboard_doctors/widgets/home/chat/answers/multi_select_answers.dart';
import 'package:dashboard_doctors/widgets/home/chat/answers/number_answer.dart';
import 'package:dashboard_doctors/widgets/home/chat/answers/slider_answers.dart';
import 'package:dashboard_doctors/widgets/home/chat/answers/text_answers.dart';
import 'package:dashboard_doctors/widgets/home/chat/answers/text_field_answers.dart';
import 'package:flutter/material.dart';


class AnswerBox extends StatelessWidget {
  const AnswerBox({
    Key? key,
    required this.question,
    required this.chosenAnswers,
    required this.getAnswer,
    required this.controller,
    required this.isGrams,
    required this.isTappable,
  }) : super(key: key);

  final Question question;
  final Function getAnswer;
  final TextEditingController controller;
  final Map<String, dynamic> chosenAnswers;
  final bool isGrams;
  final bool isTappable;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.center,
      child: question.anwersType == 'Emoji'
          ? EmojiAnswers(
              answers: question.answersAndImages,
              isAsset: question.isAssetsAnswers,
              chosenAnswers: chosenAnswers,
              getAnswer: getAnswer,
              question: question.question,
              isTappable: isTappable,
            )
          : question.anwersType == 'Image'
              ? ImageAnswers(
                  answers: question.answersAndImages,
                  isAsset: question.isAssetsAnswers,
                  chosenAnswers: chosenAnswers,
                  getAnswer: getAnswer,
                  question: question.question,
                  isTappable: isTappable,
                )
              : question.anwersType == 'Text'
                  ? TextAnswers(
                      answers: question.answersAndImages,
                      chosenAnswers: chosenAnswers,
                      getAnswer: getAnswer,
                      question: question.question,
                      isTappable: isTappable,
                    )
                  : question.anwersType == 'TextField'
                      ? TextFieldAnswer(
                          textEditingController: controller,
                          getAnswer: getAnswer,
                          question: question.question,
                          isTappable: isTappable,
                        )
                      : question.anwersType == 'Number'
                          ? NumberAnswer(
                              getAnswer: getAnswer,
                              question: question.question,
                              isGrams: isGrams,
                              isTappable: isTappable,
                              initialNumberGrams: isTappable
                                  ? null
                                  : double.parse(chosenAnswers[
                                          question.question] ??
                                      chosenAnswers[
                                          'How much are you currenty consuming?'] ??
                                      chosenAnswers['מהי הכמות הנצרכת?']!),
                              initialNumberTaps: isTappable
                                  ? null
                                  : double.parse(chosenAnswers[
                                              question.question] ??
                                          chosenAnswers[
                                              'How much are you currenty consuming?'] ??
                                          chosenAnswers['מהי הכמות הנצרכת?']!)
                                      .toInt(),
                            )
                          : question.anwersType == 'Buttons'
                              ? ButtonAnswers(
                                  getAnswer: getAnswer,
                                  question: question.question,
                                  chosenAnswers: chosenAnswers,
                                  isTappable: isTappable,
                                )
                              : question.anwersType == 'MultiSelect'
                                  ? MultiSelectAnswers(
                                      answers: question.answersAndImages,
                                      chosenAnswers: chosenAnswers,
                                      getAnswer: getAnswer,
                                      question: question.question,
                                      isTappable: isTappable,
                                    )
                                  : question.anwersType == 'Slider'
                                      ? SliderAnswers(
                                          answers: question.answersAndImages,
                                          chosenAnswers: chosenAnswers,
                                          getAnswer: getAnswer,
                                          question: question.question,
                                          isTappable: isTappable,
                                        )
                                      : Container(),
    );
  }
}
