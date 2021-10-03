import 'package:collection/src/iterable_extensions.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:licenta1/pages/text_message.dart';
import 'package:sms/sms.dart';

import '../main.dart';
import 'contacts.dart';

class Sms extends StatefulWidget {


  const Sms();
  @override
  _SmsState createState() => _SmsState();
}

class _SmsState extends State<Sms> {

  SmsQuery query = new SmsQuery();
  late List<SmsMessage> messages1,messages2,messages = []; //in messages1 sunt toate mesajele
  List messagesFiltered = [];
  int sum = -1;
  late Contact currentSmsContact ;
  bool isContactInMyPhone = false; //daca numarul este in tel, acesta are un nume, altfel este afisat un numar(sau 'orange', 'superbet' etc)
  int currentSmsContactIndex = 0;
  final _controller = TextEditingController();
  String messageToSend = '';
  final FlutterTts flutterTts = FlutterTts(); //text to speech



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(myContacts.firstWhereOrNull((element) => element.phones.elementAt(0).value.endsWith(currentAddress.substring(currentAddress.length-3))) !=null)// daca exista in agenda
      {
        currentSmsContact = myContacts.firstWhere((element) => element.phones.elementAt(0).value.endsWith(currentAddress.substring(currentAddress.length-3)));
        isContactInMyPhone = true;
        currentSmsContactIndex = myContacts.indexOf(currentSmsContact);
      }
    else {
      currentSmsContact = new Contact();
    }

   
    subscription.onData((x) => x<0 ? listenSms(x): sendSms(x) );
  }

  @override
  Widget build(BuildContext context) {

    flutterTts.setLanguage("ro-RO");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70.0,
        title: Text(isContactInMyPhone ? currentSmsContact.displayName : currentAddress,//'denis' e gasit, 'dar orange nu, deci va lua address, in loc de display name
          style: TextStyle(fontSize: 40.0),),
        centerTitle: true,
        backgroundColor: isContactInMyPhone?  specialColor.elementAt(currentSmsContactIndex) : Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 50,
          ),
          onPressed: () { streamController.add(202);},//inapoi la messages
        ),
      ),
      body: FutureBuilder(
        future: fetchSMS(),
        builder: (context, snapshot) {
          return Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      itemCount: messages1.length,
                      reverse: true,
                      padding: EdgeInsets.fromLTRB(0,0.0,0.0,0.0),
                      itemBuilder: (context,index){
                        return ListTile(
                          //tileColor: messages1[index].kind == SmsMessageKind.Sent ? Colors.red : Colors.blue ,
                          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          
                          title: TextMessage( messages1[index].body, messages1[index].kind, currentSmsContact, currentSmsContactIndex,isContactInMyPhone),
                        );
                      }


                    ),
                  )
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(width: 10,),
                  Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelText: 'Type your message',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 0),
                            gapPadding: 10,
                            borderRadius: BorderRadius.circular(25)
                          )
                        ),
                        onChanged: (value) => setState(() {
                          messageToSend = value;
                        }),
                      )
                  ),
                  SizedBox(width: 20),


                     Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send,),
                        color: Colors.white,
                        onPressed: (){sendSms(0);},
                      ),
                    ),


                ],
              ),
              SizedBox(height: 10,)
            ],
          );
        },
      ),
    );
  }

   sendSms(int msgType)
  {
    print('TRIMITE');

    if(msgType == 0)
    {                           //mesajul a fost scris la tastatura
      if (messageToSend.length > 0) {
        print('Mesajul trimis este: $messageToSend');

        FocusScope.of(context)
            .unfocus(); //dupa ce se apasa pe send, sa nu mai apara tastatura
        _controller.clear(); //sterge textul din casuta de text
        messageToSend = '';
      }
    }
    else//mesajul a fost dictat
      {
      print('Mesajul ascultat si trimis este: $msgToSend');
      }
  }

  void listenSms(int smsIndex)
  {
    flutterTts.speak(messages1[0].body);
  }

  fetchSMS()
  async {

   // messages1 = await query.querySms(address: currentAddress.replaceAll(' ', ''), kinds: [SmsQueryKind.Inbox,SmsQueryKind.Sent],sort: true);
    //tring currentAdr = currentAddress.replaceAll('-', '');
    //currentAdr = currentAdr.replaceAll(' ', '');
   // print('$currentAdr');
    //messages1 = [];
   // messages1 = await query.querySms(address: currentAdr, kinds: [SmsQueryKind.Inbox,SmsQueryKind.Sent],sort: true);
    messages1 = await query.querySms(address: currentAddress, kinds: [SmsQueryKind.Inbox,SmsQueryKind.Sent],sort: true);
    print('${messages1.elementAt(messages1.length-1).body}');
   // messages1.addAll(messages2);
    //messages1.sort((a,b) {
    //  return a.date.compareTo(b.date);
  //  });



  }

}