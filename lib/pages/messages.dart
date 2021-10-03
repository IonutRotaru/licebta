import 'dart:collection';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import "package:collection/collection.dart";

import '../main.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  TextEditingController searchController = new TextEditingController();
  SmsQuery query = new SmsQuery();
  List messages = [];
  int selectedIndex = 0;
  List messagesFiltered = [];
  List<String> visited1 = [];

  @override
  Widget build(BuildContext context) {

    bool isSearching = searchController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0,
        backgroundColor: Colors.yellow[800],
        centerTitle: true,
        title: Text('Messages', style: TextStyle(fontSize: 40.0),),
        leading: Icon(Icons.message_rounded, size: 60.0,),
      ),
      backgroundColor: Colors.grey[200],
      body:FutureBuilder(
        future: fetchSMS(),
        builder: (context, snapshot) {
          return ListView.builder(
              shrinkWrap: true,
              primary: false,

              itemCount: messagesFiltered.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    //tileColor: isSearching? (isSpecialColor[contacts.indexOf(contact)] == 1 ? specialColor[contacts.indexOf(contact)] : Colors.grey[200]) : isSpecialColor[index] == 1 ? specialColor[index] : Colors.grey[200],
                    contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 50.0),
                    horizontalTitleGap: 20.0,
                    leading: Icon(
                      Icons.markunread,
                      color: Colors.yellow[800],
                      size: 60,
                    ),
                    title: Text(
                        myContacts.firstWhereOrNull((element) => element.phones.elementAt(0).value.endsWith(messagesFiltered[index].address.substring(messagesFiltered[index].address.length-3))) !=null ?
                        myContacts.firstWhere((element) => element.phones.elementAt(0).value.endsWith(messagesFiltered[index].address.substring(messagesFiltered[index].address.length-3))).displayName : messagesFiltered[index].address,
                        style: TextStyle(fontSize: 50),
                    ),

                    subtitle: Text(
                      messagesFiltered[index].body,
                      maxLines: 2,
                      style: TextStyle(fontSize: 25),
                    ),
                    onTap: () {
                      print('${messagesFiltered[index].address}');
                      currentAddress = messagesFiltered[index].address;
                      streamController.add(205);//pagina de sms
                    },
                  ),
                );
              });
        },
      ),
    );
  }


  fetchSMS()
  async {
    //messages = await query.getAllSms;
    messages = await query.querySms(kinds: [SmsQueryKind.Inbox, SmsQueryKind.Sent, SmsQueryKind.Draft],sort: true);

    for(int i = 0; i < messages.length; i++)
      {
        if(!visited1.contains(messages[i].address.substring(messages[i].address.length - 3))) //sa nu se repete mesajele de la acelasi contact, ma uit la ultimele 3 cifre din nr
            {
          messagesFiltered.add(messages[i]);

        }
          visited1.add(messages[i].address.substring(messages[i].address.length - 3));
        }
      
      }

}