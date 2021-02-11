import 'package:daimler_seat_reservation/screens/selectAction.dart';
import 'package:daimler_seat_reservation/user.dart';
import 'package:daimler_seat_reservation/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:daimler_seat_reservation/util/databaseInterface.dart';

class SelectSeat extends StatefulWidget {
  final MyUser user;
  final DateTime date;

  SelectSeat({@required this.user, @required this.date});

  @override
  _SelectSeatState createState() => _SelectSeatState();
}

class _SelectSeatState extends State<SelectSeat> {
  Size screenSize;
  List<Widget> seats = List();

  @override
  void initState() {
    getSeats();
    super.initState();
  }

  Future<void> getSeats() async {
    dbInterface
        .getSeats(widget.user, widget.date, context)
        .then((seats) => setState(() {
              this.seats = seats;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.applicationTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              child: ListView(
                children: seats,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.pink,
              width: double.infinity,
              child: Center(
                child: InteractiveViewer(
                  constrained: true,
                  child: Selector(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SeatItem extends StatelessWidget {
  final String title;
  final MyUser user;
  final DateTime date;
  final BuildContext context;

  SeatItem(
      {@required this.title,
      @required this.user,
      @required this.date,
      @required this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: Container(
              child: Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: () {
                    dbInterface.requestSeat(user, int.parse(title), date);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActionSelector(
                                  user: user,
                                )));
                  },
                  child: Text(
                    'Reservieren',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Selector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/seats_old.png'),
        ),
      ),
    );
  }
}
