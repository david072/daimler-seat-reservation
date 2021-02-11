import 'package:daimler_seat_reservation/screens/login/login.dart';
import 'package:daimler_seat_reservation/util/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> initialisation = Firebase.initializeApp();

  String text = Constants.connectingToFirebase;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialisation,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          setState(() {
            text = Constants.firebaseConnectionError;
          });
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Constants.applicationTitle,
            home: Login(),
          );
        }

        return Expanded(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Container(
                  height: 25,
                ),
                Text(
                  text,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
