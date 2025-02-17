import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/app_fonts.dart';
import 'package:hair_salon/utils/utills.dart';
import 'package:hair_salon/view_model/index.dart';
import 'package:table_calendar/table_calendar.dart';

class BlockDatesScreen extends StatelessWidget {
  BlockDatesScreen({super.key});
  final blockedDatesProvider = Get.find<BlockedDatesProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'work_time_blocks'.tr,
        isLeadingNeed: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomCalendar(),
              const Gap(20),
              LabelText(
                text: 'blocked_dates'.tr,
                fontSize: AppFontSize.xmedium,
                weight: FontWeight.w600,
              ),
              const Gap(10),
              // Display Blocked Dates dynamically using Obx
              Obx(() {
                if (blockedDatesProvider.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (blockedDatesProvider.blockedDatesList.isEmpty) {
                  return Center(child: Text('no_blocked_dates'.tr));
                }

                return Column(
                  children:
                      blockedDatesProvider.blockedDatesList.map((blockedDate) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: BlockedDatesComponent(
                        date: Utills().formatDate(blockedDate.date),
                        time:
                            "${Utills.convertTo24Hour(blockedDate.startTime)} - ${Utills.convertTo24Hour(blockedDate.endTime)}",
                        uid: blockedDate.id ?? "",
                      ),
                    );
                  }).toList(),
                );
              }),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key});

  @override
  CustomCalendarState createState() => CustomCalendarState();
}

class CustomCalendarState extends State<CustomCalendar> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final blockedDatesProvider = Get.find<BlockedDatesProvider>();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2022, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) =>
          isSameDay(blockedDatesProvider.selectedDay.value, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          blockedDatesProvider.selectedDay.value = selectedDay;
        });
      },
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
      calendarStyle: const CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.purple,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        weekendTextStyle: TextStyle(color: Colors.black),
        defaultTextStyle: TextStyle(color: Colors.black),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.black),
        weekdayStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}
