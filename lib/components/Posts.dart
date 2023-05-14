import 'package:club_app/fb_helper.dart';
import 'package:flutter/material.dart';

Widget announcement(String clubName, String subject, String body,
    String dateTimePosted, String clubId, String postId) {
  return Card(
    elevation: 2,
    child: Stack(
      children: [
        Container(
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
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              Text(
                body,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "Posted " + dateTimePosted,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              deletePost(clubId, postId);
            },
          ),
        ),
      ],
    ),
  );
}

Widget upcomingMeeting(String clubName, String dateTime, String location,
    String description, String dateTimePosted, String clubId, String postId) {
  return Card(
    elevation: 2,
    child: Stack(
      children: [
        Container(
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
                'Meeting Description',
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
                  "Posted " + dateTimePosted,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              deletePost(clubId, postId);
            },
          ),
        ),
      ],
    ),
  );
}
