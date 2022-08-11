// import 'dart:ui';
//
// import 'package:dashboard_doctors/models/questionnaire.dart';
// import 'package:date_format/date_format.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// import '../../models/questionnaire.dart';
// import '../../widgets/app/loading_spinner.dart';
//
// import 'records_grid.dart';
//
// class Calender extends StatefulWidget {
//   const Calender({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _CalenderState createState() => _CalenderState();
// }
//
// class _CalenderState extends State<Calender> {
//   Locale myLocale = window.locale;
//
//   TextStyle dayStyle(FontWeight fontWeight) {
//     return TextStyle(
//       color: Colors.grey[900],
//       fontWeight: fontWeight,
//       fontFamily: myLocale.languageCode == 'he' ? 'Assistant' : 'Rubik',
//       fontSize: 16,
//     );
//   }
//
//   String dateTime = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
//   DateTime date = DateTime.now();
//
//   final bool _isLoading = false;
//
//   void fullRefresh() {
//     setState(() {
//       changeDay(date);
//     });
//   }
//
//   List<Record> recordsFilterdList = [];
//
//   void changeDay(day) {
//     final questionnaireModel =
//     Provider.of<Questionnaires>(context, listen: false);
//
//     setState(() {
//       recordsFilterdList.clear();
//       dateTime = formatDate(day, [yyyy, '-', mm, '-', dd]);
//       date = day;
//
//       for (var record in questionnaireModel.records
//           .where(
//               (element) => element.questionnaireName == 'Intake Questionnaire')
//           .toList()) {
//         if (formatDate(DateTime.parse(record.date), [yyyy, '-', mm, '-', dd]) ==
//             dateTime) {
//           if (!recordsFilterdList.contains(record)) {
//             recordsFilterdList.add(record);
//           }
//         }
//       }
//     });
//   }
//
//   DateTime _selectedDay = DateTime.now();
//
//   @override
//   void initState() {
//     super.initState();
//     changeDay(DateTime.now());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? const LoadingSpinner()
//         : Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Padding(
//           padding:
//           const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: TableCalendar(
//             selectedDayPredicate: (day) {
//               return isSameDay(_selectedDay, day);
//             },
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//               });
//               changeDay(_selectedDay);
//             },
//             calendarFormat: CalendarFormat.twoWeeks,
//             rowHeight: 65,
//             locale: myLocale.languageCode == 'he' ? 'he' : 'en',
//             focusedDay: _selectedDay,
//             firstDay:
//             DateTime.now().subtract(const Duration(days: 1000000)),
//             lastDay: DateTime.now().add(const Duration(days: 365)),
//             startingDayOfWeek: StartingDayOfWeek.sunday,
//             calendarStyle: CalendarStyle(
//               weekendTextStyle: dayStyle(FontWeight.normal),
//               defaultTextStyle: dayStyle(FontWeight.normal),
//               isTodayHighlighted: true,
//               selectedDecoration: BoxDecoration(
//                 color: Colors.lightBlue[900],
//                 shape: BoxShape.circle,
//               ),
//               todayDecoration: BoxDecoration(
//                 color: Colors.grey[400],
//                 shape: BoxShape.circle,
//               ),
//             ),
//             daysOfWeekStyle: DaysOfWeekStyle(
//               weekdayStyle: TextStyle(
//                 color: Colors.grey[900],
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//               weekendStyle: const TextStyle(
//                 color: Colors.grey,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             headerStyle: HeaderStyle(
//               formatButtonVisible: false,
//               titleTextStyle: TextStyle(
//                 color: Colors.lightBlue[900],
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//               leftChevronIcon: Icon(
//                 Icons.chevron_left,
//                 color: Colors.lightBlue[900],
//               ),
//               rightChevronIcon: Icon(
//                 Icons.chevron_right,
//                 color: Colors.lightBlue[900],
//               ),
//             ),
//           ),
//         ),
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 30),
//           child: Divider(
//             color: Colors.grey,
//           ),
//         ),
//         if (recordsFilterdList.isNotEmpty)
//           Expanded(
//             flex: 2,
//             child: RecordsGrid(records: recordsFilterdList),
//           ),
//         if (recordsFilterdList.isEmpty)
//           Expanded(
//             flex: 2,
//             child: Center(
//               child: Text(
//                 AppLocalizations.of(context)!.noRecords,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }
// }