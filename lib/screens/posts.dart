import 'package:flutter/material.dart';

import '../clubModel.dart';
import '../components/Posts.dart';
import '../fb_helper.dart';
import '../utils.dart';

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
          navigate(context, EditPost(club: widget.club));
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
                postWidgets.add(upcomingMeeting(
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

class EditPost extends StatefulWidget {
  final Club club;
  const EditPost({super.key, required this.club});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  int _modeIndex = 0; // 0 for General mode, 1 for Meeting mode

  final _body1Controller = TextEditingController();
  final _body2Controller = TextEditingController();
  String subject1 = '';
  // String body1 = '';
  String subject2 = '';
  // String body2 = '';
  String meetingDate = "";
  String meetingTime = "";
  String location = "";

  List<Widget> _buildModeContent() {
    switch (_modeIndex) {
      case 0:
        return [
          TextFormField(
              decoration: InputDecoration(hintText: 'Meeting Subject'),
              onChanged: (value) {
                subject1 = value;
              },
            ),
          const SizedBox(height: 15),
          TextField(
            cursorColor: Colors.grey[600],
            maxLines: (h / 45).ceil(),
            controller: _body1Controller,
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
              hintText: "Body Text",
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
          ),
        ];
      case 1:
        return [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'Meeting Subject'),
                  onChanged: (value) {
                    subject2 = value;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: '01/01/2023', icon: Icon(Icons.calendar_month)),
                  onChanged: (value) {
                    meetingDate = value;
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: '3:45 PM', icon: Icon(Icons.watch_later)),
                  onChanged: (value) {
                    meetingTime = value;
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Meeting Location',
                      icon: Icon(Icons.location_city)),
                  onChanged: (value) {
                    location = value;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          TextField(
            cursorColor: Colors.grey[600],
            maxLines: (h / 45).ceil(),
            controller: _body2Controller,
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
              hintText: "Body Text",
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
            Navigator.of(context).pop();
            _modeIndex == 0
                ? addGeneralPost(subject1, _body1Controller.text, widget.club.id)
                : addMeetingPost(subject2, _body2Controller.text, meetingDate, meetingTime,
                    location, widget.club.id);
          },
        ),
      ],
    );
  }
}
