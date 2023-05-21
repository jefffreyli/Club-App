import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_app/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

var db = FirebaseFirestore.instance;
User? user = FirebaseAuth.instance.currentUser;
final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
Map<String, dynamic> userData = {};
String userDocId = "";
List<String> userClubs = userData['clubs'];

Future<void> init() async {
  userData = await getUserData();
  userDocId = await getDocumentIdByEmail(currentUserEmail!);
  getAllClubs();
  await getRecentPosts();
  await clubsOnDate("05-20-2023");
}

class Authentication {
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}

Future<void> signIn(
    String emailAddress, String password, BuildContext context) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()));

  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
    init();
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
  navigatorKey.currentState!.popUntil((route) => route.isFirst);
}

Future<void> signUp(String name, String osis, String officialClass, String year,
    String emailAddress, String password, BuildContext context) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()));

  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    addUser(name, osis, officialClass, year, emailAddress, password);
    init();
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }

  navigatorKey.currentState!.popUntil((route) => route.isFirst);
}

void signOut(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()));

  FirebaseAuth.instance.signOut();

  navigatorKey.currentState!.popUntil((route) => route.isFirst);
}

Future<void> resetPassword(String email) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.sendPasswordResetEmail(email: email);
    print('Password reset email sent');
  } catch (error) {
    print('Failed to send password reset email: $error');
    throw Exception('Failed to reset password');
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

// Future<Map<String, List>> getClubByCategory(String category) async {
Future<List<Map>> getClubByCategory(String category) async {
  List<Map> clubs = [];
  await db
      .collection("clubs")
      .where("category", isEqualTo: category)
      .get()
      .then(
    (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        var docData = docSnapshot.data();
        clubs.add(docData);
        print(docData);
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
  return clubs;
}

Stream<List<Map>> getMyClubs() {
  return db
      .collection("users")
      .doc(userDocId)
      .snapshots()
      .asyncMap((snapshot) async {
    List<String> clubIds = List<String>.from(snapshot.get("clubs"));
    QuerySnapshot querySnapshot =
        await db.collection("clubs").where("id", whereIn: clubIds).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList()
        as Future<List<Map<String, dynamic>>>;
  });
}

Stream<List<Map>> getAllClubs() {
  return db.collection("clubs").snapshots().map(
      (querySnapshot) => querySnapshot.docs.map((doc) => doc.data()).toList());
}

Future<Map<String, dynamic>> getUserData() async {
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  final querySnapshot = await db
      .collection("users")
      .where("email", isEqualTo: currentUserEmail)
      .get();
  return querySnapshot.docs.first.data();
}

Future<String> getDocumentIdByEmail(String email) async {
  final QuerySnapshot snapshot =
      await db.collection('users').where('email', isEqualTo: email).get();
  final List<DocumentSnapshot> documents = snapshot.docs;
  if (documents.isNotEmpty) {
    return documents.first.id;
  } else {
    return "";
  }
}

Future<void> addUser(String full_name, String osis, String official_class,
    String graduation_year, String email, String password) async {
  try {
    var docRef = await db.collection("users").add({
      'full_name': full_name,
      'osis': osis,
      'official_class': official_class,
      'graduation_year': graduation_year,
      'email': email,
      'password': password,
      'clubs': [],
      'user_type': "Member",
      'about_me': "Hi! I'm $full_name.",
      'appearance': "light",
      'email_notifications': "true",
      'image_url':
          "https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg",
      'mobile_notifications': "true",
    });
    print("User added.");
    // await getUserData();
  } catch (error) {
    print("Failed to add user: $error");
  }
}

Future<void> editUserData(Map<String, dynamic> user) async {
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

  final documentId = await getDocumentIdByEmail(currentUserEmail!);

  await db
      .collection("users")
      .doc(documentId)
      .update(user)
      .then((value) => print("User updated"))
      .catchError((error) => print("Failed to update user: $error"));
}

Future<void> joinClub(String clubId) async {
  final documentId = await getDocumentIdByEmail(currentUserEmail!);
  final clubDocId = await getClubDocumentId(clubId);

  await db
      .collection("users")
      .doc(documentId)
      .update({
        "clubs": FieldValue.arrayUnion([clubId])
      })
      .then((value) => print("Club added to user"))
      .catchError((error) => print("Failed to update club for user: $error"));

  await db
      .collection("clubs")
      .doc(clubDocId)
      .update({
        "members": FieldValue.arrayUnion([userData['osis']])
      })
      .then((value) => print("Member added to club"))
      .catchError((error) => print("Failed to add member to club: $error"));
}

Future<void> leaveClub(String clubId) async {
  final documentId = await getDocumentIdByEmail(currentUserEmail!);
  final clubDocId = await getClubDocumentId(clubId);

  await db
      .collection("users")
      .doc(documentId)
      .update({
        "clubs": FieldValue.arrayRemove([clubId])
      })
      .then((value) => print("Left club"))
      .catchError((error) => print("Failed to leave club: $error"));

  await db
      .collection("clubs")
      .doc(clubDocId)
      .update({
        "members": FieldValue.arrayRemove([userData['osis']])
      })
      .then((value) => print("Member removed from the club"))
      .catchError(
          (error) => print("Failed to remove member from the club: $error"));
}

Future<void> takeAttendance(
    List<String> osis, String date, String clubID) async {
  final clubDocId = await getClubDocumentId(clubID);

  for (int i = 0; i < osis.length; i++) {
    await db
        .collection("clubs")
        .doc(clubDocId)
        .collection("attendance")
        .doc()
        .set({"osis": "${osis[i]}", "date": '$date'});
  }
}

Future<String> getClubNameById(String id) async {
  final snapshot =
      await db.collection('clubs').where('id', isEqualTo: int.parse(id)).get();
  if (snapshot.docs.isNotEmpty) {
    return snapshot.docs.first.data()['name'];
  } else {
    return "Couldn't find club";
  }
}

Future<String> getClubDocumentId(String id) async {
  final QuerySnapshot snapshot =
      await db.collection('clubs').where('id', isEqualTo: int.parse(id)).get();
  if (snapshot.docs.isNotEmpty) {
    return snapshot.docs.first.id;
  } else {
    return "Couldn't find club";
  }
}

Stream<bool> presentOnDate(String date, String clubId, String osis) {
  return getClubDocumentId(clubId).asStream().flatMap((clubDocId) {
    return db
        .collection("clubs")
        .doc(clubDocId)
        .collection("attendance")
        .where("osis", isEqualTo: osis)
        .where("date", isEqualTo: date)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.isNotEmpty);
  });
}

Future<Map<String, dynamic>> getPersonData(String osis) async {
  final querySnapshot =
      await db.collection("users").where("osis", isEqualTo: osis).get();
  return querySnapshot.docs.first.data();
}

Future<Map<String, dynamic>> getPersonDataByFullName(String fullName) async {
  final querySnapshot = await db
      .collection("users")
      .where("full_name", isEqualTo: fullName)
      .get();
  return querySnapshot.docs.first.data();
}

// posts

// Future<void> addGeneralPost(String subject, String body, String clubName,
//     String clubId, String postId) async {
//   final clubDocId = await getClubDocumentId(clubId);
//   DateTime curr = DateTime.now();
//   String formattedDate = DateFormat('MM-dd-yyyy HH:mm').format(curr);

//   await db
//       .collection("clubs")
//       .doc(clubDocId)
//       .collection("posts")
//       .doc(postId)
//       .set({
//     "subject": subject,
//     "body": body,
//     "type": "General",
//     "date_time_posted": formattedDate,
//     'id': postId,
//     'club_id': clubId,
//     'club_name': clubName
//   });
// }

Future<void> addGeneralPost(String subject, String body, String clubName,
    String clubId, String postId) async {
  DateTime curr = DateTime.now();
  String formattedDate = DateFormat('MM-dd-yyyy HH:mm').format(curr);

  await db.collection("posts").doc(postId).set({
    "subject": subject,
    "body": body,
    "type": "General",
    "date_time_posted": formattedDate,
    'id': postId,
    'club_id': clubId,
    'club_name': clubName
  });
}

// Future<void> addMeetingPost(
//     String subject,
//     String body,
//     String date,
//     String time,
//     String location,
//     String clubName,
//     String clubId,
//     String postId) async {
//   final clubDocId = await getClubDocumentId(clubId);
//   DateTime curr = DateTime.now();
//   String formattedDate = DateFormat('MM-dd-yyyy HH:mm').format(curr);

//   await db
//       .collection("clubs")
//       .doc(clubDocId)
//       .collection("posts")
//       .doc(postId)
//       .set({
//     "subject": subject,
//     "body": body,
//     "location": location,
//     "type": "Meeting",
//     "date_time_meeting": date + " - " + time,
//     "date_time_posted": formattedDate,
//     'id': postId,
//     'club_id': clubId,
//     'club_name': clubName
//   });
// }

Future<void> addMeetingPost(
    String subject,
    String body,
    String date,
    String time,
    String location,
    String clubName,
    String clubId,
    String postId) async {
  final clubDocId = await getClubDocumentId(clubId);
  DateTime curr = DateTime.now();
  String formattedDate = DateFormat('MM-dd-yyyy HH:mm').format(curr);

  await db.collection("posts").doc(postId).set({
    "subject": subject,
    "body": body,
    "location": location,
    "type": "Meeting",
    "date_time_meeting": "$date - $time",
    "date_time_posted": formattedDate,
    'id': postId,
    'club_id': clubId,
    'club_name': clubName
  });
}

Future<void> deletePost(String clubId, String postId) async {
  db.collection("posts").doc(postId).delete();
}

// Future<Stream<List<Map>>> getClubPosts(String clubId) async {
//   final clubDocId = await getClubDocumentId(clubId);
//   return db
//       .collection("clubs")
//       .doc(clubDocId)
//       .collection("posts")
//       .snapshots()
//       .map((querySnapshot) =>
//           querySnapshot.docs.map((doc) => doc.data()).toList());
// }

Future<Stream<List<Map>>> getClubPosts(String clubId) async {
  final clubDocId = await getClubDocumentId(clubId);
  return db.collection("posts").snapshots().map(
      (querySnapshot) => querySnapshot.docs.map((doc) => doc.data()).toList());
}

// Future<List<Map<String, dynamic>>> getRecentPosts() async {
//   List<Map<String, dynamic>> posts = [];

//   List clubIds = userData['clubs'];
//   for (int i = 0; i < clubIds.length; i++) {
//     final clubDocId = await getClubDocumentId(clubIds[i]);
//     var clubPosts = await db
//         .collection("clubs")
//         .doc(clubDocId)
//         .collection("posts")
//         .get()
//         .then((querySnapshot) =>
//             querySnapshot.docs.map((doc) => doc.data()).toList());

//     posts.addAll(clubPosts);
//   }
//   return posts;
// }

Future<List<Map<String, dynamic>>> getRecentPosts() async {
  List<Map<String, dynamic>> posts = [];

  List clubIds = userData['clubs'];
  for (int i = 0; i < clubIds.length; i++) {
    var clubPosts = await db.collection("posts").get().then((querySnapshot) =>
        querySnapshot.docs.map((doc) => doc.data()).toList());

    posts.addAll(clubPosts);
  }
  return posts;
}

Future<List<Map<String, dynamic>>> getPresentMembers(
    String clubId, String osis, String date) async {
  List<Map<String, dynamic>> presentMemberData = [];
  final clubDocId = await getClubDocumentId(clubId);

  final querySnapshots = await db
      .collection("clubs")
      .doc(clubDocId)
      .collection("attendance")
      .where("osis", isEqualTo: osis)
      .where("date", isEqualTo: date)
      .get();

  List presentOsis =
      querySnapshots.docs.map((doc) => doc['osis'] as String).toList();
  for (int i = 0; i < presentOsis.length; i++) {
    Map<String, dynamic> memberData = await getPersonData(presentOsis[i]);
    presentMemberData.add(memberData);
  }

  return presentMemberData;
}

Future<void> updateSettings({
  String? appearance,
  String? emailNotifications,
  String? mobileNotifications,
}) async {
  Map<String, dynamic> updates = {};
  if (appearance != null) {
    updates['appearance'] = appearance;
    userData['appearance'] = appearance;
  }
  if (emailNotifications != null) {
    updates['email_notifications'] = emailNotifications;
    userData['email_notifications'] = emailNotifications;
  }
  if (mobileNotifications != null) {
    updates['mobile_notifications'] = mobileNotifications;
    userData['mobile_notifications'] = mobileNotifications;
  }

  db.collection('users').doc(userDocId).update(updates);
}

// Future<List<Map<String, dynamic>>> clubsOnDate(String date) async {
//   List<Map<String, dynamic>> matchingClubs = [];

//   // Get all clubs
//   var clubSnapshot = await db.collection('clubs').get();
//   List clubs = clubSnapshot.docs.map((doc) => doc.data()).toList();

//   for (int i = 0; i < clubs.length; i++) {
//     var club = clubs[i];
//     String clubId = (club['id']).toString();
//     String clubDocId = await getClubDocumentId(clubId.toString());

//     var postsSnapshot =
//         await db.collection('clubs').doc(clubDocId).collection('posts').get();
//     var posts = postsSnapshot.docs.map((doc) => doc.data()).toList();
//     if (posts.isEmpty) {
//       continue;
//     }

//     // Search in posts for the matching date
//     for (var post in posts) {
//       if (post['date_time_meeting'] == null) continue;
//       if (post['date_time_meeting'].toString().contains(date)) {
//         matchingClubs.add(club);
//         break;
//       }
//     }
//   }

//   return matchingClubs;
// }

Future<List<Map<String, dynamic>>> clubsOnDate(String date) async {
  List<Map<String, dynamic>> matchingClubs = [];
  Set<String> matchingClubIds = {};

  // Get all posts
  var postsSnapshot = await db.collection('posts').get();
  var posts = postsSnapshot.docs.map((doc) => doc.data()).toList();

  // Search in posts for the matching date
  for (var post in posts) {
    if (post['date_time_meeting'] != null &&
        post['date_time_meeting'].toString().contains(date)) {
      matchingClubIds.add(
          post['clubId']); // Assuming each post has a reference to its club
    }
  }

  // Get all clubs
  var clubSnapshot = await db.collection('clubs').get();
  List clubs = clubSnapshot.docs.map((doc) => doc.data()).toList();

  // Filter clubs that have a matching post
  for (var club in clubs) {
    if (matchingClubIds.contains(club['id'])) {
      matchingClubs.add(club);
    }
  }

  return matchingClubs;
}
