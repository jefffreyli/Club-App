import 'package:flutter/material.dart';
import '../screens/clubHome.dart';

class ClubCardHorizontal extends StatefulWidget {
  final String clubName;
  final String clubDay;
  final String clubAdvisor;
  final String clubCategory;
  final String clubID;
  const ClubCardHorizontal(
      {super.key,
      required this.clubName,
      required this.clubDay,
      required this.clubAdvisor,
      required this.clubCategory,
      required this.clubID});

  @override
  State<ClubCardHorizontal> createState() => _ClubCardHorizontalState();
}

class _ClubCardHorizontalState extends State<ClubCardHorizontal> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ClubHome(
                        clubName: widget.clubName,
                        clubDay: widget.clubDay,
                        clubAdvisor: widget.clubAdvisor,
                        clubCategory: widget.clubCategory,
                        clubID: widget.clubID,
                      )));
        }),
        child: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Card(
                elevation: 3,
                child: ListTile(
                  tileColor: Colors.grey[50],
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.asset("assets/logo.png")),
                  title: Text(widget.clubAdvisor),
                  subtitle: const Text("Advisor"),
                ))));
  }
}
