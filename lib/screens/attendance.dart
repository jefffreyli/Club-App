import 'package:club_app_frontend/components/Header.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Attendance extends StatefulWidget {
  final String clubName;
  final String clubDay;
  final String clubID;
  const Attendance(
      {super.key,
      required this.clubName,
      required this.clubDay,
      required this.clubID});

  @override
  State<Attendance> createState() => _AttendanceState();
}

var w, h;

class _AttendanceState extends State<Attendance> {
  // DateTime _focusedDay = DateTime.now();
  // DateTime? _selectedDay;
  // Map clubsMap = userData['clubs'];

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: sidebar(context),
      appBar: nav,
      body: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 25),
            TableCalendar(
              headerStyle: HeaderStyle(
                titleTextStyle: TextStyle(color: Colors.black),
                formatButtonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.utc(2030, 1, 1),
              focusedDay: DateTime.now(),
              // calendarBuilders: CalendarBuilders(
              //   markerBuilder: (context, day, events) {
              //     if (clubsMap[widget.clubID] == null) {
              //       fb.addClub(widget.clubID, docID, userData['clubs']);
              //     }

              //     for (int i = 0; i < clubsMap[widget.clubID].length; i++) {
              //       List presentDate = clubsMap[widget.clubID][i].split("-");
              //       String m = presentDate[0];
              //       String d = presentDate[1];
              //       String y = presentDate[2];

              //       if (day.year.toString() == y &&
              //           day.month.toString() == m &&
              //           day.day.toString() == d) {
              //          return buildMarker(Colors.green);
              //       }
              //     }
              //   },
              // ),
            ),
            const SizedBox(height: 50),
            Row(children: [
              SizedBox(width: 20, child: buildMarker(Colors.green, 10)),
              Text("  =  Present")
            ]),
            Row(children: [
              SizedBox(width: 20, child: buildMarker(Colors.red, 10)),
              Text("  =  Absent")
            ]),
            const SizedBox(height: 25),
            Text("Meetings attended: 9/16",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 25),
            Text(
                "Attendance is usually updated once a week. If you were wrongfully marked absent for the day, it is your responsibility to contact the club leaders and get it resolved."),
          ])),
      // floatingActionButton:
      //     userData['user_type'] != "Member" ? buildTakeAttendance() : null,
    );
  }

  final attendanceController = TextEditingController();
  Widget buildTextFieldAttendance() {
    return (Column(children: [
      TextField(
        controller: attendanceController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Paste OSIS',
        ),
      ),
      TextButton(
        child: Text("take attendance"),
        onPressed: () {
          var dt = DateTime.now();
          String date = "${dt.month}-${dt.day}-${dt.year}";
          // fb.takeAttendance(widget.clubID, attendanceController.text, "$date");
        },
      )
    ]));
  }

  Widget buildTakeAttendance() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return buildTextFieldAttendance();
          },
        );
      },
      child: Icon(Icons.add),
    );
  }

  Widget buildMarker(Color c, double h) {
    return Container(
        height: h, decoration: BoxDecoration(color: c, shape: BoxShape.circle));
  }
}
