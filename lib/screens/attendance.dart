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
              child: Icon(Icons.calendar_today),
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
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  List data = day.toString().split(" ");
                  List dateList = data[0].split("-");

                  String date =
                      dateList[1] + "-" + dateList[2] + "-" + dateList[0];

                  return FutureBuilder<bool>(
                    future:
                        presentOnDate(date, widget.club.id, userData['osis']),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        // Add your logic here if the user is present on this date.
                        return marker(Colors.green, 5);
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            Row(children: [
              SizedBox(width: 20, child: marker(Colors.green, 10)),
              Text("  =  Present")
            ]),
            Row(children: [
              SizedBox(width: 20, child: marker(Colors.red, 10)),
              Text("  =  Absent")
            ]),
            const SizedBox(height: 25),
            Text("Meetings attended: 9/16",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 25),
            Text(
                "Attendance is usually updated once a week. If you were wrongfully marked absent for the day, it is your responsibility to contact the club leaders and get it resolved."),
          ])),
    );
  }

  Widget marker(Color c, double h) {
    return Container(
        height: h, decoration: BoxDecoration(color: c, shape: BoxShape.circle));
  }

  Widget takeAttendanceDialog() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM-dd-yyyy').format(now);
    DateTime firstDate = DateTime(now.year, now.month, now.day);
    DateTime lastDate = DateTime(now.year, now.month + 1, 0);

    DateTime datePicked;

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
                hoverColor: Colors.grey[200],
                hintText:
                    'Paste OSIS numbers, each on separate lines, to take attendance',
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
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: firstDate,
                        lastDate: lastDate,
                      ).then((pickedDate) {
                        if (pickedDate != null) {
                          setState(() {
                            datePicked = pickedDate;
                          });
                        }
                      });
                    },
                    child: Text('Select date', style: TextStyle(color: Colors.grey)),
                  ),
                ),
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
