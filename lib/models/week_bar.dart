import 'package:flutter/material.dart';

class WeekBar {
  double thc;
  double cbd;
  int? heartbeatRate;
  int? sleepRate;
  int? steps;
  final DateTimeRange dateTime;
  int amountRecords = 1;

  WeekBar(
    this.thc,
    this.cbd,
    this.heartbeatRate,
    this.sleepRate,
    this.steps,
    this.dateTime,
  );
}
