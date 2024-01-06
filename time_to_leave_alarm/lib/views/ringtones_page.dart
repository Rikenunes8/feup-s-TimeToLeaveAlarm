import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';
import 'package:time_to_leave_alarm/controllers/ringtone_manager.dart';
import 'package:uri_to_file/uri_to_file.dart';

class RingtonesPage extends StatefulWidget {
  static const route = '/ringtones';

  const RingtonesPage({super.key});

  @override
  State<RingtonesPage> createState() => _RingtonesPageState();
}

class _RingtonesPageState extends State<RingtonesPage> {
  FlutterSoundPlayer? player = FlutterSoundPlayer();
  Ringtone? ringtonePlaying;
  List<Ringtone> ringtones = [];

  @override
  void initState() {
    super.initState();
    getRingtones((temp) => {
      setState(() {
        ringtones = temp;
      })
    });
  }

  @override
  void dispose() {
    if (player != null && player!.isPlaying) {
      player!.stopPlayer();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Select a ringtone"),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: ListView.builder(
                itemCount: ringtones.length+1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Card(
                        child: ListTile(
                          title: GestureDetector(
                            onTap: () => Navigator.pop(context, ''),
                            child: const Text("Default ringtone"),
                          ),
                          leading: const Icon(Icons.block),
                        ));
                  }
                  final ringtone = ringtones[index-1];
                  return Card(
                    child: ListTile(
                      title: GestureDetector(
                        onTap: () => Navigator.pop(context, ringtone.title),
                        child: Text(ringtone.title),
                      ),
                      leading: ringtonePlaying == ringtone
                          ? _buildPlayingRingtone(ringtone)
                          : _buildStoppedRingtone(ringtone),
                    ),
                  );
                }),
          ),
        ));
  }

  Widget _buildStoppedRingtone(Ringtone ringtone) {
    return GestureDetector(
        onTap: () async {
          player = await player?.openAudioSession();
          File file = await toFile(ringtone.uri);
          player?.startPlayer(
              fromDataBuffer: await file.readAsBytes(),
              codec: Codec.defaultCodec,
              whenFinished: () {
                setState(() {
                  ringtonePlaying = null;
                });
              });
          setState(() {
            ringtonePlaying = ringtone;
          });
        },
        child: const Icon(Icons.play_arrow));
  }

  Widget _buildPlayingRingtone(Ringtone ringtone) {
    return GestureDetector(
        onTap: () async {
          player?.stopPlayer();
          setState(() {
            ringtonePlaying = null;
          });
        },
        child: const Icon(Icons.stop));
  }
}
