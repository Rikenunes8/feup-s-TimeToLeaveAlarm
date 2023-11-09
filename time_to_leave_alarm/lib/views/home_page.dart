import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  final time_to_leave = '';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: fromController,
            ),
            TextField(
              controller: toController,
            ),
            ElevatedButton(
                onPressed: () => submitRequest(), child: Text("Submit")),
            Text(time_to_leave)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openMap,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  submitRequest() {
    final queryParameters = {
      'destinations': fromController.text.toString(),
      'origins': toController.text.toString(),
      'mode': 'driving',
      'key': '', // TODO hide key
    };
    final uri = Uri.https('maps.googleapis.com',
        '/maps/api/distancematrix/json', queryParameters);
    debugPrint(uri.toString());
    http.get(uri).then((value) {
      debugPrint(value.body);
      debugPrint(value.statusCode.toString());
    });
  }
}
