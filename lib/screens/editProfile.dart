import 'package:club_app_frontend/fb_helper.dart';
import 'package:flutter/material.dart';

import '../components/Header.dart';
import 'profile.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _graduationYearController =
      TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _profileController = TextEditingController();

  @override
  // void dispose() {
  //   _nameController.dispose();
  //   _emailController.dispose();
  //   _graduationYearController.dispose();
  //   _aboutMeController.dispose();
  //   _profileController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.grey[700],
        elevation: 1,
        backgroundColor: Colors.grey[100],
        title: Text("Edit Profile",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Container(
              margin: EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Profile(),
                  ));
                },
                child: Text(
                  "Done",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              )),
        ],
      ),
      drawer: sidebar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildField(_profileController, 'Profile Picture'),
            buildField(_nameController, 'Name'),
            buildField(_emailController, 'Email'),
            buildField(_graduationYearController, 'Graduation Year'),
            buildField(_aboutMeController, 'About Me'),
          ],
        ),
      ),
    );
  }
}

Widget buildField(TextEditingController t, String info) {
  if (info == "Profile Picture") {
    t.text = userData['image_url'];
  } else if (info == "Name") {
    t.text = userData['full_name'];
  } else if (info == "Email") {
    t.text = userData['email'];
  } else if (info == "Graduation Year") {
    t.text = userData['graduation_year'];
  } else if (info == "About Me") {
    t.text = userData['about_me'];
  }

  return Container(
    margin: const EdgeInsets.fromLTRB(5, 15, 5, 15),
    height: 25,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
    ),
    child: TextFormField(
      controller: t,
      decoration: InputDecoration.collapsed(
        hintText: '$info',
        hintStyle: const TextStyle(fontSize: 16.0),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your ${info.toLowerCase()}';
        }
        return null;
      },
    ),
  );
}
