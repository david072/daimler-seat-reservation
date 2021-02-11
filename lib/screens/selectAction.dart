import 'package:daimler_seat_reservation/screens/login/login.dart';
import 'package:daimler_seat_reservation/screens/notifications/viewNotifications.dart';
import 'package:daimler_seat_reservation/screens/reserve/chooseDate.dart';
import 'package:daimler_seat_reservation/user.dart';
import 'package:daimler_seat_reservation/util/authentification.dart';
import 'package:daimler_seat_reservation/util/constants.dart';
import 'package:flutter/material.dart';

class ActionSelector extends StatelessWidget {
  final MyUser user;

  ActionSelector({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(Constants.applicationTitle),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChooseDate(
                              user: user,
                            )));
              },
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10000),
              ),
              child: Text(
                Constants.reserveSeat,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            Container(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewNotifications(user: user)));
              },
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10000),
              ),
              child: Text(
                Constants.viewNotifications,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            Container(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                Authentication().logout();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10000),
              ),
              child: Text(
                Constants.logout,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
