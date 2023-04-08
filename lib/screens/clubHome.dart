import '../components/PersonCardHorizontal.dart';
import '../components/Posts.dart';
import '../fb_helper.dart';
import 'package:flutter/material.dart';
import '../components/Nav.dart';
import '../components/Tag.dart';
import '../person.dart';
import 'attendance.dart';
import '../clubModel.dart';
import '../utils.dart';
import 'posts.dart';

class ClubHome extends StatefulWidget {
  final Club club;
  const ClubHome({super.key, required this.club});

  @override
  State<ClubHome> createState() => _ClubHomeState();
}

class _ClubHomeState extends State<ClubHome> {
  var w, h;
  int selectedIndex = 0;
  double margin = 0;

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;

    if (w < 600)
      margin = 15;
    else if (w < 900)
      margin = 60;
    else
      margin = 75;

    List<Widget> widgetOptions = [
      clubDetails("assets/logo.png", context),
      Posts(club: widget.club),
      Attendance(club: widget.club),
      FutureBuilder<Widget>(
        future: people(context),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(
                  children: [const SizedBox(height: 25), snapshot.data!]);
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    ];

    void _onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.grey[700],
        elevation: 1,
        backgroundColor: Colors.grey[100],
        title: Text(
          widget.club.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: sidebar(context),
      body: Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: widgetOptions.elementAt(selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.grey[800],
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.announcement), label: "Posts"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Attendance"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "People")
        ],
      ),
    );
  }

  Widget clubDetails(String image, BuildContext context) {
    return (SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.only(left: margin, right: margin),
      child: Column(
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
              tag(widget.club.day, Colors.blue[800]!, Colors.blue[50]!),
              const SizedBox(width: 10),
              tag(widget.club.category, yellowOrangeDark, yellowOrange),
              const SizedBox(width: 10),
              tag(widget.club.location, Colors.red[800]!, Colors.red[50]!),
            ],
          ),
          const SizedBox(height: 50),
          const Text("Overview", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          Text(widget.club.description),
          const SizedBox(height: 25),
          const Text("Leaders", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          leadership(context),
          // FutureBuilder<Widget>(
          //   future: leadership(context),
          //   builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       if (snapshot.hasError) {
          //         return Text('Error: ${snapshot.error}');
          //       } else {
          //         return Column(children: [snapshot.data!]);
          //       }
          //     } else {
          //       return Center(child: CircularProgressIndicator());
          //     }
          //   },
          // ),

          const SizedBox(height: 50),
        ],
      ),
    )));
  }

  Widget attendance(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 10),
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
        ));
  }

  Future<Widget> people(BuildContext context) async {
    List<Widget> memberWidgets = [];
    List memberOsis = widget.club.members;

    for (int i = 0; i < memberOsis.length; i++) {
      Map<String, dynamic> memberData = await getPersonData(memberOsis[i]);
      Person p = Person(
        name: (memberData['full_name'] ?? "Name"),
        email: (memberData['email'] ?? "Email"),
        userType: (memberData['user_type'] ?? "User Type"),
        graduationYear: (memberData['graduation_year'] ?? "Graduation Year"),
        aboutMe: (memberData['about_me'] ?? "About Me"),
        imageURL: (memberData['image_url'] ?? fillerNetworkImage),
      );

      Widget memberWidget = personCardHorizontal(p, context, false);
      memberWidgets.add(memberWidget);
    }
    return Container(
      margin: EdgeInsets.only(right: 30, left: 30),
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: memberWidgets)),
    );
  }

  Widget leadership(BuildContext context) {
    List<Widget> leadershipWidgets = [];
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

    for (int i = 0; i < leaders.length; i++) {
      // Map<String, dynamic> leadershipData =
      //     await getPersonDataByFullName(leaders[i]);
      Person p = Person(
        name: (leaders[i]),
        email: ("Email"),
        userType: ("Leadership"),
        graduationYear: ("Graduation Year"),
        aboutMe: ("About Me"),
        imageURL: (fillerNetworkImage),
      );

      Widget leadershipWidget =
          personCardHorizontal(p, context, false, positions[i]);
      leadershipWidgets.add(leadershipWidget);
    }
    return Container(
      // margin: EdgeInsets.only(right: 50, left: 50),
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: leadershipWidgets)),
    );
  }
}
