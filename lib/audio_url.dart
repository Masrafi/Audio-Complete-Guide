import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'welcome.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';
  @override
  void initState() {
    // TODO: implement initState
    //setAudio();
    super.initState();
    //setAudio();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  // Future setAudio() async {
  //   final result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     final file = File(result.files.single.path!);
  //     audioPlayer.setUrl(file.path, isLocal: true);
  //   }
  // }
  // setAudio()async{
  //   audioPlayer.setReleaseMode(ReleaseMode.LOOP);
  //
  //   // String url = '';
  //   // audioPlayer.setUrl(url);
  //   final result= await FilePicket.platform.pickFiles();
  //   if(result != null){
  //     final file = File(result.files)
  //   }
  //   audioPlayer.setUrl(url.path,isLocal: true);
  //
  // }
/*  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }*/
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
                    audioPlayer.pause();
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
                  'assets/urlimg.png',
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
                        max: duration.inSeconds.toDouble(),
                        value: position.inSeconds.toDouble(),
                        onChanged: (value) async {
                          final position = Duration(seconds: value.toInt());
                          await audioPlayer.seek(position);

                          await audioPlayer.resume();
                          // setState(() {
                          //   audioPlayer.seek(Duration(seconds: value.toInt()));
                          // });
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
                          ),
                          Text(
                              "${(duration - position).inMinutes.toString()}:${(duration - position).inSeconds.remainder(60).toString()}"),
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
                                isPlaying ? Icons.pause : Icons.play_arrow,
                              ),
                              iconSize: 25,
                              onPressed: () async {
                                if (isPlaying) {
                                  await audioPlayer.pause();
                                } else {
                                  await audioPlayer.play(url);
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
