import 'package:club_app/components/ClubCardHorizontal.dart';
import 'package:club_app/utils.dart';
import 'package:flutter/material.dart';

import '../../models/club.dart';
import '../../components/Nav.dart';
import '../../fb_helper.dart';

class ClubsOnDate extends StatefulWidget {
  final date;
  const ClubsOnDate({Key? key, required this.date}) : super(key: key);

  @override
  State<ClubsOnDate> createState() => _ClubsOnDateState();
}

class _ClubsOnDateState extends State<ClubsOnDate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: nav(widget.date.toString()),
        body: SingleChildScrollView(
          child: Container(
            margin:
                const EdgeInsets.only(top: 20, bottom: 20, right: 25, left: 25),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: clubsOnDate(widget.date),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingCircle(); // Show a loading spinner while waiting
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    children: snapshot.data!.map((clubInfo) {
                      Club c = Club(
                          name: clubInfo['name'] ?? "",
                          day: clubInfo['day'] ?? "",
                          advisorName: clubInfo['advisor_name'] ?? "",
                          advisorEmail: clubInfo['advisor_email'] ?? "",
                          category: clubInfo['category'] ?? "",
                          members: clubInfo['members'] ?? [],
                          id: clubInfo['id'].toString(),
                          description: clubInfo['description'] ?? "",
                          president: clubInfo['president'] ?? "",
                          vicePresident: clubInfo['vice_president'] ?? "",
                          secretary: clubInfo['secretary'] ?? "",
                          location: (clubInfo['location']).toString() ?? "");
                      return ClubCardHorizontal(club: c);
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ));
  }
}
