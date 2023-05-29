import 'dart:async';
import '../screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/signin.dart';
import '/fb_helper.dart';
import 'screens/splash.dart';
import 'utils.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: green_2),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Colors.grey[800]),
      ),
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
                  return LoadingCircle();
                } else if (snapshot.hasData) {
                  return const Home();
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
