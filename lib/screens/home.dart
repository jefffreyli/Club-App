import '../components/ClubCardHorizontal.dart';
import '../components/Posts.dart';
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
            child: RefreshIndicator(
              onRefresh: _handleRefresh, // callback for refresh
              child: SingleChildScrollView(
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
                  // clubPosts("Club Name", "77"),
                  recentPosts(),

                  const SizedBox(height: 100),
                ],
              )),
            )));
  }

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

  Widget recentPosts() {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: getRecentPosts(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (snapshot.data == null) {
        return Center(child: Text('No data yet'));
      }

      List<Map<String, dynamic>> data = snapshot.data!;
      List<Widget> recentPostsWidgets = [];

      for (int i = 0; i < data.length; i++) {
        if (data[i]['type'] == "General") {
          recentPostsWidgets.add(announcement(
              clubName: data[i]['club_name'],
              subject: data[i]['subject'],
              body: data[i]['body'],
              dateTimePosted: data[i]['date_time_posted'],
              clubId: data[i]['clubId'],
              postId: data[i]['id'],
              showDelete: false ) );
        } else if (data[i]['type'] == "Meeting") {
          recentPostsWidgets.add(upcomingMeeting(
              clubName: data[i]['club_name'],
              dateTimeMeeting: data[i]['date_time_meeting'],
              body: data[i]['body'],
              dateTimePosted: data[i]['date_time_posted'],
              clubId: data[i]['clubId'],
              postId: data[i]['id'],
              showDelete: false));
        }
      }

      return Column(children: recentPostsWidgets);
    },
  );
}

  Future<void> _handleRefresh() async {
    setState(() {
      getAllClubs();
      getRecentPosts();
    });
  }
}
