import 'package:club_app_frontend/components/Header.dart';
import 'package:flutter/material.dart';
import 'signin.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

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
        appBar: nav,
        drawer: sidebar(context),
        body: Column(children: [
          Container(
              margin: EdgeInsets.fromLTRB(25, 75, 25, 25), child: actual()),
        ]));
  }

  Widget actual() {
    return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Padding(
          padding: const EdgeInsets.all(10),
          child: CircleAvatar(
              radius: 50,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.asset("assets/funnymonkeylips.png")))),
      Text("Jeffrey Li",
          style: const TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500)),
      const SizedBox(height: 5),
      Text("lij12@bxscience.edu",
          style: const TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500)),
      const SizedBox(height: 5),
      Text("222445629",
          style: const TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w300)),
      const SizedBox(height: 15),
      buildProfile(),
      const SizedBox(height: 15),
      // TextButton(
      //     style: ElevatedButton.styleFrom(
      //       shape:
      //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //       backgroundColor: Colors.red[600],
      //     ),
      //     onPressed: () async {
      //       // await FirebaseAuth.instance.signOut();
      //       // print("signed out");
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => SignIn()),
      //       );
      //     },
      //     child: Container(
      //       padding: const EdgeInsets.all(10),
      //       width: 500,
      //       child: const Text('Sign Out',
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //               fontSize: 15.0,
      //               fontWeight: FontWeight.w400,
      //               color: Colors.white)),
      //     ))
    ]));
  }

  Future<Future> _displayAboutDialog(BuildContext context) async {
    TextEditingController nameController1 = TextEditingController();

    final formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            insetPadding: const EdgeInsets.all(20),
            backgroundColor: Colors.white,
            title: const Text(
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
                'Change Your Information'),
            content: SizedBox(
                width: width / 2,
                height: height / 4,
                child: Form(
                    key: formKey,
                    child: Column(children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 10),
                          child: TextFormField(
                            maxLines: 5,
                            controller: nameController1,
                            decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                                labelText: 'Confirm Your Details',
                                labelStyle: TextStyle(color: Colors.black)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter the new Details';
                              }
                              return null;
                            },
                          )),
                    ]))),
            actions: <Widget>[
              // add button
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: Text('Confirm',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[400])),
                onPressed: () {
                  // setState(() {
                  //   if (formKey.currentState!.validate()) {
                  //     fb.updateAboutMe(nameController1.text);
                  //     Navigator.of(context).pop();
                  //   }
                  // });
                },
              ),
              // Cancel button
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: Text('Cancel',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[400])),
                onPressed: () {
                  Navigator.of(context).pop();
                  nameController1.clear();
                },
              )
            ],
          );
        });
  }

  Widget buildProfile() {
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
          subtitle: Text("2023"),
        ),
        const Divider(),
        GestureDetector(
            onTap: (() => _displayAboutDialog(context)),
            child: ListTile(
              trailing: const Icon(Icons.edit),
              tileColor: Colors.grey[50],
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(Icons.person),
              title: const Text('About You',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Founder, CEO of SciClubs"),
            )),
        const Divider(),
        // buildClubsDiff()
      ],
    ));
  }
}
