// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:hair_salon/constants/constants.dart';

class ShowDays extends StatefulWidget {
  final List<String> initialSelectedDays;
  final void Function(List<String>) onSelectionChanged;

  ShowDays({
    super.key,
    required this.initialSelectedDays,
    required this.onSelectionChanged,
  });

  @override
  _ShowDaysState createState() => _ShowDaysState();
}

class _ShowDaysState extends State<ShowDays> {
  late List<String> selectedDays;

  @override
  void initState() {
    super.initState();
    // Initialize the selectedDays with the passed argument
    selectedDays = List.from(widget.initialSelectedDays);
  }

  void toggleDay(String day) {
    setState(() {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
      } else {
        selectedDays.add(day);
      }
      // Notify the parent widget of the updated selection
      widget.onSelectionChanged(selectedDays);
    });
  }

  @override
  Widget build(BuildContext context) {
      final List<String> days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map(
        (day) {
          final isSelected = selectedDays.contains(day);
          return GestureDetector(
            onTap: () => toggleDay(day),
            child: Container(
              width: 40,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(colors: AppColors.appGradientColors)
                    : null,
                color: isSelected ? null : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
