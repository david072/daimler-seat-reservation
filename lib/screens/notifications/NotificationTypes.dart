import 'package:daimler_seat_reservation/util/constants.dart';
import 'package:daimler_seat_reservation/util/databaseInterface.dart';
import 'package:daimler_seat_reservation/util/util.dart';
import 'package:flutter/material.dart';

class NormalNotification extends StatelessWidget {
  final String title;
  final String message;
  final String id;

  final Function refresh;

  NormalNotification(
      {@required this.id,
      @required this.title,
      @required this.message,
      @required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          Container(
            height: 10,
          ),
          Text(
            message,
          ),
          Container(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                child: Text(
                  Constants.markRead,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  dbInterface.deleteNotification(id);
                  refresh();
                },
              ),
            ],
          ),
          Seperator(),
        ],
      ),
    );
  }
}

class AcceptableNotification extends StatelessWidget {
  final String title;
  final String message;
  final String id;

  final Function refresh;

  final int seatID;
  final DateTime date;
  final String ownerUID;

  AcceptableNotification(
      {@required this.id,
      @required this.title,
      @required this.message,
      @required this.seatID,
      @required this.date,
      @required this.ownerUID,
      @required this.refresh});

  Future<void> acceptReservation(BuildContext context) async {
    Util.showSnackbar(context, Constants.acceptedReservation);
    await dbInterface.acceptSeatReservation(seatID, ownerUID, id, date);
    refresh();
  }

  Future<void> refuseSeatReservation(BuildContext context) async {
    Util.showSnackbar(context, Constants.refusedReservation);
    await dbInterface.refuseSeatReservation(seatID, ownerUID, id, date);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          Container(
            height: 10,
          ),
          Text(
            message,
          ),
          Container(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                child: Text(
                  Constants.acceptReservation,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  acceptReservation(context);
                },
              ),
              Container(
                width: 20,
              ),
              FlatButton(
                child: Text(
                  Constants.refuseReservation,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  refuseSeatReservation(context);
                },
              ),
            ],
          ),
          Seperator(),
        ],
      ),
    );
  }
}

class Seperator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      color: Colors.black12,
      width: double.infinity,
      height: 1,
    );
  }
}
