import '../components/Nav.dart';
import '../screens/editProfile.dart';
import '../utils.dart';
import 'package:flutter/material.dart';
import '../person.dart';

class Profile extends StatefulWidget {
  final Person person;
  bool editable;

  Profile({super.key, required this.person, required this.editable});

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  var width;
  var height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: nav("Profile"),
        // drawer: sidebar(context),
        floatingActionButton: Container(
            margin: EdgeInsets.only(right: 5),
            child: widget.editable ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfile(),
                  ),
                );
              },
              child: Icon(Icons.edit),
              backgroundColor: green_1,
            ) : null),
        body: Container(
          margin: EdgeInsets.fromLTRB(25, 75, 25, 25),
          child: Column(children: [primary(), secondary()]),
        ));
  }

  Widget primary() {
    return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Padding(
          padding: const EdgeInsets.all(10),
          child: CircleAvatar(
              radius: 50,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.network(widget.person.imageURL)))),
      Text(widget.person.name,
          style: const TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500)),
      const SizedBox(height: 5),
      Text(widget.person.email,
          style: const TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400)),
      const SizedBox(height: 5),
      Text(widget.person.userType,
          style: const TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w300)),
      const SizedBox(height: 12),
    ]));
  }

  Widget secondary() {
    return SingleChildScrollView(
        child: Column(
      children: [
        const Divider(),
        ListTile(
          tileColor: Colors.grey[50],
          contentPadding: const EdgeInsets.all(5),
          leading: const Icon(Icons.school_rounded),
          title: const Text('Gradudation Year',
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(widget.person.graduationYear),
        ),
        const Divider(),
        ListTile(
          tileColor: Colors.grey[50],
          contentPadding: const EdgeInsets.all(5),
          leading: const Icon(Icons.person),
          title: const Text('About Me',
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(widget.person.aboutMe),
        ),
        const Divider(),
        // buildClubsDiff()
      ],
    ));
  }
}
