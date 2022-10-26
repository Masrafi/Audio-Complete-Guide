import 'package:flutter/material.dart';
import 'audio_assets.dart';
import 'audio_local_store.dart';
import 'audio_with_text.dart';
import 'audio_url.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Audio Complete Guide'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 300.0,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const MainPage()));
              },
              child: const Text(
                "Audio from URL",
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AudioFromAssets()));
              },
              child: const Text(
                "Audio from Asset",
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AudioLocalStore()));
              },
              child: const Text(
                "Audio from Storage",
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AudioTextSync()));
              },
              child: const Text(
                "Audio with Text",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
