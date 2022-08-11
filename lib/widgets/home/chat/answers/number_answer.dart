import 'package:dashboard_doctors/widgets/picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class NumberAnswer extends StatefulWidget {
  const NumberAnswer({
    Key? key,
    required this.getAnswer,
    required this.question,
    required this.isGrams,
    required this.isTappable,
    required this.initialNumberGrams,
    required this.initialNumberTaps,
  }) : super(key: key);

  final Function getAnswer;
  final String question;
  final bool isGrams;
  final bool isTappable;
  final double? initialNumberGrams;
  final int? initialNumberTaps;

  @override
  State<NumberAnswer> createState() => _NumberAnswerState();
}

class _NumberAnswerState extends State<NumberAnswer> {
  final List<String> amountList = [];

  double pickedValue = 0.0;
  int value = 0;

  void getPickedValue(int val, parameter) {
    if (widget.isGrams) {
      double newVal = (val / 10) + 0.1;

      setState(() {
        pickedValue = newVal;
      });
    } else {
      setState(() {
        value = val + 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialNumberGrams != null) {
      pickedValue = widget.initialNumberGrams!;
    }
    if (widget.initialNumberTaps != null) {
      value = widget.initialNumberTaps!;
    }
  }

  @override
  Widget build(BuildContext context) {
    //  final Size size = MediaQuery.of(context).size;

    return TextButton(
      onPressed: () {
        HapticFeedback.mediumImpact();

        if (widget.isTappable) {
          setState(() {
            amountList.clear();
            if (widget.isGrams) {
              for (var g = 0.1; g < 2.1; g += 0.1) {
                amountList.add(g.toStringAsFixed(1));
              }
            } else {
              for (var g = 1; g < 11; g++) {
                amountList.add(g.toString());
              }
            }
          });

          showModalBottomSheet(
            context: context,
            builder: (ctx) => MyCupertinoPicker(
              onChanged: getPickedValue,
              pickerType: 'Weight', // witch is actully the numbers picker
              weightList: amountList,
            ),
          ).whenComplete(() {
            widget.getAnswer(
                widget.isGrams
                    ? pickedValue.toStringAsFixed(1)
                    : value.toStringAsFixed(1),
                widget.question);
          });
        }
      },
      child: Row(
        children: [
          Column(
            children: [
              Text(
                widget.isGrams
                    ? pickedValue.toStringAsFixed(1)
                    : value.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Text(
                widget.isGrams
                    ? AppLocalizations.of(context)!.grams
                    : AppLocalizations.of(context)!.drops,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]!, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                    'assets/icons/${widget.isGrams ? 'weed' : 'oil'}.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
