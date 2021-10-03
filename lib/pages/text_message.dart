import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:licenta1/main.dart';
import 'package:sms/sms.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:swipedetector/swipedetector.dart';

class TextMessage extends StatefulWidget{
  final String smsText;
  final SmsMessageKind isSender;
  final Contact currentContact;
  final int currentIndex;
  final bool isContactInMyPhone;

  const TextMessage(this.smsText,this.isSender, this.currentContact, this.currentIndex,this.isContactInMyPhone);

  @override
  _TextMessageState createState() => _TextMessageState();
    
  }

class _TextMessageState extends State<TextMessage>{

   Radius radius = Radius.circular(12);
   BorderRadius borderRadius = BorderRadius.all(Radius.circular(12));
   bool isMe =false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    isMe =  widget.isSender != SmsMessageKind.Sent ? true : false;
    return
          Row(

          mainAxisAlignment: isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (isMe && myContacts.contains(widget.currentContact)) ...[//avatar doar la persoana de la care primesc mesaj
              (widget.currentContact.avatar!=null && widget.currentContact.avatar.length > 0) ?
              CircleAvatar(
                radius: 22,
                backgroundImage: MemoryImage(widget.currentContact.avatar),
              ):
              CircleAvatar(
                child: Text(widget.currentContact.initials(),style: TextStyle(fontSize: 35.0, color: Colors.grey[100]),),
                radius: 30.0,
                backgroundColor:  widget.isContactInMyPhone ? specialColor.elementAt(widget.currentIndex) : Colors.black, //daca un contact are o culoare setata, avatarul sa aiba si el
              ),
              SizedBox(width: 10),
            ],
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              constraints: BoxConstraints(maxWidth: 140),
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[100] : Theme.of(context).accentColor,
                borderRadius: !isMe
                    ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                    : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
              ),
              child: buildMessage(),
            ),
          ],
        );

  }

   Widget buildMessage() => Column(
     crossAxisAlignment:
     isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
     children: <Widget>[
       Text(
         widget.smsText,
         style: TextStyle(color: isMe ? Colors.black : Colors.white),
         textAlign: !isMe ? TextAlign.end : TextAlign.start,
       ),
     ],
   );
}
