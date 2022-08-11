import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:flutter/material.dart';


class MultiSelectAnswers extends StatefulWidget {
  const MultiSelectAnswers({
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
  State<MultiSelectAnswers> createState() => _MultiSelectAnswersState();
}

class _MultiSelectAnswersState extends State<MultiSelectAnswers> {
  List<String> answers = [];

  void toggleAnswer(String answer) {
    if (answers.contains(answer)) {
      answers.remove(answer);
    } else {
      answers.add(answer);
    }

    print(answers);

    widget.getAnswer(answers, widget.question);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.answers
          .map(
            (answer) => TextAnswer(
              answer: answer.answer,
              chosenAnswers: widget.chosenAnswers,
              getAnswer: widget.getAnswer,
              question: widget.question,
              isTappable: widget.isTappable,
              toggleAnswer: toggleAnswer,
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
    required this.toggleAnswer,
  }) : super(key: key);

  final String answer;
  final bool isTappable;
  final String question;
  final Function getAnswer;
  final Function toggleAnswer;
  final Map<String, dynamic> chosenAnswers;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          if (isTappable) {
            toggleAnswer(answer);
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
                        chosenAnswers[question].contains(answer)
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
