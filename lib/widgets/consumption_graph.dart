import 'dart:ui' as ui;

import 'package:dashboard_doctors/models/week_bar.dart';
import 'package:dashboard_doctors/services/garmin_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/bar.dart';

class ConsumptionChart extends StatefulWidget {
  final int duration;
  final double? height;
  final List<Bar> bars;
  final List<DateTime> presentWeek;
  final Function setClickedBar;

  const ConsumptionChart({
    Key? key,
    required this.duration,
    this.height,
    required this.bars,
    required this.presentWeek,
    required this.setClickedBar,
  }) : super(key: key);

  @override
  State<ConsumptionChart> createState() => _ConsumptionChartState();
}

enum Option { heaertRate, sleepRate, steps }

class _ConsumptionChartState extends State<ConsumptionChart> {
  final int marginStart = 27;
  final int spaceBetweenThcCbd = 2;
  final int spaceForXAxis = 10;
  final int marginTopHeight = 20;

  bool showTollTip = false;

  double dxToolTip = 0;
  double dyToolTip = 0;
  double toolTipWidth = 120;
  double toolTipHeight = 90;

  late Bar clickedBar;

  ui.Image? heartImage;
  ui.Image? sleepImage;
  ui.Image? stepsImage;

  Option chosenOption = Option.heaertRate;

  TextStyle textStyle = const TextStyle(
    fontFamily: 'NunitoSans',
    fontSize: 12,
  );

  // List<Option> options = [];

