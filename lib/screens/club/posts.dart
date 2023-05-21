import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../clubModel.dart';
import '../../components/Posts.dart';
import '../../fb_helper.dart';
import '../../utils.dart';

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
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green[700],
          child: const Icon(Icons.add_box_rounded),
          onPressed: () {
            navigate(context, EditPost(club: widget.club));
          },
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: clubPosts(widget.club.name, widget.club.id, context),
        ));
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
                postWidgets.add(announcement(
                    clubName: postsInfo[i]['club_name'],
                    subject: postsInfo[i]['subject'],
                    body: postsInfo[i]['body'],
                    dateTimePosted: postsInfo[i]['date_time_posted'],
                    clubId: clubId,
                    postId: postsInfo[i]['id']));
              }
              if (postsInfo[i]['type'] == "Meeting") {
                postWidgets.add(upcomingMeeting(
                    clubName: postsInfo[i]['club_name'],
                    dateTimeMeeting: postsInfo[i]['date_time_meeting'],
                    location: postsInfo[i]['location'],
                    body: postsInfo[i]['body'],
                    dateTimePosted: postsInfo[i]['date_time_posted'],
                    clubId: clubId,
                    postId: postsInfo[i]['id']));
              }
            }

            return Column(children: postWidgets);
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
  final dateController = TextEditingController();
  final timeController = TextEditingController();
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
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.top,
              cursorColor: Colors.grey[600],
              maxLines: null,
              expands: true,
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
          ),
        ];
      case 1:
        return [
          Wrap(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Meeting Subject', icon: Icon(Icons.subject)),
                  onChanged: (value) {
                    subject2 = value;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(
                      hintText: '01/01/2023', icon: Icon(Icons.calendar_month)),
                  onTap: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary:
                                  green_2, // This changes the color of the button confirm
                            ),
                            buttonTheme: ButtonThemeData(
                                textTheme: ButtonTextTheme.primary),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      dateController.text =
                          DateFormat("MM-dd-yyyy").format(date);
                      meetingDate = dateController.text;
                    }
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: timeController,
                  decoration: const InputDecoration(
                      hintText: '3:45 PM', icon: Icon(Icons.watch_later)),
                  onTap: () async {
                    var time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary:
                                  green_2, // This changes the color of the button confirm
                            ),
                            buttonTheme: ButtonThemeData(
                                textTheme: ButtonTextTheme.primary),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (time != null) {
                      meetingTime = time.format(context);
                      timeController.text = meetingTime;
                      // meetingTime = timeController.text;
                    }
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
          SizedBox(height: 20),
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.top,
              cursorColor: Colors.grey[600],
              maxLines: null,
              expands: true,
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
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AlertDialog(
        insetPadding: EdgeInsets.all(15),
        contentPadding: EdgeInsets.all(12),
        actionsPadding: EdgeInsets.all(20),
        title: Text('Create a Post'),
        content: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
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
                  SizedBox(height: 1),
                ],
              ),
              ..._buildModeContent(),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel',
                style: TextStyle(
                    color: Colors.grey[500], fontWeight: FontWeight.w500)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 24, 169, 46)),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(5)),
            ),
            child: Text('Post',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            onPressed: () {
              Navigator.of(context).pop();
              _modeIndex == 0
                  ? addGeneralPost(
                      subject1,
                      _body1Controller.text,
                      widget.club.name,
                      widget.club.id,
                      _body1Controller.text.hashCode.toString())
                  : addMeetingPost(
                      subject2,
                      _body2Controller.text,
                      meetingDate,
                      meetingTime,
                      location,
                      widget.club.name,
                      widget.club.id,
                      _body2Controller.text.hashCode.toString());
            },
          ),
        ],
      ),
    );
  }
}
