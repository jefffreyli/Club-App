import 'package:flutter/material.dart';
import '../components/ClubCardSquare.dart';
import '../components/Header.dart';
import '../components/Search.dart';
import 'dart:math' as math;

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: nav,
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
                    allClubs(context),
                  ],
                ))));
  }

  Widget allClubs(BuildContext context) {
    List<Widget> clubWidgets = [];

    for (int i = 0; i < 25; i++) {
      clubWidgets.add(const ClubCardSquare(
        clubName: "Club Name",
        clubDay: "Monday",
        clubAdvisor: "Ms. Qiu",
        clubCategory: "STEM",
        clubID: "16",
      ));
    }
    var w = MediaQuery.of(context).size.width;
    int crossAxisCount = (w / 500).ceil();

    // return (Column(children: clubWidgets));
    return Expanded(
        child: GridView.count(
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: crossAxisCount,
            children: clubWidgets));
  }

  Widget allTabs() {
    List<Widget> tabs = [];

    for (int i = 0; i < 10; i++) {
      tabs.add(Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(right: 5),
          color: Colors.grey[300],
          child: Text(
            "Tab $i",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          )));
    }
    return (SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: Row(children: tabs)));
  }
}
