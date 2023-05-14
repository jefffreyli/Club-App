import 'package:flutter/material.dart';

import '../../components/Nav.dart';
import '../../components/PersonCardHorizontal.dart';
import '../../fb_helper.dart';
import '../../person.dart';
import '../../utils.dart';

class MembersPresent extends StatefulWidget {
  final date;
  final clubId;
  const MembersPresent({super.key, required this.date, required this.clubId});

  @override
  State<MembersPresent> createState() => _MembersPresentState();
}

class _MembersPresentState extends State<MembersPresent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: nav(widget.date.toString()),
        drawer: sidebar(context),
        body: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20, right: 25, left: 25),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getPresentMembers(
                  widget.clubId, userData['osis'], widget.date),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show a loading spinner while waiting
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    children: snapshot.data!.map((memberData) {
                      Person p = Person(
                        name: (memberData['full_name'] ?? "Name"),
                        email: (memberData['email'] ?? "Email"),
                        userType: (memberData['user_type'] ?? "User Type"),
                        graduationYear: (memberData['graduation_year'] ??
                            "Graduation Year"),
                        aboutMe: (memberData['about_me'] ?? "About Me"),
                        imageURL:
                            (memberData['image_url'] ?? fillerNetworkImage),
                      );

                      return personCardHorizontal(p, context, false);
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ));
  }
}
