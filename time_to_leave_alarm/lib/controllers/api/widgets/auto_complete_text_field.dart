import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:time_to_leave_alarm/controllers/api/secrets.dart';

class AutoCompleteTextField extends StatelessWidget {
  const AutoCompleteTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.textStyle,
      this.disabled = false});

  final TextEditingController controller;
  final String hintText;
  final TextStyle? textStyle;
  final bool disabled;

  Widget buildMock(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: TextField(
            controller: controller,
            style: textStyle ?? const TextStyle(),
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            readOnly: disabled));
  }

  Widget buildApi(BuildContext context) {
    return GooglePlaceAutoCompleteTextField(
      textStyle: textStyle ?? const TextStyle(),
      boxDecoration: const BoxDecoration(),
      textEditingController: controller,
      googleAPIKey: googleAutocompleteAPIKey,
      inputDecoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      debounceTime: 400,
      countries: const ["pt"],
      isLatLngRequired: false,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        print("placeDetails${prediction.lat}");
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
              Expanded(child: Text(prediction.description ?? ""))
            ],
          ),
        );
      },

      isCrossBtnShown: false,
      // default 600 ms ,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (googleAutocompleteAPIKey == '') {
      return buildMock(context);
    } else {
      if (disabled) return buildMock(context);
      return buildApi(context);
    }
  }
}
