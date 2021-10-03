import 'dart:async';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import '../main.dart';
import 'contact.dart';
import 'contacts.dart';
import 'login.dart';
import 'messages.dart';
import 'my_events.dart';
import 'settings.dart';
import 'sms.dart';
import 'SpeechScreen.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';



class Home extends StatefulWidget {
  const Home(this.stream);
  final Stream<int> stream;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map data = {};
  bool isSpeaking = false;
  int _currentIndex = 0;
  final FlutterTts flutterTts = FlutterTts(); //text to speech
  static int contactIndex = 0;
  late stt.SpeechToText _speech;
  bool listeningMsg = false;
  bool lastListeningMsg = false;
  Timer? timer;
  List<Contact> contacts = [];
  String _text = '';
  String lastText = '';
  List<String> pages = ["/login",'/contacts','/message','/messages','/events','/settings'];
   List<Widget> _children = [Login(),Contacts(),Messages(),MyEvents(),Settings(),Sms(),ContactProfile(contactIndex: contactIndex, contact: new Contact(),)];

  final _bottomNavigationBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.login, color: Colors.green[900]), label: 'login',backgroundColor: Colors.black),
    BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.blue), label: 'contacts',backgroundColor: Colors.black),
    //BottomNavigationBarItem(icon: Icon(Icons.sms, color: Colors.orange[600]), label: 'sms',backgroundColor: Colors.black),
    BottomNavigationBarItem(icon: Icon(Icons.message, color: Colors.yellow[800]), label: 'messages',backgroundColor: Colors.black),
    BottomNavigationBarItem(icon: Icon(Icons.event, color: Colors.red[600]), label: 'events',backgroundColor: Colors.black),
    BottomNavigationBarItem(icon: Icon(Icons.settings, color: Colors.white), label: 'settings',backgroundColor: Colors.black),
   // BottomNavigationBarItem(icon: Icon(Icons.call, color: Colors.green[600]), label: 'contact',backgroundColor: Colors.black),

  ];

  @override
  void initState()
  {
    super.initState();
    _speech = stt.SpeechToText();
    timer = Timer.periodic(Duration(milliseconds: 1000), (Timer t) => _listenTest());
    widget.stream.listen((index){
    printText(index);
    });

  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;
    contacts = data['contacts'];

    if(_currentIndex == 6)    _children[6] = ContactProfile(contactIndex: contactIndex, contact: contacts[contactIndex],) ;

    return Scaffold(
       resizeToAvoidBottomInset: false,
       body: SwipeDetector(//trebuie sa functioneze doar pentru paginile viziblie in bottomBar
           child: _children[_currentIndex],
         onSwipeLeft: (){
             setState(() {
              if(_currentIndex >= 0 && _currentIndex < 4) _currentIndex++;
             });
         },
         onSwipeRight: (){
           setState(() {
             if(_currentIndex > 0 && _currentIndex <= 4) _currentIndex--;
           });
         },

       ),
       bottomNavigationBar: BottomNavigationBar(
         onTap: onTapBar,
         currentIndex: (_currentIndex == 5) ?  2 : (_currentIndex == 6) ?  1 : _currentIndex, //pentru paginile fara iconita(5 si 6), indexul trebuie sa ramana in contacts sau messages
         items: _bottomNavigationBarItems,
         selectedItemColor: Colors.white,
         iconSize: 50.0,
         selectedFontSize: 20,
       ),

    );

  }



  void onTapBar(int index)
  {
    setState(() {
      _currentIndex = index;
    });
  }



