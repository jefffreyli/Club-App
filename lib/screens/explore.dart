import 'package:club_app_frontend/fb_helper.dart';
import 'package:flutter/material.dart';
import '../components/ClubCardSquare.dart';
import '../components/Header.dart';
import '../components/Search.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: nav("Explore"),
        drawer: sidebar(context),
        body: SafeArea(
            child: Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Search(),
                    SizedBox(height: 10),
                    allTabs(),
                    SizedBox(height: 10),
                    allClubs(context, t1.text),
                  ],
                ))));
  }

  Widget allClubs(BuildContext context, String searched) {
    return StreamBuilder<List<Map>>(
      stream: getAllClubs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Map> clubsInfo = snapshot.data!;
          List<Widget> clubWidgets = [];

          for (int i = 0; i < clubsInfo.length; i++) {
            if (searched == '') {
              clubWidgets.add(ClubCardSquare(
                clubName: clubsInfo[i]['name'],
                clubDay: clubsInfo[i]['day'],
                clubAdvisor: clubsInfo[i]['advisor'],
                clubCategory: clubsInfo[i]['category'],
                clubID: clubsInfo[i]['id'],
              ));
              continue;
            } if (searched == clubsInfo[i]['name']) {
              clubWidgets.add(ClubCardSquare(
                clubName: clubsInfo[i]['name'],
                clubDay: clubsInfo[i]['day'],
                clubAdvisor: clubsInfo[i]['advisor'],
                clubCategory: clubsInfo[i]['category'],
                clubID: clubsInfo[i]['id'],
              ));
            }
          }

          var w = MediaQuery.of(context).size.width;
          int crossAxisCount = (w / 500).ceil();

          return Expanded(
            child: GridView.count(
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: crossAxisCount,
              children: clubWidgets,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error retrieving clubs: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget allTabs() {
    List<Widget> tabs = [];

    for (int i = 0; i < 10; i++) {
      tabs.add(Container(
          margin: EdgeInsets.only(right: 5),
          color: Colors.grey[300],
          child: TextButton(
              onPressed: () {},
              child: Text(
                "Tab $i",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ))));
    }
    return (SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: Row(children: tabs)));
  }
}
