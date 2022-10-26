import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'welcome.dart';

class AudioTextSync extends StatefulWidget {
  const AudioTextSync({Key? key}) : super(key: key);

  @override
  _AudioTextSyncState createState() => _AudioTextSyncState();
}

class _AudioTextSyncState extends State<AudioTextSync> {
  bool playing = false;
  late AudioPlayer _player;
  late AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();
  final texts = {
    0: '0 to 5 sec',
    6: '6 to 10 sec',
    11: '11 to 15 sec',
    16: '16 to ... sec',
  };
  static const maximumDisplayTime = 5;
  var displayText = '';
  var lastShownSecond = -maximumDisplayTime - 1;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);
    _player.onDurationChanged.listen((newDuration) {
      setState(() {
        musicLength = newDuration;
      });
    });

    _player.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
      final text = texts[newPosition.inSeconds];
      if (text != null) {
        setState(() {
          displayText = text;
          lastShownSecond = newPosition.inSeconds;
        });
      } else if (newPosition.inSeconds - lastShownSecond >=
          maximumDisplayTime) {
        setState(() {
          displayText = '';
        });
      }
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
          builder: (context) => AlertDialog(
            title: const Text('Delete This Contact?'),
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
                      MaterialPageRoute(builder: (context) => const Welcome()));
                },
              )
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Audio with Text'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
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
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      spreadRadius: 10,
                      blurRadius: 10,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                        child: Text(
                      displayText,
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    )),
                    const SizedBox(
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
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Text(position.toString()),
                          Text(
                            "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),

                          Text(
                            "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
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

  Future _init() async {
    _player.onAudioPositionChanged.listen(
      (event) {
        final text = texts[event.inSeconds];
        if (text != null) {
          setState(() {
            displayText = text;
            lastShownSecond = event.inSeconds;
          });
        } else if (event.inSeconds - lastShownSecond >= maximumDisplayTime) {
          setState(() {
            displayText = '';
          });
        }
      },
    );
  }
}
