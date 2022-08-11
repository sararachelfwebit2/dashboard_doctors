import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class EmojiAnswers extends StatelessWidget {
  const EmojiAnswers({
    Key? key,
    required this.answers,
    required this.isAsset,
    required this.chosenAnswers,
    required this.getAnswer,
    required this.question,
    required this.isTappable,
  }) : super(key: key);

  final List<AnswerAndImage> answers;
  final Map<String, dynamic> chosenAnswers;
  final Function getAnswer;
  final String question;
  final bool isAsset;
  final bool isTappable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.intakeQuestionExplain,
          style: const TextStyle(
            color: Colors.black,
            //fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: answers
              .map(
                (answer) => EmojiAnswer(
                  answer: answer.answer,
                  answerImage: answer.image ?? '',
                  chosenAnswers: chosenAnswers,
                  getAnswer: getAnswer,
                  question: question,
                  isAsset: isAsset,
                  isTappable: isTappable,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class EmojiAnswer extends StatelessWidget {
  const EmojiAnswer({
    Key? key,
    required this.answer,
    required this.answerImage,
    required this.isAsset,
    required this.question,
    required this.chosenAnswers,
    required this.getAnswer,
    required this.isTappable,
  }) : super(key: key);

  final String answer;
  final String question;
  final String answerImage;
  final bool isAsset;
  final Function getAnswer;
  final bool isTappable;
  final Map<String, dynamic> chosenAnswers;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isTappable) {
          getAnswer(answer, question);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 25,
            width: 25,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: isAsset
                      ? AssetImage('assets/emoji/$answerImage.png')
                      : NetworkImage(answerImage) as ImageProvider),
            ),
          ),
          Text(
            answer,
            style: TextStyle(
              color: chosenAnswers.containsKey(question) &&
                      chosenAnswers[question] == answer
                  ? Colors.black
                  : Colors.grey[500],
              fontWeight: chosenAnswers.containsKey(question) &&
                      chosenAnswers[question] == answer
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
