import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speeking';
  double _confidence = 1.0;
  bool _red = false;
  Timer? timer;

  @override
  void initState()
  {
    super.initState();
    _speech = stt.SpeechToText();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => _listen());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

     appBar: AppBar(
       title: Text('Confidence : ${(_confidence * 100.0).toStringAsFixed(1)}%'),
     ),
      body: Center(
        child: Text(_text),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
        onPressed: _listen,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        )
      ),
    );
  }

  void _listen() async
  {

          if (!_isListening) {
            bool available = await _speech.initialize(
              onStatus: (val) => print('onStatus: $val'),
              onError: (val) => print('onError: $val'),
            );
            if (available) {
              setState(() => _isListening = true);
              _speech.listen(
                onResult: (val) =>
                    setState(() {
                      _text = val.recognizedWords;
                      if (_text.endsWith("red")) {
                        setState(() => _red = true);
                        Navigator.pushReplacementNamed(
                            context, '/home', arguments: {
                          'indexPage': 3});
                      }
                      if (_text.endsWith("blue")) {
                        setState(() => _red = true);
                        Navigator.pushReplacementNamed(
                            context, '/home', arguments: {
                          'indexPage': 2});
                      }
                      if (val.hasConfidenceRating && val.confidence > 0) {
                        _confidence = val.confidence;
                      }
                    }),
              );
            }
          }
          else {
            setState(() => _isListening = false);
            _speech.stop();
          }

  }
}