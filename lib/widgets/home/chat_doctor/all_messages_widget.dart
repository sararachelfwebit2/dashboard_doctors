import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_doctors/models/message.dart';
import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:dashboard_doctors/widgets/home/chat/question_chat_bubble.dart';
import 'package:flutter/material.dart';
import '../../../globals.dart' as globals;

class AllMessagesWidget extends StatefulWidget {

  const AllMessagesWidget({Key? key}) : super(key: key);

  @override
  State<AllMessagesWidget> createState() => _AllMessagesWidgetState();
}

class _AllMessagesWidgetState extends State<AllMessagesWidget> with AutomaticKeepAliveClientMixin  {
  // @override
  late Stream<QuerySnapshot> _myStream;

  @override
  void initState() {
    super.initState();
    _myStream=FirebaseFirestore.instance
        .collection('chats/${globals.chosenPatientId}/messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: /*FirebaseFirestore.instance
          .collection('chats/${globals.chosenPatientId}/messages')
          .orderBy('createdAt', descending: true)
          .snapshots()*/ _myStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
           List<Message> messagesList = [];

          final messages = snapshot.data?.docs.reversed;
          for (var message in messages!) {
            messagesList.add(Message(
              userId: message['userId'],
              text: message['text'],
              createdAt: message['createdAt'].toDate(),
              imageUrl: message['imageUrl'],
              isDoctor: message['isDoctor'],
            ));
          }

          // List<MessageBubble> messageWidgets = [];
          // for (var message in messages) {
          //   final msgText = message.data['text'];
          //   final msgSender = message.data['sender'];
          //   // final msgSenderEmail = message.data['senderemail'];
          //   final currentUser = loggedInUser.displayName;
          //
          //   // print('MSG'+msgSender + '  CURR'+currentUser);
          //   final msgBubble = MessageBubble(
          //       msgText: msgText,
          //       msgSender: msgSender,
          //       user: currentUser == msgSender);
          //   messageWidgets.add(msgBubble);
          // }
          return Expanded(
            child: messagesList.isEmpty
                ? Center(
                    child: Text('no messages yet'),
                  )
                : ListView.builder(
                    reverse: true,
                    itemCount: messagesList.length,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    itemBuilder: (context, index) {
                      return Text(messagesList[index].text);
                    }),
          );
        } else {
          return Center(
            child:
                CircularProgressIndicator(backgroundColor: Colors.deepPurple),
          );
        }
      },
    );
  }
@override
  void dispose() {
  super.dispose();
  }


  @override
  bool get wantKeepAlive => false;
}
