import 'package:flutter/material.dart';

import '../clubModel.dart';
import '../components/Posts.dart';
import '../fb_helper.dart';

var h;

class Posts extends StatefulWidget {
  final Club club;
  const Posts({super.key, required this.club});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
          children: [clubPosts(widget.club.name, widget.club.id, context)]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add_box_rounded),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String subject = '';
              String body = '';

              return PostDialog();
            },
          );
        },
      ),
    );
  }

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
                postWidgets.add(announcement(clubName, postsInfo[i]['subject'],
                    postsInfo[i]['body'], postsInfo[i]['date_time_posted']));
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

            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: postWidgets));
          },
        );
      },
    );
  }
}

class PostDialog extends StatefulWidget {
  @override
  _PostDialogState createState() => _PostDialogState();
}

class _PostDialogState extends State<PostDialog> {
  int _modeIndex = 0; // 0 for General mode, 1 for Meeting mode

  final _bodyController = TextEditingController();
  String subject = '';
  String body = '';

  List<Widget> _buildModeContent() {
    switch (_modeIndex) {
      case 0:
        return [
          TextField(
            decoration: InputDecoration(hintText: 'Subject'),
            onChanged: (value) {
              subject = value;
            },
          ),
          SizedBox(height: 15),
          TextField(
            cursorColor: Colors.grey[600],
            maxLines: (h / 45).ceil(),
            controller: _bodyController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              filled: true,
              fillColor: Colors.white,
              hoverColor: Colors.grey[50],
              hintText: "Body",
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
          ),
        ];
      case 1:
        return [
          TextField(
            decoration: InputDecoration(hintText: 'Meeting Subject'),
            onChanged: (value) {
              subject = value;
            },
          ),
          SizedBox(height: 16),
          TextField(
            cursorColor: Colors.grey[600],
            maxLines: (h / 45).ceil(),
            controller: _bodyController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              filled: true,
              fillColor: Colors.white,
              hoverColor: Colors.grey[50],
              hintText: "Meeting Notes",
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create a Post'),
      content: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _modeIndex = 0;
                    });
                  },
                  child: Text(
                    'General',
                    style: TextStyle(
                      color: _modeIndex == 0 ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _modeIndex = 1;
                    });
                  },
                  child: Text(
                    'Meeting',
                    style: TextStyle(
                      color: _modeIndex == 1 ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            ..._buildModeContent(),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Post'),
          onPressed: () {
            // Do something with subject and body
            print('Subject: $subject, Body: $body');
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
