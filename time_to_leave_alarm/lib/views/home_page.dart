import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';

import 'package:google_places_flutter/google_places_flutter.dart';
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

  var time_to_leave = '';

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
              ElevatedButton(
                  onPressed: () => calculateDistance(
                        origin: fromController.text.toString(),
                        destination: toController.text.toString(),
                        then: (time) {
                          setState(() {
                            time_to_leave = time.toString();
                          });
                        },
                      ),
                  child: const Text("Submit")),
              Text(time_to_leave)
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

  placesAutoCompleteTextField(String label, TextEditingController controller) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(label),
          width: 50,
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
