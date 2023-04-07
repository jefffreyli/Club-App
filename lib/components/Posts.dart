import 'package:club_app/fb_helper.dart';
import 'package:flutter/material.dart';

Widget announcement(
    String clubName, String subject, String body, String dateTimePosted) {
  return Card(
    elevation: 2,
    child: Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            clubName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 15),
          const SizedBox(height: 10),
          Text(
            subject,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              dateTimePosted,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: Colors.grey),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget upcomingEvent(String clubName, String dateTime, String location,
    String description, String dateTimePosted) {
  return Card(
    elevation: 2,
    child: Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            clubName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.blue[500],
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                dateTime,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Colors.red[500],
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                location,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
          const Divider(height: 15),
          const SizedBox(height: 10),
          const Text(
            'Event Description',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              dateTimePosted,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: Colors.grey),
            ),
          ),
        ],
      ),
    ),
  );
}

// Widget clubPosts() {
//   return SingleChildScrollView(
//     scrollDirection: Axis.vertical,
//     child: Column(
//       children: List.generate(3, (int index) {
//         return Column(
//           children: [
//             upcomingEvent(
//               "Club Name",
//               "April 12, 2023 - 10:00 AM",
//               "331",
//               'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam in massa id sapien finibus congue sed vel nulla. Sed ac magna sed lacus aliquam pulvinar vitae sit amet purus. Vestibulum lobortis massa nec sapien eleifend efficitur. Nullam pellentesque tincidunt orci, eu facilisis dolor dignissim nec. Proin vel mi a sapien bibendum lobortis eget eu eros. In hac habitasse platea dictumst. Sed blandit in tellus et blandit.',
//               "April 10, 2023 - 9:34 AM",
//             ),
//             announcement(
//               "Club Name",
//               "Materials",
//               "Here are the materials from today. Look over them and get ready for next week. As always, email our instructors with any questions!",
//               "April 10, 2023 - 9:34 AM",
//             ),
//           ],
//         );
//       }),
//     ),
//   );
// }

Widget clubPosts(String clubName, String clubId, BuildContext context) {
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
              postWidgets.add(announcement(
                  clubName,
                  postsInfo[i]['subject'],
                  postsInfo[i]['body'],
                  postsInfo[i]['date_time_posted']));
            }
            if (postsInfo[i]['type'] == "Meeting") {
              postWidgets.add(upcomingEvent(
                  clubName,
                  postsInfo[i]['date_time_meeting'],
                  postsInfo[i]['location'],
                  postsInfo[i]['body'],
                  postsInfo[i]['date_time_posted']));
            }
          }

          return SingleChildScrollView(scrollDirection: Axis.vertical, child: Column(children: postWidgets));
        },
      );
    },
  );
}

