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
  var h;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;

    return GestureDetector(
        onTap: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ClubHome(club: widget.club)));
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
                    Text(
                      "lorem ipsum is dummy text. lorem ipsum is dummy text. lorem ipsum is dummy text.",
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tag(widget.club.day),
                        tag(widget.club.category),
                        tag(widget.club.id),
                      ],
                    ),
                    SizedBox(height: h * 0.05),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          "Join",
                          style: TextStyle(
                            fontSize: h * 0.02,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30)
                    // buildJoinLeave(widget.clubID.toString())
                  ]),
            )));
  }
}
