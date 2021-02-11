import 'package:daimler_seat_reservation/screens/login/emailVerification.dart';
import 'package:daimler_seat_reservation/screens/selectAction.dart';
import 'package:daimler_seat_reservation/user.dart';
import 'package:daimler_seat_reservation/util/authentification.dart';
import 'package:daimler_seat_reservation/util/constants.dart';
import 'package:daimler_seat_reservation/util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String displayName = '';
  String email = '';
  String password = '';

  Future<void> signUp() async {
    FormState state = formKey.currentState;
    if (state.validate()) {
      state.save();

      dynamic result =
          await Authentication().signUp(displayName, email, password);
      if (result is FirebaseAuthException) {
        print(result.message);
        Util.showSnackbar(context, Constants.loginError);
        return;
      } else if (result is MyUser) {
        MyUser user = result;
        print(
            "Successfully registered and logged in: ${user.firebaseUser.displayName}");

        if (user.firebaseUser.emailVerified) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ActionSelector(
                        user: user,
                      )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Verification(
                        user: user,
                      )));
        }
      } else {
        print("Unexpected type!");
        Util.showSnackbar(context, Constants.loginError);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.applicationTitle),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 30),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Constants.signUp_page_signUp,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Container(
                  height: 25,
                ),
                TextFormField(
                  onChanged: (String newName) => setState(() {
                    displayName = newName;
                  }),
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Bitte gib deinen Namen an.';
                    }

                    return null;
                  },
                  decoration: InputDecoration(hintText: Constants.name),
                ),
                Container(
                  height: 15,
                ),
                TextFormField(
                  onChanged: (String newEmail) => setState(() {
                    email = newEmail;
                  }),
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Bitte gib deine E-Mail an.';
                    } else if (!input.contains('@')) {
                      return 'Die E-Mail muss ein "@" enthalten!';
                    }

                    return null;
                  },
                  decoration: InputDecoration(hintText: Constants.eMail),
                ),
                Container(
                  height: 15,
                ),
                TextFormField(
                  onChanged: (String newPassword) => setState(() {
                    password = newPassword;
                  }),
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Bitte gib dein Passwort an.';
                    } else if (input.length < 8) {
                      return 'Das Passwort muss mindestens 8 Zeichen lang sein!';
                    }

                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(hintText: Constants.password),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 15,
                          ),
                          MaterialButton(
                            onPressed: () => signUp(),
                            textColor: Colors.white,
                            color: Colors.blue,
                            minWidth: double.infinity,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10000),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: const Text(Constants.signUp_page_signUp,
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
