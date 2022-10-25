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
        title: Text('Audio Boss'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 300.0,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
              },
              child: const Text(
                "From URL",
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AudioFromAssets()));
              },
              child: const Text(
                "From Asset",
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AudioLocalStore()));
              },
              child: const Text(
                "From Storage",
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AudioTextSync()));
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
