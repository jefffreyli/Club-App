import '../components/ClubCardHorizontal.dart';
import '../components/SectionTab.dart';
import '../fb_helper.dart';
import 'package:flutter/material.dart';

import '../clubModel.dart';
import '../components/Nav.dart';

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
                  myClubs(context),

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

  Widget myClubs(BuildContext context) {
    return StreamBuilder<List<Map>>(
        stream: getAllClubs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child:CircularProgressIndicator());
          }

          List<Map> clubsInfo = snapshot.data!;
          List<Widget> myClubWidgets = [];
          List myClubIds = userData['clubs'];

          for (int i = 0; i < clubsInfo.length; i++) {
            if (myClubIds.contains( (clubsInfo[i]["id"].toString() ?? ""))) {
              myClubWidgets.add(ClubCardHorizontal(
                  club: Club(
                      name: clubsInfo[i]['name'] ?? "",
                      day: clubsInfo[i]['day'] ?? "",
                      advisorName: clubsInfo[i]['advisor_name'] ?? "",
                      advisorEmail: clubsInfo[i]['advisor_email'] ?? "",
                      category: clubsInfo[i]['category'] ?? "",
                      members: clubsInfo[i]['members'] ?? [],
                      id: clubsInfo[i]['id'].toString(),
                      description: clubsInfo[i]['description'] ?? "",
                      president: clubsInfo[i]['president'] ?? "",
                      vicePresident: clubsInfo[i]['vice_president'] ?? "",
                      secretary: clubsInfo[i]['secretary'] ?? "")));
            }
          }
          return (Column(children: myClubWidgets));
        });
  }
}
