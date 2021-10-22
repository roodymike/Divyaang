import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/PaymentForBlind.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';

class PaymentSuccess extends StatelessWidget {

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.4;
  bool isCurrentLanguageInstalled = false;

  String? _newVoiceText = "Hello Moto";
  int? _inputLength;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool isAndroid = true;
  bool isIOS = false;
  bool isWeb = false;

  initTts() {
    flutterTts = FlutterTts();

    if (isAndroid) {
      _getDefaultEngine();
    }
  }

  Future<dynamic> _getLanguages() => flutterTts.getLanguages;

  Future<dynamic> _getEngines() => flutterTts.getEngines;

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _speak(String text) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(text);
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    initTts();
    flutterTts.speak("Payment successful. Please press lower part of the screen to make a new payment!. You will receive a haptic feedback when you go to the home page");
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            Image.asset(
              "images/payment_successful.gif",
              height: 100.0,
              width: 100.0,
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              "Payment Success!",
              style: TextStyle(fontSize: 28),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            TextButton(
              onPressed: () {
                Vibration.vibrate(pattern: [10, 200, 300, 200, 300, 1000]);
                Timer.periodic(Duration(seconds: 2), (timer) {});
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PaymentForBlind()));
              },
              child: Text(
                "Make a new Payment",
                style: TextStyle(fontSize: 28),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                minimumSize:
                    MaterialStateProperty.all<Size>(Size(500.0, 344.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