  @override
  void initState() {
    loadImage('heartbeat', 'assets/icons/heartbeat1.png');
    loadImage('sleeprate', 'assets/icons/sleeprate.png');
    loadImage('steps', 'assets/icons/steps.png');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final garminServices = Provider.of<GarminServices>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    // double width = size.width - 70;
    // double height = widget.height ?? width;
    // double width = size.width * 0.5;
    double width = size.width * 0.25;
    // double height = widget.height ?? size.height*0.3;
    double height = widget.height ?? size.height*0.5;
    final double tickWidth = (width - 45) / 7;
    final double strokeWidth = tickWidth / 2 * 0.6;

    bool isHebrew = AppLocalizations.of(context)!.languageName == 'Hebrew';


    bool hasHeartbeat =
        widget.bars.any((element) => element.heartbeatRate != null);

    bool hasSleeprate = widget.bars.any((element) => element.sleepRate != null);

    bool hasSteps = widget.bars.any((element) => element.steps != null);

    return heartImage == null || sleepImage == null || stepsImage == null
        ? SizedBox(
            width: width,
            height: height,
          )
        : Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Row(
                textDirection:
                    isHebrew ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasHeartbeat)
                    SizedBox(
                      height: 30,
                      width: 130,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: Option.heaertRate,
                            groupValue: chosenOption,
                            onChanged: (val) {
                              if (val != null) {
                                chosenOption = val as Option;
                                setState(() {});
                              }
                            },
                          ),
                          Text(
                            garminServices.garminSentences['RestingHr'] ?? '',
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  if (hasSleeprate)
                    SizedBox(
                      height: 30,
                      width: 118,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: Option.sleepRate,
                            groupValue: chosenOption,
                            onChanged: (val) {
                              if (val != null) {
                                chosenOption = val as Option;
                                setState(() {});
                              }
                            },
                          ),
                          Text(
                            garminServices.garminSentences['SleepScore'] ?? '',
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  if (hasSteps)
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: Option.steps,
                            groupValue: chosenOption,
                            onChanged: (val) {
                              if (val != null) {
                                chosenOption = val as Option;
                                setState(() {});
                              }
                            },
                          ),
                          Text(
                            garminServices.garminSentences['Steps'] ?? '',
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: height,
                width: width,
                child: GestureDetector(
                  onTapDown: (w) => onTapDown(w, width, height, tickWidth),
                  onTapUp: (details) {
                    showTollTip = false;
                    setState(() {});
                  },
                  onVerticalDragEnd: (details) {
                    showTollTip = false;
                    setState(() {});
                  },
                  onHorizontalDragEnd: (details) {
                    showTollTip = false;
                    setState(() {});
                  },
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(width, height),
                        painter: ChartPainter(
                          containerSize: Size(width, height),
                          bars: widget.bars,
                          duration: widget.duration,
                          heartImage: heartImage!,
                          sleepImage: sleepImage!,
                          stepsImage: stepsImage!,
                          presentWeek: widget.presentWeek,
                          marginStart: marginStart,
                          spaceBetweenThcCbd: spaceBetweenThcCbd,
                          tickWidth: tickWidth,
                          strokeWidth: strokeWidth,
                          spaceForXAxis: spaceForXAxis,
                          marginTopHeight: marginTopHeight,
                          chosenValue: chosenOption,
                          context: context,
                        ),
                      ),
                      if (showTollTip)
                        Positioned(
                          left: dxToolTip + toolTipWidth > width
                              ? null
                              : dxToolTip,
                          right: dxToolTip + toolTipWidth > width
                              ? width - dxToolTip
                              : null,
                          bottom: dyToolTip - toolTipHeight < 0
                              ? null
                              : height - dyToolTip,
                          top: dyToolTip - toolTipHeight < 0 ? dyToolTip : null,
                          child: Container(
                            width: toolTipWidth,
                            // height: toolTipHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withOpacity(0.8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'thc: ${clickedBar.thc.roundToDouble() == clickedBar.thc ? clickedBar.thc.round() : clickedBar.thc.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'NunitoSans',
                                  ),
                                ),
                                Text(
                                  'cbd: ${clickedBar.cbd.roundToDouble() == clickedBar.cbd ? clickedBar.cbd.round() : clickedBar.cbd.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'NunitoSans',
                                  ),
                                ),
                                if (clickedBar.sleepRate != null)
                                  Text(
                                    '${garminServices.garminSentences['SleepScore'] ?? ''}: ${clickedBar.sleepRate}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'NunitoSans',
                                    ),
                                  ),
                                if (clickedBar.heartbeatRate != null)
                                  Text(
                                    '${garminServices.garminSentences['RestingHr'] ?? ''}: ${clickedBar.heartbeatRate}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'NunitoSans',
                                    ),
                                  ),
                                if (clickedBar.steps != null)
                                  Text(
                                    '${garminServices.garminSentences['Steps'] ?? ''}: ${clickedBar.steps}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'NunitoSans',
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  loadImage(String name, String icon) async {
    if (name == 'heartbeat') {
      heartImage = await decodeImageFromList(
          (await rootBundle.load(icon)).buffer.asUint8List());
    } else if (name == 'sleeprate') {
      sleepImage = await decodeImageFromList(
          (await rootBundle.load(icon)).buffer.asUint8List());
    } else if (name == 'steps') {
      stepsImage = await decodeImageFromList(
          (await rootBundle.load(icon)).buffer.asUint8List());
    }
    setState(() {});
  }

  void onTapDown(
      TapDownDetails details, double width, double height, double tickWidth) {
    final double strokeWidth = tickWidth / 2 * 0.6;

    bool isHebrew = AppLocalizations.of(context)!.languageName == 'Hebrew';

    double dx = details.localPosition.dx;
    double dy = details.localPosition.dy;
    double endWidth =
        tickWidth * 6 + marginStart + strokeWidth * 2 + spaceBetweenThcCbd;
    double endHeight = height - spaceForXAxis;
    if (dx < marginStart || dx > endWidth || dy > endHeight) {
      return;
    }
    for (var i = 0; i < 7; i++) {
      DateTime day = widget.presentWeek.elementAt(i);
      Bar? bar = findDay(day, widget.bars);
      if (bar == null) continue;
      double maxValue = findMaxTotalForWeek(widget.bars);
      double yUnit = (height - spaceForXAxis - marginTopHeight) / maxValue;
      double startThcWidth =
          (tickWidth * (isHebrew ? (6 - i) : i)) + marginStart;
      double endCbdWidth = startThcWidth + strokeWidth * 2 + spaceBetweenThcCbd;
      double endHeight = height - spaceForXAxis - (maxThcCbdInDay(bar) * yUnit);

      if (dx > startThcWidth && dx < endCbdWidth && dy > endHeight) {
        showTollTip = true;
        clickedBar = bar;
        widget.setClickedBar(clickedBar);
        dxToolTip = dx;
        dyToolTip = dy;
        // setState(() {});
      }
    }
  }
}

class ChartPainter extends CustomPainter {
  final int duration;
  final List<Bar> bars;
  final Size containerSize;
  final ui.Image heartImage;
  final ui.Image sleepImage;
  final ui.Image stepsImage;
  final List<DateTime> presentWeek;
  final int marginStart;
  final int spaceBetweenThcCbd;
  final double tickWidth;
  final double strokeWidth;
  final int spaceForXAxis;
  final int marginTopHeight;
  final Option chosenValue;
  int spaceBetweenIconAndText = 19;
  BuildContext context;

