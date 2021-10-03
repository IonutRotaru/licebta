import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _loadingState createState() => _loadingState();
}

class _loadingState extends State<Loading> {

  List<Contact> contacts = [];

  void getContacts() async
  {
    List<Contact> contacts1 = (await ContactsService.getContacts()).toList();
    contacts = contacts1;
    myContacts = contacts1;
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'contacts' : contacts,
      'text': ''
    });
  }

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [SizedBox(height: 150.0,),Center(child: Text('importing contacts ', style: TextStyle(fontSize: 30.0,color: Colors.white, fontStyle: FontStyle.italic)),),
          SizedBox(height: 40.0,),
          Center(
            child: SpinKitRing(
              color: Colors.white,
              size: 150.0,
            ),
          ),
        ],
      ),
    );
  }
}
