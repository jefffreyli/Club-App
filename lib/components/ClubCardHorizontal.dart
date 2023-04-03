import 'package:flutter/material.dart';
import '../screens/clubHome.dart';
import '../clubModel.dart';

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
                elevation: 3,
                child: ListTile(
                  tileColor: Colors.grey[50],
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.asset("assets/logo.png")),
                  title: Text(widget.club.name),
                  subtitle:  Text(widget.club.category),
                ))));
  }
}
