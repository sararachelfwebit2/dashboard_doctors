import 'package:dashboard_doctors/widgets/home/records/intake_record_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../models/questionnaire.dart';


class RecordsGrid extends StatefulWidget {
  const RecordsGrid({
    Key? key,
    required this.records,
  }) : super(key: key);

  final List<Record>  records;

  @override
  State<RecordsGrid> createState() => _RecordsGridState();
}

class _RecordsGridState extends State<RecordsGrid> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AnimationLimiter(
        child: GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 2,
          // mainAxisSpacing:20,
          //   mainAxisSpacing: 10,
          children: List.generate(
            widget.records.length,
            (int i) {
              return AnimationConfiguration.staggeredGrid(
                position: i,
                duration: const Duration(milliseconds: 800),
                columnCount: 2,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: IntakeRecordContainer(
                      record: widget.records![i],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
