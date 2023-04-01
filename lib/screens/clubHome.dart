import 'package:flutter/material.dart';
import '../components/Header.dart';
import '../components/Tag.dart';
import 'attendance.dart';
import '../clubModel.dart';

class ClubHome extends StatefulWidget {
  final Club club;
  const ClubHome({super.key, required this.club});

  @override
  State<ClubHome> createState() => _ClubHomeState();
}

class _ClubHomeState extends State<ClubHome> {
  var w, h;
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;

    double margin = 0;
    if (w < 600)
      margin = 15;
    else if (w < 900)
      margin = 60;
    else
      margin = 75;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.grey[700],
        elevation: 1,
        backgroundColor: Colors.grey[100],
        title: Text(
          "${widget.club.name}",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Attendance(club: widget.club),
                    ),
                  );
                },
                icon: Icon(
                  Icons.calendar_month,
                  color: Colors.grey[700],
                ),
              )),
        ],
      ),
      drawer: sidebar(context),
      body: Container(
          margin: EdgeInsets.fromLTRB(margin, 0, margin, 0),
          child: clubDetails("assets/logo.png")),
    );
  }

  Widget clubDetails(String image) {
    return (ListView(
      children: [
        const SizedBox(height: 60),
        Center(
            child: CircleAvatar(
          radius: h * 0.12,
          backgroundImage: AssetImage("assets/logo.png"),
        )),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tag(widget.club.day),
            tag(widget.club.category),
            tag(widget.club.id),
          ],
        ),
        const SizedBox(height: 50),
        const Text("Overview", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 25),
        Text(widget.club.description),
        const SizedBox(height: 25),
        const Text("Leaders", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 25),
        Column(
            children: List.generate(4, (index) {
          List leaders = [
            widget.club.president,
            widget.club.vicePresident,
            widget.club.secretary,
            widget.club.advisorName
          ];

          List positions = [
            "President",
            "Vice President/Co-President",
            "Secretary",
            "Advisor"
          ];

          return Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Card(
                  elevation: 3,
                  child: ListTile(
                    tileColor: Colors.grey[50],
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset("assets/logo.png")),
                    title: Text(leaders[index]),
                    subtitle: Text(positions[index]),
                  )));
        })),
        const SizedBox(height: 50),
      ],
    ));
  }
}
