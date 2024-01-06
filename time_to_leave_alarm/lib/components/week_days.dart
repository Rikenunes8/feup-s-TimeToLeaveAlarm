import 'package:flutter/material.dart';

class WeekDaysChips extends StatelessWidget {
  final String selected;
  final Function(int) callback;
  static const weekDays = ["M", "T", "W", "T", "F", "S", "S"];

  const WeekDaysChips(
      {Key? key, required this.selected, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildWeekDayChip(context, 0),
        _buildWeekDayChip(context, 1),
        _buildWeekDayChip(context, 2),
        _buildWeekDayChip(context, 3),
        _buildWeekDayChip(context, 4),
        _buildWeekDayChip(context, 5),
        _buildWeekDayChip(context, 6),
      ],
    );
  }

  Widget _buildWeekDayChip(BuildContext context, int weekDay) {
    return GestureDetector(
      onTap: () => callback(weekDay),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).primaryColor),
              color: selected.contains(weekDay.toString())
                  ? Theme.of(context).primaryColor
                  : Colors.white),
          child: Center(
            child: Text(
              weekDays[weekDay],
              style: TextStyle(fontSize: 11, color: selected.contains(weekDay.toString())
                      ? Colors.white
                      : Colors.black38),
            ),
          )),
    );
  }
}
