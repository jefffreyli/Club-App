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
  var w;
  String search = '';
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;

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
                    allClubs(context, searchController.text),
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
            if (searched == null || searched.isEmpty) {
              clubWidgets.add(ClubCardSquare(
                  club: Club(
                      name: clubsInfo[i]['name'] ?? "",
                      day: clubsInfo[i]['day'] ?? "",
                      advisorName: clubsInfo[i]['advisor_name'] ?? "",
                      advisorEmail: clubsInfo[i]['advisor_email'] ?? "",
                      category: clubsInfo[i]['category'] ?? "",
                      id: clubsInfo[i]['id'].toString() ?? "",
                      description: clubsInfo[i]['description'] ?? "",
                      president: clubsInfo[i]['president'] ?? "",
                      vicePresident: clubsInfo[i]['vice_president'] ?? "",
                      secretary: clubsInfo[i]['secretary'] ?? "")));
              continue;
            }

            if ((clubsInfo[i]['name'] ?? "").contains(searched)) {
              clubWidgets.add(ClubCardSquare(
                  club: Club(
                      name: clubsInfo[i]['name'] ?? "",
                      day: clubsInfo[i]['day'] ?? "",
                      advisorName: clubsInfo[i]['advisor_name'] ?? "",
                      advisorEmail: clubsInfo[i]['advisor_email'] ?? "",
                      category: clubsInfo[i]['category'] ?? "",
                      id: clubsInfo[i]['id'].toString() ?? "",
                      description: clubsInfo[i]['description'] ?? "",
                      president: clubsInfo[i]['president'] ?? "",
                      vicePresident: clubsInfo[i]['vice_president'] ?? "",
                      secretary: clubsInfo[i]['secretary'] ?? "")));
            }
          }

          var w = MediaQuery.of(context).size.width;
          int crossAxisCount = (w / 400).ceil();

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
          controller: searchController,
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              labelText: 'Search a Club',
              suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    allClubs(context, searchController.text);
                  })),
          onChanged: (text) {
            // setState(() => search = text.toLowerCase());
          },
        ),
      ],
    );
  }

  Widget allTabs() {
    List<Widget> tabs = [];
    List<String> categories = [
      "Athletics",
      "Careers",
      "Cultural/Religious",
      "Discussion",
      "Games",
      "Hobbies",
      "Performance/Art",
      "Publications",
      "Science",
      "Volunteer/Activism",
      "Activities"
    ];

    for (int i = 0; i < 10; i++) {
      tabs.add(Container(
          margin: EdgeInsets.only(right: 5),
          padding: EdgeInsets.all(5),
          color: Colors.grey[300],
          child: TextButton(
              onPressed: () {
                searchController.text = "${categories[i]}";
              },
              child: Text(
                "${categories[i]}",
                style: TextStyle(fontSize: w * 0.012, color: Colors.grey[600]),
              ))));
    }
    return (SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: Row(children: tabs)));
  }
}
