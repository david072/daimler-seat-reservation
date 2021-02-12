class Constants {
  static const String applicationTitle = 'Daimler Sitzplatz Reservierung';

  // --- Errors ---
  static const firebaseConnectionError =
      'Fehler beim Verbinden mit Firebase. Bitte kontaktiere den Administrator!';
  static const loginError =
      'Fehler beim einloggen. Bitte kontaktiere den Administator.';

  static const multipleUserUidDocumentsError =
      'More than one document for the users uid found!';
  static const unexpectedRole = 'Unexpected User role found!';

  static const noConnectionError = "Keine Internetverbindung vorhanden!";
  static const loginTimeoutError =
      "Zeitüberschreitung von 10 sekunden beim Verbinden zum Server!";

  // --- MyApp ---
  static const connectingToFirebase = 'Verbinde mit Firebase...';
  static const deletingOldReservations = 'Lösche vergangene reservationen...';

  // --- Action selector ---
  static const reserveSeat = 'Sitzplatz reservieren';
  static const viewNotifications = 'Benachrichtigungen ansehen';
  static const logout = 'Ausloggen';

  // --- Notifications ---
  static const markRead = 'Als gelesen markieren';

  static const acceptReservation = 'Genemigen';
  static const acceptedReservation = 'Anfrage genemigt!';

  static const refuseReservation = 'Verweigern';
  static const refusedReservation = 'Anfrage verweigert!';

  // --- Login + SignUp ---
  static const eMail = 'E-Mail';
  static const password = 'Passwort';
  static const name = 'Vor- und Nachname';

  // --- Login page ---
  static const userNotFoundError = 'Dieser Benutzer existiert nicht.';
  static const differentCredentials =
      'E-Mail oder Passwort sind nicht korrekt.';
  static const login_page_login = 'Login';

  // --- SignUp page ---
  static const signUp_page_signUp = 'Registrieren';
}
