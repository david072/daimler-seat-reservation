import 'package:daimler_seat_reservation/user.dart';
import 'package:daimler_seat_reservation/util/constants.dart';
import 'package:daimler_seat_reservation/util/databaseInterface.dart';
import 'package:flutter/material.dart';

class ViewNotifications extends StatefulWidget {
  final MyUser user;

  ViewNotifications({@required this.user});

  @override
  _ViewNotificationsState createState() => _ViewNotificationsState();
}

class _ViewNotificationsState extends State<ViewNotifications> {
  List<Widget> notifications = List();

  Future<void> getNotifications() async {
    print('refreshing');
    dbInterface
        .getNotifications(widget.user.firebaseUser.uid, widget.user.role,
            () => getNotifications())
        .then((notifications) => setState(() {
              this.notifications = notifications;
            }));
  }

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Constants.applicationTitle,
          style: TextStyle(fontSize: 19),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () => getNotifications(),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: notifications,
        ),
      ),
    );
  }
}
