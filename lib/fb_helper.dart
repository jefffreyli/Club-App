import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

var db = FirebaseFirestore.instance;
final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
Map<String, dynamic> userData = {};
String userDocId = "";

void init() async {
  userData = await getUserData();
  userDocId = await getDocumentIdByEmail(currentUserEmail!);
  getAllClubs();
}

Future<void> signIn(String emailAddress, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

Future<void> createAccount(String emailAddress, String password) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
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
      'appearance': "dark",
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

Future<void> addClub(String clubId) async {
  final documentId = await getDocumentIdByEmail(currentUserEmail!);

  await db
      .collection("users")
      .doc(documentId)
      .update({
        "clubs": FieldValue.arrayUnion([clubId])
      })
      .then((value) => print("Club added"))
      .catchError((error) => print("Failed to update club: $error"));
}

Future<void> takeAttendance(
    List<String> osis, String date, String clubID) async {
  print(clubID);
  String clubDocId = await getClubDocumentId(clubID);
  // String clubDocId = "0LGa9MMNP3pBVzB46qx0";
  print(clubDocId);

  // for (int i = 0; i < osis.length; i++) {
  //   await db
  //       .collection("clubs")
  //       .doc("$clubDocId")
  //       .collection("attendance")
  //       .doc("${osis[i]}")
  //       .set({"osis": "${osis[i]}", "date": '$date'});
  // }
}

Future<String> getClubDocumentId(String id) async {


  final QuerySnapshot snapshot =
      await db.collection('clubs').where('id', isEqualTo: id).get();
  final List<DocumentSnapshot> documents = snapshot.docs;
  if (documents.isNotEmpty) {
    return documents.first.id;
  } else {
    return "";
  }
}
