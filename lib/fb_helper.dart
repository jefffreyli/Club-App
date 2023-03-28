import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

var db = FirebaseFirestore.instance;
Map<String, dynamic> userData = {};

void init() async {
  userData = await getUserData();
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
    print("Signed in!");
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

Stream<List<Map>> getAllClubs() {
  return db.collection("clubs").snapshots().map(
      (querySnapshot) => querySnapshot.docs.map((doc) => doc.data()).toList());
}

Future<void> test() async {
  if (FirebaseAuth.instance.currentUser != null) {
    print(FirebaseAuth.instance.currentUser?.uid);
  }
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

Future<void> addUserData(Map<String, dynamic> user) async {
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

  final documentId = await getDocumentIdByEmail(currentUserEmail!);

  await db
      .collection("users")
      .doc(documentId)
      .update(user)
      .then((value) => print("User added"))
      .catchError((error) => print("Failed to update user: $error"));
}

Future<void> editUserData(Map<String, dynamic> user) async {
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

  final documentId = await getDocumentIdByEmail(currentUserEmail!);

  await db
      .collection("users")
      .doc(documentId)
      .update(user)
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
}

