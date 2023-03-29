import '../clubModel.dart';
import 'package:flutter/material.dart';
import '../screens/clubHome.dart';
import 'Tag.dart';

class ClubCardSquare extends StatefulWidget {
  final Club club;

  const ClubCardSquare({super.key, required this.club});

  @override
  State<ClubCardSquare> createState() => _ClubCardSquareState();
}

class _ClubCardSquareState extends State<ClubCardSquare> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ClubHome(
                    club: widget.club
                        // clubName: widget.club.name,
                        // clubDay: widget.club.day,
                        // clubAdvisor: widget.club.advisorName,
                        // clubCategory: widget.club.category,
                        // clubID: widget.id,
                      )));
        }),
        // height: sHeight * 0.6,
        child: Card(
            elevation: 3,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("assets/logo.png")),
                    const SizedBox(height: 20),
                    Text(widget.club.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    const Text(
                        "lorem ipsum is dummy text. lorem ipsum is dummy text. lorem ipsum is dummy text."),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tag(widget.club.day),
                        tag(widget.club.category),
                        tag(widget.club.id),
                      ],
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      child: Text(
                        "Join",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      onPressed: () {},
                    ),

                    const SizedBox(height: 10)
                    // buildJoinLeave(widget.clubID.toString())
                  ]),
            )));
  }
}
