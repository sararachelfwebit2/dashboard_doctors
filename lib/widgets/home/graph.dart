import 'package:dashboard_doctors/screens/home/intakeStatisticsScreen.dart';
import 'package:dashboard_doctors/widgets/home/measures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../animations/fade_transition.dart';


class GraphsGrid extends StatelessWidget {
  const GraphsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GraphContainer(
                icon: 'running',
                text: AppLocalizations.of(context)!.physicalStatistics),
            GraphContainer(
                icon: 'cannabis',
                text: AppLocalizations.of(context)!.consumptionTracking),
          ],
        ),
      ],
    );
  }
}

class GraphContainer extends StatelessWidget {
  const GraphContainer({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        //todo
        if (icon == 'cannabis') {
          Navigator.of(context)
              .push(FadeTransiton(const IntakeStatisticsScreen(), 300));
        } else {
          // Navigator.of(context).push(FadeTransiton(const MedicalData(), 300));
          Navigator.of(context).push(FadeTransiton( Measure(), 300));
        }
      },
      child: Container(
        height: size.width * 0.12,
        width: size.width * 0.12,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 1), blurRadius: 10)
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 20,
                width: 20,
                child: Image.asset('assets/icons/$icon.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Assistant',
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 100,
                    child: Image.asset('assets/icons/graph.png'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}