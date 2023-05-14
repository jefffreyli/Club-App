import 'dart:async';
import 'dart:html';
import '../screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/signin.dart';
import '/fb_helper.dart';
import 'screens/splash.dart'; // Import your SplashScreen widget

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
  init();
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // darkTheme: ThemeData.dark(),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.grey[50],
          textTheme: GoogleFonts.nunitoSansTextTheme(
            Theme.of(context).textTheme,
          )),
      home: FutureBuilder<void>(
        future: _waitThreeSeconds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Splash();
          } else {
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return Home();
                } else {
                  return SignIn();
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _waitThreeSeconds() async {
    await Future.delayed(Duration(seconds: 3));
  }
}
