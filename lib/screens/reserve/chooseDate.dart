import 'package:daimler_seat_reservation/screens/reserve/selectSeat.dart';
import 'package:daimler_seat_reservation/screens/selectAction.dart';
import 'package:daimler_seat_reservation/user.dart';
import 'package:daimler_seat_reservation/util/constants.dart';
import 'package:daimler_seat_reservation/util/util.dart';
import 'package:flutter/material.dart';

class ChooseDate extends StatefulWidget {
  final MyUser user;

  ChooseDate({@required this.user});

  @override
  _ChooseDateState createState() => _ChooseDateState();
}

class _ChooseDateState extends State<ChooseDate> {
  DateTime date;
  String text = '';

  Future<void> pickDate() async {
    date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    setState(() {
      if (date.day == null || date.month == null || date.year == null) {
        text = '';
        date = null;
        return;
      }

      String day = date.day <= 9 ? '0${date.day}' : "${date.day}";
      String month = date.month <= 9 ? '0${date.month}' : "${date.month}";
      text = 'Datum: $day.$month.${date.year}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ActionSelector(
                          user: widget.user,
                        )));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              if (date != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectSeat(
                              user: widget.user,
                              date: date,
                            )));
              } else {
                Util.showSnackbar(context, 'Bitte wähle zuerst ein Datum.');
              }
            },
          ),
        ],
        title: Text(
          Constants.applicationTitle,
          style: TextStyle(fontSize: 19),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Container(
              height: 15,
            ),
            MaterialButton(
              onPressed: () {
                pickDate();
              },
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Text(
                'Datum auswählen...',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
