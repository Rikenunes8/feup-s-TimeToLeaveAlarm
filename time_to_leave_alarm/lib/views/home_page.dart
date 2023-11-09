import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:google_places_flutter/google_places_flutter.dart';

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
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              placesAutoCompleteTextField('From', fromController),
              placesAutoCompleteTextField('To', toController),
              ElevatedButton(
                  onPressed: () => submitRequest(),
                  child: const Text("Submit")),
              Text(time_to_leave)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openMap,
        child: const Icon(Icons.map),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  placesAutoCompleteTextField(String label, TextEditingController controller) {
    Container textField = Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: GooglePlaceAutoCompleteTextField(
          textEditingController: controller,
          googleAPIKey: "",
          inputDecoration: const InputDecoration(
            hintText: "Search your location",
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
          debounceTime: 400,
          countries: ["pt"],
          isLatLngRequired: false,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            print("placeDetails" + prediction.lat.toString());
          },

          itemClick: (Prediction prediction) {
            controller.text = prediction.description ?? "";
            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description?.length ?? 0));
          },
          seperatedBuilder: const Divider(),
          // OPTIONAL// If you want to customize list view item builder
          itemBuilder: (context, index, Prediction prediction) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(
                    width: 7,
                  ),
                  Expanded(child: Text("${prediction.description ?? ""}"))
                ],
              ),
            );
          },

          isCrossBtnShown: true,

          // default 600 ms ,
        ));

    return Row(
      children: <Widget>[
        Container(
          child: Text(label),
          width: 50,
        ),
        Expanded(child: textField),
      ],
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
