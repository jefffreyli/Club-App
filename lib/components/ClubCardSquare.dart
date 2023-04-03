import '../clubModel.dart';
import 'package:flutter/material.dart';
import '../fb_helper.dart';
import '../screens/clubHome.dart';
import 'Tag.dart';

class ClubCardSquare extends StatefulWidget {
  final Club club;

  const ClubCardSquare({super.key, required this.club});

  @override
  State<ClubCardSquare> createState() => _ClubCardSquareState();
}

class _ClubCardSquareState extends State<ClubCardSquare> {
  var h, w;
  String status = "";

  @override
  Widget build(BuildContext context) {
    if (userData['clubs'].contains(widget.club.id))
      status = "Leave";
    else
      status = "Join";

    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    double logoRadius = 0;

    if (w < 1000) {
      logoRadius = 55;
    } else {
      logoRadius = 65;
    }

    return GestureDetector(
      onTap: (() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClubHome(club: widget.club)));
      }),
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                    radius: logoRadius,
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
                    // tag(widget.club.id),
                  ],
                ),

                SizedBox(height: 20),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        status == "Join" ? Colors.green : Colors.red),
                  ),
                  onPressed: () {
                    setState(() {
                      if (status == "Join")
                        status = "Leave";
                      else {
                        status = "Join";
                      }

                      if (status == "Join") {
                        leaveClub(widget.club.id);
                        userData['clubs'].remove(widget.club.id);
                      } else {
                        joinClub(widget.club.id);
                        userData['clubs'].add(widget.club.id);
                      }
                    });
                  },
                  child: Text("$status",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      )),
                ),

                // buildJoinLeave(widget.clubID.toString())
              ]),
        ),
      ),
    );
  }
}
