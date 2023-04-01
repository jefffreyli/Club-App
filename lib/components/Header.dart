import 'package:club_app_frontend/screens/explore.dart';
import 'package:club_app_frontend/screens/settings.dart';
import 'package:club_app_frontend/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:club_app_frontend/utils.dart';
import '../fb_helper.dart';
import '../screens/home.dart';
import '../screens/profile.dart';

Widget sidebar(BuildContext context) {
  var h = MediaQuery.of(context).size.height;
  return Drawer(
      child: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Column(
      children: [
        SizedBox(
          height: 100,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    '${userData['image_url']}',
                  ),
                ),
                SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${userData['full_name']}',
                      // 'Jeffrey Li',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${userData['email']}',
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
          title: const Text('Settings'),
          leading: Icon(Icons.settings),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Settings(),
              ),
            );
          },
        ),
        // ListTile(
        //   title: const Text('Help Center'),
        //   leading: Icon(Icons.help),
        //   onTap: () {
        //     Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (context) => Settings(),
        //       ),
        //     );
        //   },
        // ),
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
  ));
}

PreferredSizeWidget? nav(String title) {
  return AppBar(
    foregroundColor: Colors.grey[700],
    elevation: 1,
    backgroundColor: Colors.grey[100],
    title: Text("$title",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    centerTitle: true,
  );
}
// AppBar nav = AppBar(
//   foregroundColor: Colors.grey[700],
//   elevation: 1,
//   backgroundColor: Colors.grey[100],
//   title: Text("$appName",
//       style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//   centerTitle: true,
// );
