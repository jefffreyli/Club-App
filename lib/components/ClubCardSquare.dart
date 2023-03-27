import 'package:flutter/material.dart';
import '../screens/clubHome.dart';
import 'Tag.dart';

class ClubCardSquare extends StatefulWidget {
  final String clubName;
  final String clubDay;
  final String clubAdvisor;
  final String clubCategory;
  final String clubID;
  const ClubCardSquare(
      {super.key,
      required this.clubName,
      required this.clubDay,
      required this.clubAdvisor,
      required this.clubCategory,
      required this.clubID});

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
                        clubName: widget.clubName,
                        clubDay: widget.clubDay,
                        clubAdvisor: widget.clubAdvisor,
                        clubCategory: widget.clubCategory,
                        clubID: widget.clubID,
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
                    Text(widget.clubName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    const Text(
                        "lorem ipsum is dummy text. lorem ipsum is dummy text. lorem ipsum is dummy text."),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tag(widget.clubDay),
                        tag(widget.clubCategory),
                        tag(widget.clubID),
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
