import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_doctors/colors.dart';
import 'package:dashboard_doctors/models/message.dart';
import 'package:dashboard_doctors/screens/home/home_page.dart';
import 'package:dashboard_doctors/widgets/home/chat_doctor/all_messages_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../../globals.dart' as globals;

class Chat extends StatefulWidget {


  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final chatMsgTextController = TextEditingController();
  String messageText = '';

  @override
  Widget build(BuildContext context) {
    // if (HomePage.updateChat) {
    //   HomePage.updateChat = false;
    // }
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            color: MyColors.textBlueColor,
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              child: Text(
                'Messages',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
           Expanded(
              child:AllMessagesWidget()),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            // decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                      child: TextField(
                        onChanged: (value) {
                          messageText = value;
                        },
                        controller: chatMsgTextController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          hintText: 'Type your message here...',
                          hintStyle:
                              TextStyle(fontFamily: 'Poppins', fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                    shape: CircleBorder(),
                    color: Colors.blue,
                    onPressed: () {
                      sendMessage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                    // Text(
                    //   'Send',
                    //   style: kSendButtonTextStyle,
                    // ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  sendMessage() async {
    chatMsgTextController.clear();
    Message message = new Message(
        userId: globals.chosenPatientId,
        text: messageText,
        createdAt: DateTime.now(),
        imageUrl: '', isDoctor: true);
    await FirebaseFirestore.instance
        .collection('chats/${globals.chosenPatientId}/messages')
        .add(message.toJson());
  }
}
