import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:flutter/material.dart';


class TextAnswers extends StatelessWidget {
  const TextAnswers({
    Key? key,
    required this.answers,
    required this.chosenAnswers,
    required this.getAnswer,
    required this.question,
    required this.isTappable,
  }) : super(key: key);

  final List<AnswerAndImage> answers;
  final Map<String, dynamic> chosenAnswers;
  final Function getAnswer;
  final String question;
  final bool isTappable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: answers
          .map(
            (answer) => TextAnswer(
              answer: answer.answer,
              chosenAnswers: chosenAnswers,
              getAnswer: getAnswer,
              question: question,
              isTappable: isTappable,
            ),
          )
          .toList(),
    );
  }
}

class TextAnswer extends StatelessWidget {
  const TextAnswer({
    Key? key,
    required this.answer,
    required this.chosenAnswers,
    required this.getAnswer,
    required this.question,
    required this.isTappable,
  }) : super(key: key);

  final String answer;
  final bool isTappable;
  final String question;
  final Function getAnswer;
  final Map<String, dynamic> chosenAnswers;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          if (isTappable) {
            getAnswer(answer, question);
          }
        },
        child: Row(
          children: [
            Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: chosenAnswers.containsKey(question) &&
                        chosenAnswers[question] == answer
                    ? Colors.grey[800]
                    : Colors.grey[300],
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              answer,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
