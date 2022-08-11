import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonAnswers extends StatelessWidget {
  const ButtonAnswers({
    Key? key,
    required this.getAnswer,
    required this.question,
    required this.chosenAnswers,
    required this.isTappable,
  }) : super(key: key);

  final Function getAnswer;
  final String question;
  final bool isTappable;
  final Map<String, dynamic> chosenAnswers;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnswerButton(
          text: AppLocalizations.of(context)!.now,
          question: question,
          onPressed: () {
            if (isTappable) {
              getAnswer(AppLocalizations.of(context)!.now, question);
            }
          },
          chosenAnswers: chosenAnswers,
        ),
        AnswerButton(
          text: AppLocalizations.of(context)!.reminedMeLater,
          question: question,
          onPressed: () {
            if (isTappable) {
              getAnswer(AppLocalizations.of(context)!.reminedMeLater, question);
            }
          },
          chosenAnswers: chosenAnswers,
        ),
      ],
    );
  }
}

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    Key? key,
    required this.text,
    required this.question,
    required this.onPressed,
    required this.chosenAnswers,
  }) : super(key: key);

  final String text;
  final String question;
  final Function onPressed;
  final Map<String, dynamic> chosenAnswers;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      child: Container(
        width: 80,
        height: 60,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: chosenAnswers.containsKey(question) &&
                  chosenAnswers[question] == text
              ? Colors.blue[500]
              : Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: chosenAnswers.containsKey(question) &&
                    chosenAnswers[question] == text
                ? Colors.white
                : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
