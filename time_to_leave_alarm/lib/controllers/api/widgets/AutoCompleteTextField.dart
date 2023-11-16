import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:time_to_leave_alarm/controllers/api/secrets.dart';

class AutoCompleteTextField extends StatelessWidget {
  const AutoCompleteTextField(
      {Key? key,
      required this.controller,
      required this.hintText})
      : super(key: key);

  final TextEditingController controller;
  final String hintText;

  Widget buildMock(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.grey, width: 0.6),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      )
    );
  }

  Widget buildApi(BuildContext context) {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: controller,
      googleAPIKey: googleAutocompleteAPIKey,
      inputDecoration: InputDecoration(
        hintText: hintText,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    if (googleAutocompleteAPIKey == '') {
      return buildMock(context);
    } else {
      return buildApi(context);
    }
  }
}
