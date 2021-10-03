import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:swipedetector/swipedetector.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  int _currentIndex = 0;
  late stt.SpeechToText _speech;
  Timer? timer;
  String _text = '';


  @override
  void initState()
  {
    super.initState();
    _speech = stt.SpeechToText();
  //  timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) => _listenTest());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: Container(
        child: Text('LOGIN'),
      )

    );
  }



  void _listenTest() async
  {
    if(_speech.isNotListening ) {
      _listen();
    }
  }
  void _listen() async
  {

    if (_speech.isNotListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus LOGIN: $val'),
        onError: (val) => _speech.stop(),
      );
      if (available) {
        //setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) =>
              setState(() {
                _text = val.recognizedWords;
                textController(_text);
              }),
        );
      }
    }
    else {
      //setState(() => _isListening = false);
      _speech.stop();
    }

  }

  void textController(String text)
  {
    if(text.endsWith("go to login")) {}
    if(text.endsWith("go to contacts")) {}
    if(text.endsWith("go to message")) { }
    if(text.endsWith("go to messages")) {}
    if(text.endsWith("go to events")) {}
    if(text.endsWith("go to settings")) {}

  }
}