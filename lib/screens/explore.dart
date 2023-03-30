import 'package:club_app_frontend/fb_helper.dart';
import 'package:flutter/material.dart';
import '../clubModel.dart';
import '../components/ClubCardSquare.dart';
import '../components/Header.dart';
import '../components/Search.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _Explore();
}

class _Explore extends State<Explore> {
  String search = '';
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
                    searchClub(),
                    SizedBox(height: 10),
                    allTabs(),
                    SizedBox(height: 10),
                    allClubs(context, search),
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
          print(clubsInfo);

          for (int i = 0; i < clubsInfo.length; i++) {
            // if (searched.isEmpty) {
            //   clubWidgets.add(ClubCardSquare(
            //       club: Club(
            //           name: clubsInfo[i]['name'],
            //           day: clubsInfo[i]['day'],
            //           advisorName: clubsInfo[i]['advisor_name'],
            //           advisorEmail: clubsInfo[i]['advisor_email'],
            //           category: clubsInfo[i]['category'],
            //           id: clubsInfo[i]['id'].toString(),
            //           description: clubsInfo[i]['description'],
            //           president: clubsInfo[i]['president'],
            //           vicePresident: clubsInfo[i]['vice_president'],
            //           secretary: clubsInfo[i]['secretary'])));
            //   continue;
            // }
            // if (clubsInfo[i]['name'].toLowerCase().contains(searched)) {
            clubWidgets.add(ClubCardSquare(
                club: Club(
                    name: clubsInfo[i]['name'],
                    day: clubsInfo[i]['day'],
                    advisorName: clubsInfo[i]['advisor_name'],
                    advisorEmail: clubsInfo[i]['advisor_email'],
                    category: clubsInfo[i]['category'],
                    id: clubsInfo[i]['id'].toString(),
                    description: clubsInfo[i]['description'],
                    president: clubsInfo[i]['president'],
                    vicePresident: clubsInfo[i]['vice_president'],
                    secretary: clubsInfo[i]['secretary'])));
            // }
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

  Widget searchClub() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            labelText: 'Search a Club',
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: (text) {
            setState(() => search = text.toLowerCase());
          },
        ),
      ],
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
