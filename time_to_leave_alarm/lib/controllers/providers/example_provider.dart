import 'dart:collection';

import 'package:flutter/material.dart';


class ExampleProvider with ChangeNotifier {

  List<int> _examples = [];

  UnmodifiableListView<int> get examples => UnmodifiableListView(_examples);

  fetchExamples() {
    _examples = [];
    notifyListeners();
  }
}