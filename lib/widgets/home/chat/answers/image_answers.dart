import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:flutter/material.dart';


class ImageAnswers extends StatelessWidget {
  const ImageAnswers({
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
    //final Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: answers
                .map(
                  (AnswerAndImage answer) => ImageAnswer(
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
        ),
      ],
    );
  }
}

class ImageAnswer extends StatelessWidget {
  const ImageAnswer({
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
  final bool isTappable;
  final Function getAnswer;
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
            height: 50,
            width: 50,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
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