void _listenTest() async
{
  if(_speech.isNotListening ) {

      print('try to start recording');
      if(listeningMsg)// daca se asculta vocea, se salveaza textul
        {
          msgToSend = lastText;
          print('Inregistrat:$lastText');
        }

      _listen();
  }
}
  void _listen() async
  {

    if (_speech.isNotListening) {

        bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) =>  _speech.stop(),

      );
      if (available) {
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


      _speech.stop();
    }

  }

  void textController(String text)
  {
    print('RECORDED = $text');
    lastListeningMsg = listeningMsg;
////[Login(),Contacts(),Messages(),MyEvents(),Settings(),Sms(),ContactProfile(contactIndex: contactIndex, contact: new Contact(),)];
    if(text.endsWith("go to login") && _currentIndex!=0) {  speak(0); setState(() {_currentIndex = 0;}); }
    if(text.endsWith("go to contacts") && _currentIndex!=1)  { speak(1); setState(() { _currentIndex = 1;}); }
    if(text.endsWith("go to messages") && _currentIndex!=2) { speak(2); setState(() {_currentIndex = 2;}); }
    if(text.endsWith("go to events") && _currentIndex!=3) { speak(3); setState(() {_currentIndex = 3;}); }
    if(text.endsWith("go to settings") && _currentIndex!=4) { speak(4); setState(() {_currentIndex = 4;}); }
    //if(text.endsWith("go to settings") && _currentIndex!=5) { speak(5); setState(() {_currentIndex = 5;}); }
    if(text.contains("search" ) && text.length > 7 && _currentIndex == 1 ) { speak(6); setState(() {data['text'] = text.substring(text.lastIndexOf(" ")+1).toLowerCase();}); }


    //if(listeningMsg == true && !text.endsWith("stop") && !text.endsWith("message") && text.compareTo(lastText) != 0) {msgToSend += ' ' + text.substring(text.lastIndexOf(' ')+1);}// compunerea mesajului care trebuie trimis
    if(text.endsWith("start message") && _currentIndex == 5) { speak(7); listeningMsg = true; msgToSend = ''; } //asculta mesaj
    if(text.endsWith("stop message") && _currentIndex == 5 && listeningMsg) { speak(8); listeningMsg = false; }// incheie ascultare mesaj
    if(text.endsWith("send message") && _currentIndex == 5 && listeningMsg == false) { speak(9);  }// trimite mesajul ascultat
    if(text.endsWith("repeat my message") && _currentIndex == 5 && listeningMsg == false) { speak(10);  }// repeta ce am spus
    if(text.endsWith("repeat last message") && _currentIndex == 5 && listeningMsg == false) { speak(11);  }// repeta ce am spus

    _text = '';

    if(listeningMsg) lastText = text;




  }





  void printText(int val)
  {
    print('am PRIMIT $val');
    if(val < 200)
        setState(() {
          contactIndex = val;
          _currentIndex = 6;
          //ContactProfile(contactIndex: contactIndex, contact: contacts[contactIndex],);
        });
    else{
       switch(val)
       {
         case 200: setState(() {
           _currentIndex = 1; //contacts
         }); break;
         case 202: setState(() {
           _currentIndex = 2; //contacts
         }); break;
         case 205: setState(() {
           _currentIndex = 5; //sms
         });
       }
    }
  }

  speak(int soundIndex) async
  {

    switch(soundIndex)
    {
      case 0: await flutterTts.speak("login");break;
      case 1: await flutterTts.speak("contacts"); break;
      case 2: await flutterTts.speak("messages"); break;
      case 3: await flutterTts.speak("events"); break;
      case 4: await flutterTts.speak("settings"); break;
      case 5: await flutterTts.speak("sms"); break;
      case 6: await flutterTts.speak("finding  ${_text.substring(_text.lastIndexOf(" ")+1).toLowerCase()}"); break;
      case 7: await flutterTts.speak("listening for message"); break;
      case 8: await flutterTts.speak("message ended"); break;
      case 9: await flutterTts.speak("message send");  break;
      case 10: await flutterTts.speak("your message is: $msgToSend"); print("your message is: $msgToSend"); break;
      case 11: await flutterTts.speak("the last message is"); streamControllerSms.add(-1); break;
      default: break;
    }
  }

}