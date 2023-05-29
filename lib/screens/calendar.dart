import '../../components/Nav.dart';
import '../../fb_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/club.dart';
import '../../utils.dart';
import 'club/clubOnDate.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

var w, h;

class _CalendarState extends State<Calendar> {
  TextEditingController attendanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: nav("Calendar"),
      drawer: sidebar(context),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 25),
                TableCalendar(
            onDaySelected: (selectedDay, focusedDay) {
              String fSelectedDay =
                  DateFormat('MM-dd-yyyy').format(selectedDay);
              navigate(context, ClubsOnDate(date: fSelectedDay));
            },
            headerStyle: HeaderStyle(
              titleTextStyle: const TextStyle(color: Colors.black),
              formatButtonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2030, 1, 1),
            focusedDay: DateTime.now(),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                List data = day.toString().split(" ");
                List dateList = data[0].split("-");
                String date =
                    dateList[1] + "-" + dateList[2] + "-" + dateList[0];
                //05-23-2023
      
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: clubsOnDate(date),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return marker(Colors.blue[700], 5);
                    } else if (snapshot.hasError) {
                      return Container();
                    } else {
                      return Container();
                    }
                  },
                );
              },
            ),
                ),
                const SizedBox(height: 50),
                Text("Tap on a date to see which clubs are meeting that day.")
              ])),
      ),
    );
  }

  Widget marker(Color? c, double h) {
    return Container(
        height: h, decoration: BoxDecoration(color: c, shape: BoxShape.circle));
  }
}
