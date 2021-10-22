import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/screens/BiometricAuthScreen.dart';
import 'package:flutter_app/screens/PaymentSuccess.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';

class PaymentForBlind extends StatefulWidget {
  @override
  _PaymentForBlindState createState() => _PaymentForBlindState();
}

enum TtsState { playing, stopped, paused, continued }

class _PaymentForBlindState extends State<PaymentForBlind> {
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

  @override
  initState() {
    super.initState();
    initTts();
    flutterTts.speak("Double tapping upper part of the screen tells you the balance, and the lower part for voice instructions for payment. You can tap screen halves once to get haptic responses.");

  }

  initTts() {
    flutterTts = FlutterTts();

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
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

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedEnginesDropDownItem(String? selectedEngine) {
    flutterTts.setEngine(selectedEngine!);
    language = null;
    setState(() {
      engine = selectedEngine;
    });
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = selectedType;
      flutterTts.setLanguage(language!);
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
    });
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  @override

  Widget build(BuildContext context) {
     double screenHieght = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/8),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  _buildHeader(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/40,
                  ),
                  GestureDetector(
                      onTap: () {
                        print("Speak the balance");
                        Vibration.vibrate(duration: 100);
                      },
                      onDoubleTap: () {
                        _speak("Your Balance is 8458 dollars. To make a payment double tap on the lower part of the screen.");
                      },
                      child: _buildGradientBalanceCard(screenHieght)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/15,
                  ),
                  _buildCategories(),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/10,
            ),
            //_buildTransactionList()
            GestureDetector(
                onTap: () {
                  print("How may I help you");
                  Vibration.vibrate(duration: 500, amplitude: 120);
                },
                onDoubleTap: () {
                  _speak("Please give me your payment command.");
                  Vibration.vibrate();
                  Timer(Duration(seconds: 5), () {
                    _speak(
                        "Ok Paying 10 dollars. Please verify your identity using Fingerprint or Face ID");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BiometricAuthScreen()));
                  });
                },
                child: Icon(
                  Icons.mic,
                  size: 120.0,
                  color: Colors.purple,
                )),
          ],
        ),
      ),
    );
  }
}

Container _buildTransactionList() {
  return Container(
    height: 400,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      boxShadow: [
        BoxShadow(
          blurRadius: 5,
          color: Colors.grey.withOpacity(0.1),
          offset: Offset(0, -10),
        ),
      ],
    ),
    child: ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0 * 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Transaction",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              SizedBox(height: 16.0 * 2),
              _buildTransactionItem(
                color: Colors.deepPurpleAccent,
                iconData: Icons.photo_size_select_actual,
                title: "Electric Bill",
                date: "Today",
                amount: 11.5,
              ),
              SizedBox(height: 24),
              _buildTransactionItem(
                color: Colors.green,
                iconData: Icons.branding_watermark,
                title: "Water Bill",
                date: "Today",
                amount: 15.8,
              ),
              SizedBox(height: 24),
              _buildTransactionItem(
                color: Colors.orange,
                iconData: Icons.music_video,
                title: "Spotify",
                date: "Yesterday",
                amount: 05.5,
              ),
              SizedBox(height: 24),
              _buildTransactionItem(
                color: Colors.red,
                iconData: Icons.wifi,
                title: "Internet",
                date: "Yesterday",
                amount: 10.0,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Row _buildCategories() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      _buildCategoryCard(
        bgColor: Constants.sendBackgroundColor,
        iconColor: Constants.sendIconColor,
        iconData: Icons.send,
        text: "Send",
      ),
      _buildCategoryCard(
        bgColor: Constants.paymentBackgroundColor,
        iconColor: Constants.paymentIconColor,
        iconData: Icons.payment,
        text: "Payment",
      ),
    ],
  );
}

Container _buildGradientBalanceCard(double screenHeight) {
  return Container(
    height: screenHeight/3.5,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.purpleAccent.withOpacity(0.9),
          Constants.deepBlue,
        ],
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "\$8,458.00",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 28,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Total Balance",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}

Row _buildHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Visually Impaired,",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Test Blind User",
            style: TextStyle(
              fontSize: 28,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ],
  );
}

Row _buildTransactionItem(
    {required Color color,
    required IconData iconData,
    required String date,
    required String title,
    required double amount}) {
  return Row(
    children: <Widget>[
      Container(
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
      SizedBox(width: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            date,
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          )
        ],
      ),
      Spacer(),
      Text(
        "-\$ $amount",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ],
  );
}

Column _buildCategoryCard(
    {required Color bgColor,
    required Color iconColor,
    required IconData iconData,
    required String text}) {
  return Column(
    children: <Widget>[
      Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          iconData,
          color: iconColor,
          size: 36,
        ),
      ),
      SizedBox(height: 8),
      Text(text),
    ],
  );
}
