import 'dart:io';

import 'package:audiofiletest/welcome.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AudioFromAssets extends StatefulWidget {
  const AudioFromAssets({Key? key}) : super(key: key);

  @override
  State<AudioFromAssets> createState() => _AudioFromAssetsState();
}

class _AudioFromAssetsState extends State<AudioFromAssets> {
  //we will need some variables
  bool playing = false; // at the begining we are not playing any song
  late AudioPlayer _player;
  late AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  //we will create a custom slider
  //Now let's initialize our player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);
    //allDuu = _player.duration.inMilliseconds.toDouble();
    _player.onDurationChanged.listen((newDuration) {
      setState(() {
        musicLength = newDuration;
      });
    });

    //this function will allow us to move the cursor of the slider while we are playing the song
    _player.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    _player.onPlayerStateChanged.listen((state) {
      setState(() {
        playing = state == PlayerState.PLAYING;
      });
    });
  }

  Future<bool> onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text('Delete This Contact?'),
            content:
                const Text('This will delete the contact from your device.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('Back'),
                onPressed: () {
                  setState(() {
                    _player.pause();
                  });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Welcome()));
                },
              )
            ],
          ),
        ) ??
        false;
    //   _player.pause();
    // Navigator.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/assimg.png',
                  fit: BoxFit.cover,
                  height: 350,
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      spreadRadius: 10,
                      blurRadius: 10,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Masrafi',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                      child: Slider(
                        min: 0,
                        max: musicLength.inSeconds.toDouble(),
                        value: position.inSeconds.toDouble(),
                        onChanged: (value) async {
                          Duration newPos = Duration(seconds: value.toInt());
                          _player.seek(newPos);
                          //seekToSec(value.toInt());
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Text(position.toString()),
                          Text(
                            "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/backword.png',
                          color: Colors.black.withOpacity(.4),
                          height: 20,
                        ),
                        CircleAvatar(
                          radius: 20,
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                playing ? Icons.pause : Icons.play_arrow,
                              ),
                              iconSize: 25,
                              onPressed: () async {
                                if (!playing) {
                                  //now let's play the song
                                  cache.play("audio.mp3");
                                } else {
                                  _player.pause();
                                }
                              },
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/backword.png',
                          color: Colors.black.withOpacity(.4),
                          height: 20,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
