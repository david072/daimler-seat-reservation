import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  final User firebaseUser;
  final UserRole role;

  MyUser(User firebaseUser, UserRole role)
      : this.firebaseUser = firebaseUser,
        this.role = role;
}

enum UserRole { STANDARD, SEAT_ADMIN }

extension UserRoleExtension on UserRole {
  String get firebaseID {
    switch (this) {
      case UserRole.STANDARD:
        return '_STANDARD';
      case UserRole.SEAT_ADMIN:
        return '_SEAT_ADMIN';
      default:
        return null;
    }
  }
}
