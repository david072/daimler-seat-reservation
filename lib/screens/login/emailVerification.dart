import 'package:daimler_seat_reservation/screens/selectAction.dart';
import 'package:daimler_seat_reservation/user.dart';
import 'package:daimler_seat_reservation/util/authentification.dart';
import 'package:daimler_seat_reservation/util/constants.dart';
import 'package:flutter/material.dart';

class Verification extends StatefulWidget {
  final MyUser user;

  Verification({this.user});

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  void initState() {
    anthentication.verifyEmail(widget.user.firebaseUser, () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ActionSelector(
                    user: widget.user,
                  )));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(Constants.applicationTitle),
      ),
      body: Container(
        child: Center(
            child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Container(
                  height: 25,
                ),
                Text(
                  'Bitte verifiziere deine E-Mail',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Wir haben eine E-Mail an ${widget.user.firebaseUser.email} gesendet. Bitte klicke auf den Link in der E-Mail um deine E-Mail zu verifizieren.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
