import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:licenta1/pages/login.dart';
import 'package:licenta1/pages/messages.dart';
import 'package:licenta1/pages/my_events.dart';
import 'package:licenta1/pages/settings.dart';
import 'package:licenta1/pages/sms.dart';
import 'package:licenta1/pages/loading.dart';


import 'pages/contacts.dart';
import 'pages/home.dart';

StreamController<int> streamController = StreamController<int>();
StreamController<int> streamControllerContact = StreamController<int>();
StreamController<int> streamControllerSms = StreamController<int>();
var subscription = streamControllerSms.stream.listen(null);//listener
List<int> isSpecialColor =  List.generate(200, (index) => 0);
List<Color> specialColor = List.generate(200, (index) => Colors.black);
int indexContactColor = 0;//care index isi modifica culoarea din contacts
List<Contact> myContacts = [];
String currentAddress = '';//nr de tel selectat la sms
String msgToSend = ''; //mesajul care este dictat de voce/scris
String lastMsg = '';//repeta ultuimul mesaj

void main() {

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black
    )
  );

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/' : (context) => Loading(),
      '/home': (context) => Home(streamController.stream),
      '/contacts': (context) => Contacts(),
      '/events': (context) => MyEvents(),
      '/login': (context) => Login(),
      '/messages': (context) => Messages(),
      '/settings': (context) => Settings(),
      '/sms': (context) => Sms(),
    },

  ));
}

