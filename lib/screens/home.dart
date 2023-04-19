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
                  recentPosts("MSA", "77", context),
                  // upcomingMeeting(
                  //     "Club Name",
                  //     "April 12, 2023 - 10:00 AM",
                  //     "331",
                  //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam in massa id sapien finibus congue sed vel nulla. Sed ac magna sed lacus aliquam pulvinar vitae sit amet purus. Vestibulum lobortis massa nec sapien eleifend efficitur. Nullam pellentesque tincidunt orci, eu facilisis dolor dignissim nec. Proin vel mi a sapien bibendum lobortis eget eu eros. In hac habitasse platea dictumst. Sed blandit in tellus et blandit.',
                  //     "April 10, 2023 - 9:34 AM"),
                  // announcement(
                  //     "Club Name",
                  //     "Materials",
                  //     "Here are the materials from today. Look over them and get ready for next week. As always, email our instructors with any questions!",
                  //     "April 10, 2023 - 9:34 AM"),
                  const SizedBox(height: 100),
                ])))));
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

  Widget recentPosts(String clubName, String clubId, BuildContext context) {
    return FutureBuilder<Stream<List<List<Map>>>>(
      future: getRecentPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return StreamBuilder<List<List<Map>>>(
            stream: snapshot.data!,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.data);
                return Text('${snapshot.error}');
              }

              print(snapshot.data);

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              List<List<Map>> postsInfo = snapshot.data!;
              List<Widget> postWidgets = [];

              for (int club = 0; club < postsInfo.length; club++) {
                for (int i = 0; i < postsInfo.length; i++) {
                  if (postsInfo[club][i]['type'] == "General") {
                    postWidgets.add(announcement(
                        clubName,
                        postsInfo[club][i]['subject'],
                        postsInfo[club][i]['body'],
                        postsInfo[club][i]['date_time_posted']));
                  }
                  if (postsInfo[club][i]['type'] == "Meeting") {
                    postWidgets.add(upcomingMeeting(
                        clubName,
                        postsInfo[club][i]['date_time_meeting'],
                        postsInfo[club][i]['location'],
                        postsInfo[club][i]['body'],
                        postsInfo[club][i]['date_time_posted']));
                  }
                }
              }

              return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: postWidgets));
            });
      },
    );
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
}
