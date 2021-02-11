import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daimler_seat_reservation/screens/notifications/NotificationTypes.dart';
import 'package:daimler_seat_reservation/screens/reserve/selectSeat.dart';
import 'package:daimler_seat_reservation/user.dart';
import 'package:flutter/material.dart';

class DatabaseInterface {
  final FirebaseFirestore firestore;

  final CollectionReference seatsCollection;
  final CollectionReference notificationsCollection;

  DatabaseInterface()
      : this.firestore = FirebaseFirestore.instance,
        this.seatsCollection = FirebaseFirestore.instance.collection('seats'),
        this.notificationsCollection =
            FirebaseFirestore.instance.collection('notifications');

  // --- Functions ---

  Future<List<Widget>> getSeats(
      MyUser user, DateTime date, BuildContext context) async {
    QuerySnapshot seats = await seatsCollection.get();

    int currentID = 1;
    List<DocumentSnapshot> docs = List();
    for (int i = 0; i < seats.docs.length; i++) {
      for (DocumentSnapshot snap in seats.docs) {
        List<dynamic> dList = snap.data()['reservedDates'];
        List<String> reservedDates = dList.cast<String>().toList();

        if (reservedDates.isNotEmpty &&
            reservedDates.contains(date.toIso8601String())) {
          continue;
        }

        if (snap.data()['id'] == currentID) {
          docs.add(snap);
        }
      }

      currentID++;
    }

    List<Widget> result = List();
    for (DocumentSnapshot snapshot in docs) {
      result.add(SeatItem(
        context: context,
        user: user,
        date: date,
        title: snapshot.data()['id'].toString(),
      ));
    }

    return result;
  }

  Future<void> requestSeat(MyUser user, int seatID, DateTime date) async {
    seatsCollection.where('id', isEqualTo: seatID).get().then((snapshot) {
      updateDocuments(snapshot.docs[0], 1, date, true, false);
    });

    String day = date.day <= 9 ? '0${date.day}' : '${date.day}';
    String month = date.month <= 9 ? '0${date.month}' : '${date.month}';
    String requestedDate = day + '.' + month + '.' + date.year.toString();

    await notificationsCollection.add({
      'title': 'Sitzplatz anfrage:',
      'message':
          '${user.firebaseUser.displayName} möchte den Sitzplatz Nummer $seatID für den Tag $requestedDate reservieren.',
      'addressants': [UserRole.SEAT_ADMIN.firebaseID],
      'date': date.toIso8601String(),
      'requestor': user.firebaseUser.uid,
      'seatID': seatID,
      'type': 1,
    });
  }

  Future<List<Widget>> getNotifications(
      String uid, UserRole role, Function refresh) async {
    QuerySnapshot notifications = await notificationsCollection
        .where('addressants', arrayContainsAny: [uid, role.firebaseID]).get();

    List<Widget> result = List();
    for (DocumentSnapshot snapshot in notifications.docs) {
      if (snapshot.data()['type'] == 0) {
        String title = snapshot.data()['title'];
        String message = snapshot.data()['message'];

        result.add(NormalNotification(
          id: snapshot.id,
          title: title,
          message: message,
          refresh: refresh,
        ));
      } else if (snapshot.data()['type'] == 1) {
        String title = snapshot.data()['title'];
        String message = snapshot.data()['message'];

        String requestor = snapshot.data()['requestor'];
        DateTime date = DateTime.parse(snapshot.data()['date']);
        int seatID = snapshot.data()['seatID'];

        result.add(AcceptableNotification(
          id: snapshot.id,
          date: date,
          message: message,
          ownerUID: requestor,
          seatID: seatID,
          title: title,
          refresh: refresh,
        ));
      }
    }

    return result;
  }

  Future<void> acceptSeatReservation(
      int seatID, String uid, String id, DateTime date) async {
    QuerySnapshot snapshot =
        await seatsCollection.where('id', isEqualTo: seatID).get();

    if (snapshot.size > 0) {
      // In this case, 'add' (the second last argument) doesn't matter,
      // because it's a status only update
      updateDocuments(snapshot.docs[0], 2, date, false, true);

      await notificationsCollection.add({
        'addressants': [uid],
        'message':
            'Deine Sitzplatz Reservierung für den Platz Nummer $seatID wurde akzeptiert.',
        'title': 'Sitzplatz Reservierung akzeptiert!',
        'type': 0,
      });

      await notificationsCollection.doc(id).delete();
    } else {
      print('Invalid ID!');
    }
  }

  Future<void> refuseSeatReservation(
      int seatID, String uid, String id, DateTime date) async {
    QuerySnapshot snapshot =
        await seatsCollection.where('id', isEqualTo: seatID).get();

    if (snapshot.size > 0) {
      updateDocuments(snapshot.docs[0], 0, date, false, false);

      await notificationsCollection.add({
        'addressants': [uid],
        'message':
            'Deine Sitzplatz Reservierung für den Platz Nummer $seatID wurde verweigert.',
        'title': 'Sitzplatz Reservierung verweigert!',
        'type': 0,
      });

      await notificationsCollection.doc(id).delete();
    } else {
      print('Invalid ID!');
    }
  }

  Future<void> deleteNotification(String id) async {
    await notificationsCollection.doc(id).delete();
  }

  Future<void> updateDocuments(DocumentSnapshot document, int newStatus,
      DateTime additionalReservedDate, bool add, bool isStatusUpdate) async {
    await updateDocument(
        document, additionalReservedDate, newStatus, add, isStatusUpdate);

    List<dynamic> dList = document.data()['dependsOn'];
    List<int> dependsOnIDs = dList.cast<int>().toList();
    if (dependsOnIDs[0] == -1) {
      return;
    }

    for (int id in dependsOnIDs) {
      QuerySnapshot query =
          await seatsCollection.where('id', isEqualTo: id).get();
      await updateDocument(query.docs[0], additionalReservedDate, newStatus,
          add, isStatusUpdate);
    }
  }

  Future<void> updateDocument(DocumentSnapshot document, DateTime reservedDate,
      int newStatus, bool add, bool statusUpdate) async {
    List<dynamic> dList = document.data()['reservedDates'];
    List<String> reservedDates = dList.cast<String>().toList();

    dList = document.data()['statuses'];
    List<int> statuses = dList.cast<int>().toList();

    if (!statusUpdate) {
      if (!add) {
        int index = reservedDates.indexOf(reservedDate.toIso8601String());
        if (index != -1) {
          statuses.removeAt(index);
          reservedDates.removeAt(index);
        }
      } else {
        reservedDates.add(reservedDate.toIso8601String());
        statuses.add(newStatus);
      }
    } else {
      int index = reservedDates.indexOf(reservedDate.toIso8601String());
      if (index != -1) {
        statuses[index] = newStatus;
      }
    }

    await document.reference.update({
      'statuses': statuses,
      'reservedDates': reservedDates,
    });
  }
}

DatabaseInterface dbInterface = DatabaseInterface();
