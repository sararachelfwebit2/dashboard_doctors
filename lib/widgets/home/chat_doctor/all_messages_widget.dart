import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_doctors/models/message.dart';
import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:dashboard_doctors/widgets/home/chat/question_chat_bubble.dart';
import 'package:flutter/material.dart';
import '../../../globals.dart' as globals;

class AllMessagesWidget extends StatefulWidget {
  final Stream<QuerySnapshot> myStream;


  const AllMessagesWidget({Key? key, required this.myStream}) : super(key: key);

  @override
  State<AllMessagesWidget> createState() => _AllMessagesWidgetState();
}

class _AllMessagesWidgetState extends State<AllMessagesWidget> with AutomaticKeepAliveClientMixin  {
  // @override
 // late Stream<QuerySnapshot> _myStream;
  var data;
  @override
  void initState() {
    print('AllMessagesWidget initstate');
    super.initState();
   // _myStream=fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return
      StreamBuilder<QuerySnapshot>(
      stream: /*FirebaseFirestore.instance
          .collection('chats/${globals.chosenPatientId}/messages')
          .orderBy('createdAt', descending: true)
          .snapshots()*/ widget.myStream,
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

  Stream<QuerySnapshot> fetchData()
  {
  return FirebaseFirestore.instance
        .collection('chats/${globals.chosenPatientId}/messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
  //   return firebaseFirestore
  //       .collection(FirestoreConstants.pathMessageCollection)
  //       .doc(groupChatId)
  //       .collection(groupChatId)
  //       .orderBy(FirestoreConstants.timestamp, descending: true)
  //       .limit(limit)
  //       .snapshots();
  // }


  @override
  bool get wantKeepAlive => false;
}
