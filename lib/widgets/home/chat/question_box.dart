import 'dart:ui';

import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:flutter/material.dart';


class QuestionBox extends StatelessWidget {
  const QuestionBox({Key? key, required this.question}) : super(key: key);

  final Question question;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    Locale myLocale = window.locale;

    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue[900],
        borderRadius: BorderRadius.circular(20),
      ),
      constraints: BoxConstraints(
        maxWidth: size.width * 0.7,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      alignment: myLocale.languageCode == 'he'
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Text(
        question.question,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
