import '../components/ClubCardHorizontal.dart';
import '../components/Posts.dart';
import '../components/SectionTab.dart';
import '../fb_helper.dart';
import 'package:flutter/material.dart';

import '../clubModel.dart';
import '../components/Nav.dart';
import '../components/Posts.dart';

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

                //my clubs
                const Text("My Clubs",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                    )),
                const SizedBox(height: 25),
                myClubs(context),

                const SizedBox(height: 50),

                //posts
                const Text("Posts",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                    )),
                const SizedBox(height: 25),
                clubPosts("Club Name", "77"),
                // recentPosts(),

                const SizedBox(height: 100),
              ],
            )))));
  }

  // Widget sectionTabs() {
  //   List<Widget> tabs = [];

  //   for (int i = 0; i < 10; i++) {
  //     tabs.add(SectionTab(tabIcon: 'assets/logo.png', tabName: "Tab $i"));
  //   }
  //   return (SingleChildScrollView(
  //       scrollDirection: Axis.horizontal, child: Row(children: tabs)));
  // }

  Widget myClubs(BuildContext context) {
    return StreamBuilder<List<Map>>(
        stream: getAllClubs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<Map> clubsInfo = snapshot.data!;
          List<Widget> myClubWidgets = [];
          List myClubIds = userData['clubs'];

          for (int i = 0; i < clubsInfo.length; i++) {
            if (myClubIds.contains((clubsInfo[i]["id"].toString() ?? ""))) {
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
                      secretary: clubsInfo[i]['secretary'] ?? "",
                      location: (clubsInfo[i]['location']).toString() ?? "")));
            }
          }
          return (Column(children: myClubWidgets));
        });
  }

  Widget clubPosts(String clubName, String clubId) {
    return FutureBuilder<Stream<List<Map>>>(
      future: getClubPosts(clubId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return StreamBuilder<List<Map>>(
          stream: snapshot.data!,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            List<Map> postsInfo = snapshot.data!;
            List<Widget> postWidgets = [];

            for (int i = 0; i < postsInfo.length; i++) {
              if (postsInfo[i]['type'] == "General") {
                postWidgets.add(announcement(clubName, postsInfo[i]['subject'],
                    postsInfo[i]['body'], postsInfo[i]['date_time_posted']));
              }
              if (postsInfo[i]['type'] == "Meeting") {
                postWidgets.add(upcomingMeeting(
                    clubName,
                    postsInfo[i]['date_time_meeting'],
                    postsInfo[i]['location'],
                    postsInfo[i]['body'],
                    postsInfo[i]['date_time_posted']));
              }
            }

            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: postWidgets));
          },
        );
      },
    );
  }

  Widget recentPosts() {
    return FutureBuilder<Map<String, dynamic>>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        Map<String, dynamic> data = snapshot.data!;
        List<String> userClubs = data['clubs'];
        List<Widget> recentPostsWidgets = [];
        print(userClubs);

        for (int i = 0; i < userClubs.length; i++) {
          String clubId = userData['clubs'][i];
          recentPostsWidgets.add(clubPosts("clubName", clubId));
        }

        return Column(children: recentPostsWidgets);
      },
    );
  }
}

  // Widget recentPosts(BuildContext context) {
  //   return StreamBuilder<List<Map<String, dynamic>>>(
  //     stream: getRecentPosts("1"),
  //     builder: (context, snapshot) {
  //       print("hi");
  //       print(snapshot.data!);
  //       if (snapshot.hasError) {
  //         return Text('${snapshot.error}');
  //       }

  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(child: CircularProgressIndicator());
  //       }

  //       List<Map<String, dynamic>> postsInfo = snapshot.data!;
  //       List<Widget> postWidgets = [];

  //       for (int i = 0; i < postsInfo.length; i++) {
  //         if (postsInfo[i] == null) continue; // Add null check

  //         if (postsInfo[i]['type'] == "General") {
  //           postWidgets.add(
  //             announcement(
  //               (postsInfo[i]['name']) ?? "",
  //               (postsInfo[i]['subject']) ?? "",
  //               (postsInfo[i]['body']) ?? "",
  //               (postsInfo[i]['date_time_posted'].toDate()) ?? "",
  //             ),
  //           );
  //         }
  //         if (postsInfo[i]['type'] == "Meeting") {
  //           postWidgets.add(
  //             upcomingMeeting(
  //               postsInfo[i]['name'] ?? "",
  //               postsInfo[i]['meeting_date_time'].toDate() ?? "",
  //               postsInfo[i]['location'] ?? "",
  //               postsInfo[i]['body'] ?? "",
  //               postsInfo[i]['date_time_posted'].toDate() ?? "",
  //             ),
  //           );
  //         } else {
  //           return Text("Error");
  //         }
  //       }

  //       return SingleChildScrollView(
  //         scrollDirection: Axis.vertical,
  //         child: Column(children: postWidgets),
  //       );
  //     },
  //   );
  // }

