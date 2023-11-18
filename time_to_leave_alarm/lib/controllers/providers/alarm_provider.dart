import 'dart:collection';

import 'package:flutter/material.dart';


class AlarmProvider with ChangeNotifier {

  List<int> _alarms = [];

  UnmodifiableListView<int> get alarms => UnmodifiableListView(_alarms);

  fetchExamples() {
    _alarms = [];
    notifyListeners();
  }
}