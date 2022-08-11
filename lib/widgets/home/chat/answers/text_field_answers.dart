import 'package:flutter/material.dart';

class TextFieldAnswer extends StatelessWidget {
  const TextFieldAnswer({
    Key? key,
    required this.getAnswer,
    required this.question,
    required this.textEditingController,
    required this.isTappable,
  }) : super(key: key);

  final Function getAnswer;
  final TextEditingController textEditingController;
  final String question;
  final bool isTappable;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.5,
      child: TextField(
        onSubmitted: (val) {
          if (isTappable) {
            getAnswer(val == '' ? 'ללא' : val, question);
          }
        },
        onChanged: (val) {
          if (isTappable) {
            getAnswer(val == '' ? 'ללא' : val, question);
          }
        },
        decoration: const InputDecoration(
          hintText: 'הקלד את תשובתך כאן...',
          // errorStyle: TextStyle(color: Colors.red, fontSize: 12),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        textInputAction: TextInputAction.done,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }
}
