import 'dart:ui';

import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:dashboard_doctors/widgets/home/chat/chat_bubble.dart';
import 'package:flutter/material.dart';


class IntakeRecord extends StatefulWidget {
  const IntakeRecord({
    Key? key,
    required this.record,
  }) : super(key: key);

  final Record record;

  @override
  State<IntakeRecord> createState() => _IntakeRecordState();
}

class _IntakeRecordState extends State<IntakeRecord> {
  final List<Question> conversation = [];

  final int index = 0;

  void getConversation() {
    Locale myLocale = window.locale;

    conversation.addAll([
      Question(
        question: myLocale.languageCode == 'he'
            ? 'מה חומרת הסימפטומים שלך לפני הצריכה?'
            : 'How severe your symptoms prior to consuming cannabis?',
        answer: '',
        answers: [],
        scores: [],
        delay: 800,
        anwersType: 'Emoji',
        isAssetsAnswers: true,
        questionnaireIds: [],
        answersAndImages: [
          AnswerAndImage(answer: '1', image: 'terrible'),
          AnswerAndImage(answer: '2', image: 'very-bad'),
          AnswerAndImage(answer: '3', image: 'not-good'),
          AnswerAndImage(answer: '4', image: 'average'),
          AnswerAndImage(answer: '5', image: 'good'),
        ],
        answersImages: [],
      ),
      // Question(
      //   question: myLocale.languageCode == 'he'
      //       ? 'מה המוצר הנצרך?'
      //       : 'What product are you currently consuming?',
      //   answer: '',
      //   answers: [],
      //   scores: [],
      //   delay: 800,
      //   anwersType: 'PickProduct',
      //   isAssetsAnswers: false,
      //   questionnaireIds: [],
      //   answersAndImages: [],
      //   answersImages: [],
      // ),
      Question(
        question: myLocale.languageCode == 'he'
            ? 'מהי הכמות הנצרכת?'
            : 'How much are you currently consuming?',
        answer: '',
        answers: [],
        scores: [],
        delay: 800,
        anwersType: 'Number',
        isAssetsAnswers: false,
        questionnaireIds: [],
        answersAndImages: [],
        answersImages: [],
      ),
      Question(
        question: myLocale.languageCode == 'he'
            ? 'מה חומרת הסימפטומים לאחר הצריכה?'
            : 'How severe your symptoms after consuming cannabis?',
        answer: '',
        answers: [],
        scores: [],
        delay: 800,
        anwersType: 'Emoji',
        isAssetsAnswers: true,
        questionnaireIds: [],
        answersAndImages: [
          AnswerAndImage(answer: '1', image: 'terrible'),
          AnswerAndImage(answer: '2', image: 'very-bad'),
          AnswerAndImage(answer: '3', image: 'not-good'),
          AnswerAndImage(answer: '4', image: 'average'),
          AnswerAndImage(answer: '5', image: 'good'),
        ],
        answersImages: [],
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    getConversation();
  }

  // created just to show the chat bubble, has no use
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.85,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
            children: conversation
                .map((Question question) => ChatBubble(
                      question: question,
                      refresh: () {},
                      getAnswer: () {},
                      isTappable: false,
                      chosenAnswers: widget.record.answers,
                      textEditingController: controller,
                      isGrams: widget.record.isGrams,
                    ))
                .toList()),
      ),
    );
  }
}
