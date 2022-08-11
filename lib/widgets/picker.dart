import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCupertinoPicker extends StatelessWidget {
  const MyCupertinoPicker({
    Key? key,
    required this.onChanged,
    required this.pickerType,
    this.weightList,
  }) : super(key: key);

  final Function onChanged;
  final String pickerType;
  final List<String>? weightList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: pickerType == 'Date'
          ? CupertinoDatePicker(
              onDateTimeChanged: (date) => onChanged(date, pickerType),
              initialDateTime: DateTime.now(),
              maximumDate: DateTime.now(),
              minimumDate: DateTime(1950, 1, 1),
              mode: CupertinoDatePickerMode.date,
            )
          : pickerType == 'Sleep Time' || pickerType == 'Awake Time'
              ? CupertinoDatePicker(
                  use24hFormat: true,
                  onDateTimeChanged: (dateTime) =>
                      onChanged(dateTime, pickerType),
                  initialDateTime: DateTime.now(),
                  maximumDate: DateTime.now().add(const Duration(days: 1)),
                  minimumDate: DateTime(1950, 1, 1),
                  mode: CupertinoDatePickerMode.time,
                )
              : CupertinoPicker(
                  children: weightList!
                      .map(
                        (i) => Text(
                          i.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                      )
                      .toList(),
                  onSelectedItemChanged: (item) => onChanged(item, pickerType),
                  itemExtent: 30,
                ),
    );
  }
}
