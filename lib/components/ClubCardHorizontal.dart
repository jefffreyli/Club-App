import 'package:flutter/material.dart';
import '../screens/club/clubHome.dart';
import '../models/club.dart';
import '../utils.dart';
import 'Tag.dart';

class ClubCardHorizontal extends StatefulWidget {
  final Club club;
  const ClubCardHorizontal({super.key, required this.club});

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
                  builder: (context) => ClubHome(club: widget.club)));
        }),
        child: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Card(
              // color: Colors.grey[50],
                elevation: 1.5,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
                  child: ListTile(
                    // tileColor: Colors.grey[50],
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset("assets/logo.png")),
                    title: Text(widget.club.name,
                        style:  TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                    subtitle: Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          smallTag(widget.club.day, Colors.blue[800]!,
                              Colors.blue[50]!),
                          smallTag(widget.club.category, yellowOrangeDark, yellowOrange),
                          smallTag(widget.club.location, Colors.red[800]!,
                              Colors.red[50]!),
                        ],
                      ),
                    ),
                  ),
                ))));
  }
}
