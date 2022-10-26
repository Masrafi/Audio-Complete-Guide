import 'package:audioplayers/audioplayers.dart';
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
    super.initState();
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
                    audioPlayer.pause();
                  });
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Welcome()),
                      (Route<dynamic> route) => false);
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
          title: const Text('Audio from URL'),
        ),
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
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'https://www.soundhelix.com/examples/\nmp3/SoundHelix-Song-2.mp3',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(
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
                          Text(
                            "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                          ),
                          Text(
                              "${(duration - position).inMinutes.toString()}:${(duration - position).inSeconds.remainder(60).toString()}"),
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
