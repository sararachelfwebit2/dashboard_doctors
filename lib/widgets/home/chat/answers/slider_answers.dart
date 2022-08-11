import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';


class SliderAnswers extends StatefulWidget {
  const SliderAnswers({
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
  State<SliderAnswers> createState() => _SliderAnswersState();
}

class _SliderAnswersState extends State<SliderAnswers> {
  double sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    final answer = widget.answers.first.answer;
    sliderValue = double.parse(answer.substring(0, answer.indexOf('-')));
  }

  @override
  Widget build(BuildContext context) {
    final answer = widget.answers.first.answer;

    final max =
        double.parse(answer.substring(answer.indexOf('-') + 1, answer.length));
    final min = double.parse(answer.substring(0, answer.indexOf('-')));

    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.6,
      child: SfSlider(
        min: min,
        max: max,
        value: sliderValue,
        interval: 1,
        showTicks: true,
        showLabels: true,
        enableTooltip: true,
        minorTicksPerInterval: 0,
        onChanged: (dynamic value) {
          setState(() {
            sliderValue = value.toInt().toDouble();
            widget.getAnswer(sliderValue, widget.question);
          });
        },
      ),
    );
  }
}
