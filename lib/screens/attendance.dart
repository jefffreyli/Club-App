import 'package:club_app_frontend/components/Header.dart';
import 'package:club_app_frontend/fb_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../clubModel.dart';

class Attendance extends StatefulWidget {
  final Club club;
  const Attendance({super.key, required this.club});

  @override
  State<Attendance> createState() => _AttendanceState();
}

var w, h;

class _AttendanceState extends State<Attendance> {
  // DateTime _focusedDay = DateTime.now();
  // DateTime? _selectedDay;
  // Map clubsMap = userData['clubs'];
  TextEditingController attendanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: sidebar(context),
      appBar: nav("${widget.club.name} Attendance"),
      floatingActionButton: userData['user_type'] != "Member"
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return takeAttendanceDialog();
                  },
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            )
          : null,

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

  // Widget buildTextFieldAttendance() {
  //   return (Column(children: [
  //     TextField(
  //       controller: attendanceController,
  //       decoration: const InputDecoration(
  //         border: OutlineInputBorder(),
  //         hintText: 'Paste OSIS',
  //       ),
  //     ),
  //     TextButton(
  //       child: Text("take attendance"),
  //       onPressed: () {
  //         var dt = DateTime.now();
  //         String date = "${dt.month}-${dt.day}-${dt.year}";
  //         // fb.takeAttendance(widget.clubID, attendanceController.text, "$date");
  //       },
  //     )
  //   ]));
  // }

  // Widget buildTakeAttendance() {
  //   return FloatingActionButton(
  //     onPressed: () {
  //       showModalBottomSheet(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return buildTextFieldAttendance();
  //         },
  //       );
  //     },
  //     child: Icon(Icons.add),
  //   );
  // }

  Widget buildMarker(Color c, double h) {
    return Container(
        height: h, decoration: BoxDecoration(color: c, shape: BoxShape.circle));
  }

  Widget takeAttendanceDialog() {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('MM-dd-yyyy').format(currentDate);

    return AlertDialog(
      backgroundColor: Color(0xfff5f5f5),
      content: Container(
        width: w * 0.75,
        height: h * 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
              controller: attendanceController,
              maxLines: (h / 30).toInt(),
              decoration: InputDecoration(
                hintText: 'Enter paragraph of text',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                filled: true,
                fillColor: Color(0xfff5f5f5),
                contentPadding: EdgeInsets.symmetric(
                  vertical: h * 0.02,
                  horizontal: w * 0.02,
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    onAttendancePressed(formattedDate);
                  },
                  child: Text('Take Attendance'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onCancelPressed() {}

  void onAttendancePressed(String date) {
    List<String> osis = attendanceController.text.split("\n");
    takeAttendance(osis, date, widget.club.id);
  }
}
