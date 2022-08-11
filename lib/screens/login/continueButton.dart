import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton(
      {Key? key, required this.onPressed, required this.buttonText})
      : super(key: key);

  final Function onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.65,
      height: 55,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(188, 44, 100, 197),
            Color.fromARGB(188, 44, 100, 197),
          ],
        ),
      ),
      // border: Border.all(color: Colors.blue[900]!)),
      child: TextButton(
        onPressed: () {
          onPressed();
        },
        child: Container(
          width: size.width * 0.65,
          height: 55,
          alignment: Alignment.center,
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Assistant',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
