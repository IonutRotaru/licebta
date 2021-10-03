
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:licenta1/main.dart';

bool colorChanged = false;


class ContactProfile extends StatefulWidget {
   ContactProfile({Key? key,required this.contact, required this.contactIndex}) : super(key: key);
   int contactIndex ;
   late Contact contact;
  @override
  _ContactState createState() => _ContactState(contactIndex,contact);
}

class _ContactState extends State<ContactProfile> {

  static int currentIndex = -1;
  late Contact currentContact ;
  Color color = isSpecialColor[indexContactColor] == 1 ? specialColor[indexContactColor] : Colors.black;


  _ContactState(int contactIndex,  Contact contact)
  {
    currentIndex = contactIndex;
    currentContact = contact;
  }

  Widget textfield({@required hintText}) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              letterSpacing: 2,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            fillColor: Colors.white30,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  void changeIndex(int newIndex)
  {
    setState(() {
      currentIndex = newIndex;
      print('NOUL INDEX ESTE $newIndex');
    });
  }@override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: color,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 50,
          ),
          onPressed: () {streamController.add(200);},//inapoi la agenda
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
               // height: 450,
              //  width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [


                  ],
                ),
              )
            ],
          ),
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
             // height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(color) ,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "${currentContact.displayName}",
                  style: TextStyle(
                    fontSize: 35,
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0, left: 124),
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () { pickColor(context);},
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 2,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: (currentContact.avatar != null && currentContact.avatar.length > 0) ? MemoryImage(currentContact.avatar) : AssetImage('assets/profile.png') as ImageProvider,//AssetImage('assets/profile.png'),
                  ),
                ),
              ),
              SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 170,
                    width: 170,
                    child: ElevatedButton(
                      onPressed:() { makeCall();},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green[600],
                        shadowColor: Colors.green,
                        elevation: 10.0,
                        shape: 
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                               // side: BorderSide(color: Colors.black)
                            )
                        ,
                        animationDuration: Duration(milliseconds: 1000),
                      ),
                      child: Center(
                        child: Text(
                          "Call",
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                 
                  Container(
                    height: 170,
                    width: 170,
                    child: ElevatedButton(
                      onPressed: () {
                        currentAddress = currentContact.phones.elementAt(0).value;
                        streamController.add(205);//pagina de sms
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow[700],
                        shadowColor: Colors.yellow,
                        elevation: 10.0,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          // side: BorderSide(color: Colors.black)
                        )
                        ,
                        animationDuration: Duration(milliseconds: 1000),
                      ),
                      child: Center(
                        child: Text(
                          "SMS",
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.white,

                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),

        ],
      ),

    );


  }

  Future<void> makeCall()
   async {
       await FlutterPhoneDirectCaller.callNumber(currentContact.phones.elementAt(0).value);
  }

  Widget buildColorPicker() => ColorPicker(
    pickerColor: color,
    onColorChanged: (color) =>setState(() {
      this.color = color;
    })
  );

  void pickColor(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Pick your color'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildColorPicker(),
          TextButton(
            onPressed: () { Navigator.of(context).pop(); },
            child: Text(
              'SELECT',
                style: TextStyle(fontSize: 20 )
            )
          ),
        ],
      ),
    )
  );

}

class HeaderCurvedContainer extends CustomPainter {

  Color color = isSpecialColor[indexContactColor] == 1 ? specialColor[indexContactColor] : Colors.black;
  HeaderCurvedContainer(Color color) {this.color = color;}

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color; //edit color
    if(color != Colors.black) isSpecialColor[indexContactColor] = 1; //daca e diferit de negru marchez, ca sa nu se faca negru contactul
    if(color != Colors.black) specialColor[indexContactColor] = color;
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
    colorChanged = true;//anunt ca s a schimbat culoarea pt update;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}