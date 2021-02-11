import 'package:daimler_seat_reservation/screens/login/emailVerification.dart';
import 'package:daimler_seat_reservation/screens/login/signup.dart';
import 'package:daimler_seat_reservation/screens/selectAction.dart';
import 'package:daimler_seat_reservation/user.dart';
import 'package:daimler_seat_reservation/util/authentification.dart';
import 'package:daimler_seat_reservation/util/constants.dart';
import 'package:daimler_seat_reservation/util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  Future<void> login() async {
    FormState state = formKey.currentState;
    if (state.validate()) {
      state.save();

      dynamic result = await Authentication().login(email, password);
      if (result is FirebaseAuthException) {
        if (result.code == 'user-not-found') {
          Util.showSnackbar(context, Constants.userNotFoundError);
          return;
        } else if (result.code == 'account-exists-with-different-credential') {
          Util.showSnackbar(context, Constants.differentCredentials);
          return;
        }

        print(result.message);
        Util.showSnackbar(context, Constants.loginError);
        return;
      } else if (result is MyUser) {
        MyUser user = result;
        print("Successfully logged in: ${user.firebaseUser.displayName}");

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
        leading: Container(),
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
                    Constants.login_page_login,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Container(
                  height: 25,
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
                          GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()))
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Du hast noch keinen Account? ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: 'Sign up!',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 15,
                          ),
                          MaterialButton(
                            onPressed: () => login(),
                            textColor: Colors.white,
                            color: Colors.blue,
                            minWidth: double.infinity,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10000),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: const Text(Constants.login_page_login,
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
