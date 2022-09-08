import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_doctors/colors.dart';
import 'package:dashboard_doctors/models/message.dart';
import 'package:dashboard_doctors/screens/home/home_page.dart';
import 'package:dashboard_doctors/widgets/home/chat_doctor/all_messages_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../globals.dart' as globals;

class Chat extends StatefulWidget {
  final Stream<QuerySnapshot> myStream;
  final String imageUrl;

  Chat({super.key, required this.myStream, required this.imageUrl});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final chatMsgTextController = TextEditingController();
  String messageText = '';


  @override
  Widget build(BuildContext context) {

    return Container(
      width: 366.w,
      // margin:  EdgeInsets.only(/*right: 38.w,left: 38.w,*/bottom: 38.h),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            height: 40.h,
            width: double.infinity,
            decoration: BoxDecoration( color:HexaColor('#4E7AC7'),
                borderRadius:BorderRadius.only
              (topLeft: Radius.circular(16),topRight: Radius.circular(16))),
            margin: EdgeInsets.only( bottom: 13.h),
            child: Center(child: Text(
              'Messages',
              style: TextStyle(fontSize: 20.sp, color: Colors.white),
            ))
          ),
          Expanded(
              child: AllMessagesWidget(
            myStream: widget.myStream,
            imageUrl: widget.imageUrl,
          )),
          Padding(
            padding: EdgeInsets.only(left: 20.w,right: 20.w,bottom: 24.h),
            child: Column(
              children: [
                Divider(color: HexaColor('#EBEBEB'),),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        // height: 44.h,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(22),
                        color:HexaColor("#EBEBEB"),),
                        child: Center(
                          child: TextField(
                            onChanged: (value) {
                              messageText = value;
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                            controller: chatMsgTextController,
                            decoration:  InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20.h, horizontal: 20.w),
                              hintText: 'הודעה',
                              hintStyle:
                                  TextStyle(fontFamily: 'Poppins', fontSize: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 7.w,),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: CircleAvatar(
                        backgroundColor: HexaColor("#7EB5FF"),
                      radius: 22.w,
                          // decoration: BoxDecoration(
                          //   shape: BoxShape.circle,
                          //   //  borderRadius: BorderRadius.circular(22),
                          // ),
                          // shape: CircleBorder(),
                          // color:HexaColor("#7EB5FF"),

                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                           )
                          // Text(
                          //   'Send',
                          //   style: kSendButtonTextStyle,
                          // ),
                          ),
                    ),
                  ],
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
        imageUrl: '',
        isDoctor: true);
    await FirebaseFirestore.instance
        .collection('chats/${globals.chosenPatientId}/messages')
        .add(message.toJson());
  }
}