  ChartPainter({
    required this.duration,
    required this.bars,
    required this.containerSize,
    required this.heartImage,
    required this.sleepImage,
    required this.stepsImage,
    required this.presentWeek,
    required this.marginStart,
    required this.spaceBetweenThcCbd,
    required this.tickWidth,
    required this.strokeWidth,
    required this.spaceForXAxis,
    required this.marginTopHeight,
    required this.chosenValue,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    bool isHebrew = (AppLocalizations.of(context)?.languageName ?? 'English') == 'Hebrew';
    // Y axis.
    canvas.drawLine(
      Offset(isHebrew ? size.width - 24 : 24, 0),
      Offset(isHebrew ? size.width - 24 : 24, size.height - spaceForXAxis),
      Paint()
        ..color = Colors.black45
        ..strokeWidth = 3,
    );
    // X axis.
    canvas.drawLine(
      Offset(size.width - 24, size.height - spaceForXAxis),
      Offset(24, size.height - spaceForXAxis),
      Paint()
        ..color = Colors.black45
        ..strokeWidth = 3,
    );

    // double yUnit = (size.height - spaceForXAxis - marginTopHeight) / maxValue;

    double thcStrokeDx = (tickWidth * 6) + marginStart + strokeWidth / 2;

    bool hasThc = bars.any((element) => element.thc != 0);

    bool hasCbd = bars.any((element) => element.cbd != 0);

    // Draw THC reading map.
    if (hasThc) {
      var thcDx0 = thcStrokeDx + (strokeWidth * 2) + spaceBetweenThcCbd + 10;
      var thcDx1 = thcStrokeDx + (strokeWidth * 3) + spaceBetweenThcCbd + 10;

      canvas.drawLine(
        Offset(
          isHebrew ? size.width - 25 - thcDx0 : thcDx0,
          size.height / 5,
        ),
        Offset(isHebrew ? size.width - 25 - thcDx1 : thcDx1, size.height / 5),
        ui.Paint()
          ..strokeWidth = strokeWidth
          ..color = const Color.fromRGBO(78, 122, 199, 1),
      );
      final textPainter = TextPainter(
        text: const TextSpan(
            text: 'THC',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontFamily: 'NunitoSans',
            )),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      var thcDxText = thcStrokeDx + (strokeWidth * 3) + spaceBetweenThcCbd + 15;
      textPainter.paint(
        canvas,
        Offset(
            isHebrew ? size.width - thcDxText : thcDxText, size.height / 5.6),
      );
    }

    // Draw CBD reading map.
    if (hasCbd) {
      var cbdDx0 = thcStrokeDx + (strokeWidth * 2) + spaceBetweenThcCbd + 10;
      var cbdDx1 = thcStrokeDx + (strokeWidth * 3) + spaceBetweenThcCbd + 10;
      canvas.drawLine(
        Offset(isHebrew ? size.width - cbdDx0 - 25 : cbdDx0, size.height / 8),
        Offset(isHebrew ? size.width - cbdDx1 - 25 : cbdDx1, size.height / 8),
        ui.Paint()
          ..strokeWidth = strokeWidth
          ..color = const Color.fromRGBO(52, 64, 85, 0.5),
      );
      final textPainter1 = TextPainter(
        text: const TextSpan(
            text: 'CBD',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontFamily: 'NunitoSans',
            )),
        textDirection: TextDirection.ltr,
      );
      textPainter1.layout();
      var cbdDxText = thcStrokeDx + (strokeWidth * 3) + spaceBetweenThcCbd + 15;
      textPainter1.paint(
        canvas,
        Offset(isHebrew ? size.width - cbdDxText : cbdDxText, size.height / 10),
      );
    }

    paintYAxisNumbers(canvas, size);

    if (duration == 7) {
      paintXAxisDays(canvas, size);

      paint7DaysBars(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void paintYAxisNumbers(Canvas canvas, Size size) {
    bool isHebrew = (AppLocalizations.of(context)?.languageName ?? 'English') == 'Hebrew';
    double maxValue = findMaxTotalForWeek(bars);
    double unit = (size.height - spaceForXAxis - marginTopHeight) / maxValue;
    int jump = maxValue > 100
        ? 20
        : maxValue > 50
            ? 10
            : maxValue > 10
                ? 5
                : 1;

    int tick = jump;
    while (tick <= maxValue) {
      if (maxValue < 100) {
        canvas.drawLine(
          Offset(isHebrew ? size.width - 20 : 20,
              (size.height - spaceForXAxis) - tick * unit),
          Offset(isHebrew ? size.width - 24 : 24,
              (size.height - spaceForXAxis) - tick * unit),
          Paint()
            ..color = Colors.black
            ..strokeWidth = 1,
        );
      }

      final textPainter = TextPainter(
        text: TextSpan(
            text: tick.toString(),
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontFamily: 'NunitoSans',
            )),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(isHebrew ? size.width - 13 : 0,
              ((size.height - spaceForXAxis - 8) - (tick * unit))));
      tick += jump;
    }
    return;
  }

  void paintXAxisDays(Canvas canvas, Size size) {
    bool isHebrew =
        (AppLocalizations.of(context)?.languageName ?? 'English') == 'Hebrew';
    int marginStartForText = marginStart + 6;

    for (int i = 0; i < 7; i++) {
      // final day = intl.DateFormat('EEEE')
      //     .format(presentWeek.elementAt(i))
      //     .substring(0, 2);
      final garminServices =
          Provider.of<GarminServices>(context, listen: false);
      DateTime day1 = presentWeek.elementAt(i);
      final day =
          garminServices.garminSentences['Day${((day1.weekday) % 7) + 1}'] ??
              '';

      final textPainter = TextPainter(
        text: TextSpan(
            text: day,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'NunitoSans',
            )),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      var dx = (tickWidth * i) + marginStartForText;
      textPainter.paint(
          canvas,
          Offset(isHebrew ? size.width - 17 - dx : dx,
              size.height - spaceForXAxis + 2));
    }
  }

  void paint7DaysBars(Canvas canvas, Size size) {
    bool isHebrew =
        (AppLocalizations.of(context)?.languageName ?? 'English') == 'Hebrew';
    double maxValue = findMaxTotalForWeek(bars);
    double yUnit = (size.height - spaceForXAxis - marginTopHeight) / maxValue;

    for (var i = 0; i < 7; i++) {
      DateTime day = presentWeek.elementAt(i);
      Bar? bar = findDay(day, bars);
      if (bar == null) continue;
      double thcStrokeDx = (tickWidth * i) + marginStart + strokeWidth / 2;
      // Draw thc bar.
      if (bar.thc != 0) {
        var thcDx0 = thcStrokeDx + (bar.cbd == 0 ? strokeWidth / 2 : 0);
        var offset = Offset(isHebrew ? size.width - thcDx0 : thcDx0,
            size.height - spaceForXAxis);
        var thcDx1 = thcStrokeDx + (bar.cbd == 0 ? strokeWidth / 2 : 0);
        var offset2 = Offset(
          isHebrew ? size.width - thcDx1 : thcDx1,
          size.height - spaceForXAxis - (bar.thc * yUnit),
        );
        canvas.drawLine(
          offset,
          offset2,
          Paint()
            // ..color = const Color.fromRGBO(46, 147, 60, 1)
            ..color = const Color.fromRGBO(78, 122, 199, 1)
            ..strokeWidth = strokeWidth * (bar.cbd == 0 ? 1.5 : 1),
        );
      }

      // Draw cbd bar.
      if (bar.cbd != 0) {
        var cbdDx0 = thcStrokeDx +
            (bar.thc == 0 ? strokeWidth / 2 : strokeWidth + spaceBetweenThcCbd);
        var cbdDx1 = thcStrokeDx +
            (bar.thc == 0 ? strokeWidth / 2 : strokeWidth + spaceBetweenThcCbd);
        canvas.drawLine(
          Offset(isHebrew ? size.width - cbdDx0 : cbdDx0,
              size.height - spaceForXAxis),
          Offset(
            isHebrew ? size.width - cbdDx1 : cbdDx1,
            size.height - spaceForXAxis - (bar.cbd * yUnit),
          ),
          Paint()
            ..color = const Color.fromRGBO(52, 64, 85, 0.5)
            ..strokeWidth = strokeWidth * (bar.thc == 0 ? 1.5 : 1),
        );
      }

      int? heartRateValue = bar.heartbeatRate;
      if (chosenValue == Option.heaertRate && heartRateValue != null) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: heartRateValue.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.deepPurple,
              fontFamily: 'NunitoSans',
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        var dxText = (tickWidth * i + marginStart + 1);
        textPainter.paint(
          canvas,
          Offset(
            isHebrew ? size.width - 10 - dxText : dxText - 4,
            size.height -
                spaceForXAxis -
                (maxThcCbdInDay(bar) == 0 ? 1 : maxThcCbdInDay(bar) * yUnit) -
                20,
          ),
        );
        // Draw heartbeat icon.
        var dxIcon =
            (tickWidth * i + marginStart + spaceBetweenIconAndText - 3);
        canvas.drawImage(
            heartImage,
            Offset(
                isHebrew ? size.width - 17 - dxIcon : dxIcon,
                size.height -
                    spaceForXAxis -
                    (maxThcCbdInDay(bar) == 0
                        ? 1
                        : maxThcCbdInDay(bar) * yUnit) -
                    20),
            ui.Paint()..color = Colors.red);
      }
      int? sleepRate = bar.sleepRate;
      if (chosenValue == Option.sleepRate && sleepRate != null) {
        String text = '$sleepRate';

        final textPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: sleepRate < 3
                  ? Colors.red
                  : sleepRate == 3
                      ? Colors.orange
                      : Colors.green,
              fontFamily: 'NunitoSans',
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        var dxText = tickWidth * i + marginStart + strokeWidth * 0.1;
        textPainter.paint(
          canvas,
          Offset(
              isHebrew ? size.width - 24 - dxText : dxText,
              size.height -
                  spaceForXAxis -
                  (maxThcCbdInDay(bar) == 0 ? 1 : maxThcCbdInDay(bar) * yUnit) -
                  17),
        );
        // Draw sleeprate icon.
        var dxIcon =
            (tickWidth * i + marginStart + spaceBetweenIconAndText - 8);
        canvas.drawImage(
            sleepImage,
            Offset(
                isHebrew ? size.width - 5 - dxIcon : dxIcon,
                size.height -
                    spaceForXAxis -
                    (maxThcCbdInDay(bar) == 0
                        ? 1
                        : maxThcCbdInDay(bar) * yUnit) -
                    20),
            ui.Paint()..color = Colors.red);
      }
      int? steps = bar.steps;
      if (chosenValue == Option.steps && steps != null) {
        String kSteps = (steps / 1000).floorToDouble().toStringAsFixed(0);
        String text = kSteps;

        final textPainter = TextPainter(
          text: TextSpan(
            text: '${text}K',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.deepPurple,
              fontFamily: 'NunitoSans',
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        var dxText = tickWidth * i + marginStart + strokeWidth * 0.1;
        textPainter.paint(
          canvas,
          Offset(
              isHebrew ? size.width - 33 - dxText : dxText,
              size.height -
                  spaceForXAxis -
                  (maxThcCbdInDay(bar) == 0 ? 1 : maxThcCbdInDay(bar) * yUnit) -
                  17),
        );
        // Draw steps icon.
        var dxIcon =
            (tickWidth * i + marginStart + spaceBetweenIconAndText + 2);
        canvas.drawImage(
            stepsImage,
            Offset(
                isHebrew ? size.width + 10 - dxIcon : dxIcon,
                size.height -
                    spaceForXAxis -
                    (maxThcCbdInDay(bar) == 0
                        ? 1
                        : maxThcCbdInDay(bar) * yUnit) -
                    20),
            ui.Paint()..color = Colors.red);
      }
    }
  }
}

Bar? findDay(DateTime day, List<Bar> barss) {
  for (var bar in barss) {
    if (bar.dateTime.day == day.day &&
        bar.dateTime.month == day.month &&
        bar.dateTime.year == day.year) {
      return bar;
    }
  }
  return null;
}

WeekBar? findWeek(DateTime day, List<WeekBar> barss) {
  for (var bar in barss) {
    if (bar.dateTime.start.isBefore(day) && bar.dateTime.end.isAfter(day)) {
      return bar;
    }
  }
  return null;
}

double maxThcCbdInDay(Bar bar) {
  return bar.thc > bar.cbd ? bar.thc : bar.cbd;
}

double maxThcCbdInWeek(WeekBar bar) {
  return bar.thc > bar.cbd ? bar.thc : bar.cbd;
}

double findMaxTotalForWeek(List<Bar> barss) {
  double maxValue = 0;
  for (var element in barss) {
    if (element.thc > maxValue) maxValue = element.thc;
    if (element.cbd > maxValue) maxValue = element.cbd;
  }
  return maxValue;
}

double findMaxTotalForMonth(List<WeekBar> barss) {
  double maxValue = 0;
  for (var element in barss) {
    if (element.thc > maxValue) maxValue = element.thc;
    if (element.cbd > maxValue) maxValue = element.cbd;
  }
  return maxValue;
}

double findMinTotal(List<Bar> barss) {
  double minValue = barss.first.thc;
  for (var element in barss) {
    if (element.thc < minValue) minValue = element.thc;
    if (element.cbd < minValue) minValue = element.cbd;
  }
  return minValue;
}
