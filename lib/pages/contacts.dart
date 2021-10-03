import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:licenta1/main.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'home.dart';



class Contacts extends StatefulWidget {


  const Contacts({Key? key}) : super(key: key);
  @override
  _ContactsState createState() => _ContactsState();

}

class _ContactsState extends State<Contacts> {


  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];


  final List<Contacts> finalContacts = [];

  int index1 = 0;
  Random random =  new Random();
  TextEditingController searchController = new TextEditingController();
  String searchLabel = 'Search';
  Map data = {};
  Timer? timer;
  String _text = '';
  int selectedIndex = 0;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    searchController.addListener(() {
      filterContacts(' ');
    });
    timer = Timer.periodic(Duration(milliseconds: 1000), (Timer t) => _listenTest());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  filterContacts(String text)
  {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if(searchController.text.isNotEmpty)
      {
        _contacts.retainWhere((contact) {
          String searchTerm = searchController.text.toLowerCase();
          String contactName = contact.displayName.toLowerCase();
          return contactName.contains(searchTerm);
        });
      }
    else{

      _contacts.retainWhere((contact) {
        String searchTerm = text;
       // print('search for:($text)');
        String contactName = contact.displayName.toLowerCase();
        return contactName.contains(searchTerm);
      });
    }

    setState(() {
      contactsFiltered = _contacts;
    });
  }


  @override
  Widget build(BuildContext context) {

    data = data!= null && data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;


    if(contacts!= null && contacts.length == 0) {
      contacts = data['contacts'];
      _text = data['text'];
      print('$_text');
    }

    bool isSearching = searchController.text.isNotEmpty;

    if(_text.length > 0)
      {
        setState(() {
          if(_text.contains('clear')) _text = '';
          filterContacts(_text);
          isSearching = true;
          if(_text.contains('red')) {
            isSpecialColor[selectedIndex] = 1;
            specialColor[selectedIndex] = Colors.red;
          }

        });


      }


    return Scaffold(
      //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 70.0,
          title: Text('Contacts', style: TextStyle(fontSize: 40.0),),
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: Icon(Icons.people, size: 60.0,),
        ),
        backgroundColor: Colors.grey[200],
        body:

        Container(

          padding: EdgeInsets.all(0.0),
          child: SingleChildScrollView(

            child: Column(

                  children: <Widget>[
                  SizedBox(height: 10.0),

                  Container(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: TextField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      labelText: 'Search',

                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                          color: Theme.of(context).primaryColor
                                        )
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Colors.grey[850],
                                      )
                                    ),
                                  ),
                   ),
                  ListView.builder(

                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: isSearching == true ? contactsFiltered.length : contacts.length,
                    itemBuilder: (context, index){

                      Contact contact = isSearching == true ? contactsFiltered[index] : contacts[index];

                      return ListTile(

                        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 50.0),
                        horizontalTitleGap: 20.0,

                        tileColor: isSearching? (isSpecialColor[contacts.indexOf(contact)] == 1 ? specialColor[contacts.indexOf(contact)] : Colors.grey[200]) : isSpecialColor[index] == 1 ? specialColor[index] : Colors.grey[200] , //daca e pe search, indexul de la lista e diferit si trebuie aleasa culoarea corecta
                        title: Text(contact.displayName,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 50.0,
                                      ),
                                    ),
                        subtitle: Text(
                                    contact.phones.elementAt(0).value,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.black,
                                  ),
                                  ),
                        leading: (contact.avatar != null && contact.avatar.length > 0) ?
                                  CircleAvatar(
                                    backgroundImage: MemoryImage(contact.avatar),
                                    radius: 30.0,
                                    backgroundColor: Colors.black,

                                  )
                                      :
                                  CircleAvatar(
                                    child: Text(contact.initials(),style: TextStyle(fontSize: 35.0, color: Colors.grey[100]),),
                                    radius: 30.0,
                                    backgroundColor: Colors.black,
                                  )
                        ,
                        onTap: () {

                         selectedIndex = index;
                         if(isSearching == true) { //daca se cauta un contact in search, indexul este diferit de cel al listei intregi
                                    int aux =  contacts.indexOf(contact);
                                    streamController.add(aux);
                                    indexContactColor = aux;
                                }
                         else {streamController.add(index); indexContactColor = index;}
                        },
                      );
                    },
                  ),
                ]
            ),
          ),
        ),
    );
  }

  _listenTest()
  {
    setState(() {
      _text = data['text'];

    });
  }



}



