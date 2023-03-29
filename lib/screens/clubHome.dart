import 'package:flutter/material.dart';
import '../components/Header.dart';
import '../components/Tag.dart';
import 'attendance.dart';
import '../clubModel.dart';

class ClubHome extends StatefulWidget {
  // final String clubName;
  // final String clubDay;
  // final String clubAdvisor;
  // final String clubCategory;
  // final String clubID;
  // const ClubHome(
  //     {super.key,
  //     required this.clubName,
  //     required this.clubDay,
  //     required this.clubAdvisor,
  //     required this.clubCategory,
  //     required this.clubID});
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
          margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
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
        const Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."),
        const SizedBox(height: 25),
        const Text("Leaders", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 25),
        Column(
            children: List.generate(3, (index) {
          return Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Card(
                  elevation: 3,
                  child: ListTile(
                    tileColor: Colors.grey[50],
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset("assets/logo.png")),
                    title: Text(widget.club.advisorName),
                    subtitle: const Text("Advisor"),
                  )));
        })),
        const SizedBox(height: 25),
        const Text("Related Clubs",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 25),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              Text("Related Clubs"),
              // buildRelatedClubs(widget.clubCategory, widget.clubID)
            ]))
      ],
    ));
  }
}

// List<Widget> buildRelatedClubs(String category, String clubID) {
//   List<Widget> validClubs = [];
//   for (int i = 1; i < monkey.length; i++) {
//     if (monkey[i][2] == category && monkey[i][0] != clubID) {
//       // debugPrint(monkey[i][0] + " parameter id:$clubID");
//       validClubs.add(Padding(
//           padding: const EdgeInsets.only(right: 20, left: 20),
//           child: ClubCard(
//               clubName: monkey[i][1],
//               clubDay: monkey[i][3],
//               clubAdvisor: monkey[i][4],
//               clubCategory: category,
//               clubID: monkey[i][0])));
//     }
//     if (validClubs.length == 5) break;
//   }
//   return validClubs;
// }
