import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

Future<void> getRingtones(Function(List<Ringtone>) then) async {
  try {
    final temp = await FlutterSystemRingtones.getRingtoneSounds();
    then(temp);
  } on PlatformException {
    debugPrint('Failed to get platform version.');
  }
}

Future<Ringtone?> findRingtoneFromTitle(String title) async {
  try {
    final temp = await FlutterSystemRingtones.getRingtoneSounds();
    try {
      return temp.firstWhere((ringtone) => ringtone.title == title);
    } on StateError {}
  } on PlatformException {
    debugPrint('Failed to get platform version.');
  }
  return null;
}