import 'package:dashboard_doctors/widgets/home/records/intake_record_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../models/questionnaire.dart';
import 'package:ndialog/ndialog.dart';
import 'dart:convert';

class RecordsGrid extends StatefulWidget {
  const RecordsGrid({
    Key? key,
    required this.records,
  }) : super(key: key);

  final List<Record> records;

  @override
  State<RecordsGrid> createState() => _RecordsGridState();
}

bool isPopupShown = false;

class _RecordsGridState extends State<RecordsGrid> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: widget.records.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: () async {
                String content = "";
                String json = widget.records[index].answers.toString();
                json = json.substring(1);
                json = json.substring(0, json.length - 1);

                List<String> listAnswers = json.split(",");

                for (int a = 0; a < listAnswers.length; a++) {
                  int pos = listAnswers[a].indexOf("?:");
                  String question = listAnswers[a].substring(0, pos + 2);

                  String answer =
                      listAnswers[a].substring(pos + 2, listAnswers[a].length);

                  content += "$question $answer\n\n";
                }

                await NDialog(
                  dialogStyle: DialogStyle(
                    titleDivider: true,
                    backgroundColor: Colors.blue,
                  ),
                  title: Text(widget.records[index].questionnaireName,
                      style: const TextStyle(
                        color: Colors.white,
                      )),
                  content: Text(content,
                      style: const TextStyle(
                        color: Colors.white,
                      )),
                  actions: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.transparent,
                        shape: BoxShape.rectangle,
                      ),
                      child: TextButton(
                          child: const Text("סגירה",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                  ],
                ).show(context);
              },
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    )),
                height: screenSize.height * 50 / 601,
                child: Column(children: [
                  Text(
                    widget.records[index].questionnaireName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenSize.height * 10 / 601),
                  Text(
                    widget.records[index].date,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ]),
              ),
            ),
          );
        });
  }
}
