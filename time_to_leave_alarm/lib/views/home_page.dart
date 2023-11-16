import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';

import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:intl/intl.dart';
import 'package:time_to_leave_alarm/controllers/api/requests/calculate_distance.dart';
import 'package:time_to_leave_alarm/controllers/api/widgets/AutoCompleteTextField.dart';
import 'package:time_to_leave_alarm/controllers/api/secrets.dart';

class MyHomePage extends StatefulWidget {
  static const route = '/';

  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final fromController = TextEditingController();
  final toController = TextEditingController();

  var travel_time;
  DateTime? time_to_arrive;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  void openMap() {
    Navigator.pushNamed(context, '/map');
  }

  timeToLeave() {
    if (travel_time != null && time_to_arrive != null) {
      var leave = time_to_arrive!.subtract(Duration(seconds: travel_time));
      return Text("Leave at: " + DateFormat('dd/MM/yyyy HH:mm').format(leave));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              placesAutoCompleteTextField('From', fromController),
              placesAutoCompleteTextField('To', toController),
              timefield('Arrive at'),
              ElevatedButton(
                  onPressed: () => calculateDistance(
                        origin: fromController.text.toString(),
                        destination: toController.text.toString(),
                        then: (time) {
                          setState(() {
                            travel_time = time;
                          });
                        },
                      ),
                  child: const Text("Submit")),
              timeToLeave(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openMap,
        child: const Icon(Icons.map),
      ),
    );
  }

  timefield(String label) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(label),
          width: 65,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.grey, width: 0.6),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: DateTimeField(
                  decoration: const InputDecoration(
                    hintText: 'Select date and time',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  selectedDate: time_to_arrive,
                  onDateSelected: (DateTime value) {
                    setState(() {
                      time_to_arrive = value;
                    });
                  }),
            ),
          ),
        ),
      ],
    );
  }

  placesAutoCompleteTextField(String label, TextEditingController controller) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(label),
          width: 65,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: AutoCompleteTextField(
              controller: controller,
              hintText: "Search your location",
            ),
          ),
        ),
      ],
    );
  }
}
