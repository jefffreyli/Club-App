import 'package:club_app_frontend/components/ClubCardHorizontal.dart';
import 'package:club_app_frontend/components/SectionTab.dart';
import 'package:flutter/material.dart';

import '../clubModel.dart';
import '../components/Header.dart';
import '../utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: nav("Home"),
        drawer: sidebar(context),
        body: Container(
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: (SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  const SizedBox(height: 30),
                  // const Text("Club Categories",
                  //     textAlign: TextAlign.left,
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 30,
                  //     )),
                  // const SizedBox(height: 25),
                  // sectionTabs(),

                  // const SizedBox(height: 75),

                  //my clubs
                  const Text("My Clubs",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      )),
                  const SizedBox(height: 25),
                  myClubs(),

                  const SizedBox(height: 75),
                ])))));
  }

  Widget sectionTabs() {
    List<Widget> tabs = [];

    for (int i = 0; i < 10; i++) {
      tabs.add(SectionTab(tabIcon: 'assets/logo.png', tabName: "Tab $i"));
    }
    return (SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: Row(children: tabs)));
  }

  Widget myClubs() {
    List<Widget> clubWidgets = [];

    for (int i = 0; i < 10; i++) {
      clubWidgets.add(ClubCardHorizontal(
          // clubName: "Club Name",
          // clubDay: "Monday",
          // clubAdvisor: "Ms. Qiu",
          // clubCategory: "STEM",
          // clubID: "16",
          club: Club(
              name: "Club Name",
              day: "Monday",
              advisorName: "Ms. Qiu",
              advisorEmail: "qiuw@bxscience.edu",
              category: "STEM",
              id: "16",
              description: "awdl waij lajdlaj dklwj alkjd wlkaj lkj.",
              president: "President",
              vicePresident: "Vice President",
              secretary: "Seceretary")));
    }
    return (Column(children: clubWidgets));
  }
}
