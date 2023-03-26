import 'package:club_app_frontend/screens/explore.dart';
import 'package:club_app_frontend/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:club_app_frontend/utils.dart';
import '../fb_helper.dart';
import '../screens/home.dart';
import '../screens/profile.dart';

Widget sidebar(BuildContext context) {
  var h = MediaQuery.of(context).size.height;
  return Drawer(
    child: Column(
      children: [
        SizedBox(
          height: 150,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                Transform.translate(
                  offset:
                      Offset(0, -10), // move the CircleAvatar up by 25 pixels
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("assets/funnymonkeylips.png"),
                  ),
                ),
                SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jeffrey Li',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'lij12@bxscience.edu',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: const Text('Home'),
          leading: Icon(Icons.home),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Profile'),
          leading: Icon(Icons.person),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Profile(),
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Explore'),
          leading: Icon(Icons.explore),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Explore(),
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Attendance'),
          leading: Icon(Icons.calendar_month),
          onTap: () {
            getClubByCategory("Sports");
            Navigator.pop(context);
          },
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
        ),
        ListTile(
          title: const Text('Sign Out'),
          leading: Icon(
            Icons.exit_to_app_rounded,
            color: Colors.red[300],
          ),
          onTap: () {
            signOut();
          },
        ),
      ],
    ),
  );
}

AppBar nav = AppBar(
  foregroundColor: Colors.grey[700],
  elevation: 2,
  toolbarHeight: 50,
  backgroundColor: Colors.grey[100],
  title: Text("$appName",
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
  centerTitle: true,
);
