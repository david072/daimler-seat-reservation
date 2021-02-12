import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daimler_seat_reservation/user.dart';
import 'package:daimler_seat_reservation/util/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth auth;

  final FirebaseFirestore firestore;
  final CollectionReference usersCollection;

  Authentication()
      : this.auth = FirebaseAuth.instance,
        this.firestore = FirebaseFirestore.instance,
        this.usersCollection = FirebaseFirestore.instance.collection('users');

  void verifyEmail(User user, Function onEmailVerified) {
    user.sendEmailVerification();

    Timer.periodic(Duration(seconds: 3), (timer) async {
      print("Checking if email has been verified...");
      await checkEmailVerified(user, timer, onEmailVerified);
    });
  }

  Future<void> checkEmailVerified(
      User user, Timer timer, Function onEmailVerified) async {
    await user.reload();
    user = auth.currentUser;
    if (user.emailVerified) {
      timer.cancel();
      onEmailVerified();
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .timeout(Duration(seconds: 10), onTimeout: () {
        return null;
      });

      if (userCredential == null) {
        throw new TimeoutException("");
      }

      String displayName = await getUserDisplayName(userCredential.user.uid);
      await userCredential.user.updateProfile(displayName: displayName);
      await userCredential.user.reload();

      UserRole role = await getUserRole(userCredential.user.uid);

      return MyUser(userCredential.user, role);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e;
    } on TimeoutException catch (e) {
      return e;
    }
  }

  Future<dynamic> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .timeout(Duration(seconds: 10), onTimeout: () {
        return null;
      });

      if (userCredential == null) {
        throw new TimeoutException("");
      }

      await userCredential.user.updateProfile(displayName: name);
      await userCredential.user.reload();

      saveUserData(auth.currentUser, UserRole.STANDARD);
      return MyUser(auth.currentUser, UserRole.STANDARD);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e;
    } on TimeoutException catch (e) {
      return e;
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<String> getUserDisplayName(String uid) async {
    QuerySnapshot snapshot =
        await usersCollection.where('uid', isEqualTo: uid).get();

    if (snapshot.size == 0) {
      return null;
    } else if (snapshot.size == 1) {
      return snapshot.docs[0].get('displayName');
    } else {
      throw Exception(Constants.multipleUserUidDocumentsError);
    }
  }

  Future<UserRole> getUserRole(String uid) async {
    QuerySnapshot snapshot =
        await usersCollection.where('uid', isEqualTo: uid).get();

    if (snapshot.size == 0) {
      return null;
    } else if (snapshot.size == 1) {
      String role = snapshot.docs[0].get('role');
      if (role == UserRole.STANDARD.firebaseID) {
        return UserRole.STANDARD;
      } else if (role == UserRole.SEAT_ADMIN.firebaseID) {
        return UserRole.SEAT_ADMIN;
      }

      throw Exception(Constants.unexpectedRole);
    } else {
      throw Exception(Constants.multipleUserUidDocumentsError);
    }
  }

  Future<void> saveUserData(User user, UserRole role) async {
    QuerySnapshot snapshot =
        await usersCollection.where('uid', isEqualTo: user.uid).get();

    if (snapshot.size == 0) {
      usersCollection.add({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'role': role.firebaseID,
      });
      return;
    } else if (snapshot.size == 1) {
      usersCollection.doc(snapshot.docs[0].id).update({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'role': role.firebaseID,
      });
      return;
    } else {
      throw Exception(Constants.multipleUserUidDocumentsError);
    }
  }
}

final Authentication anthentication = Authentication();
