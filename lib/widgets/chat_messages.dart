import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticateUser=FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore
      .instance
      .collection("chat").orderBy('createdAt',descending: true).snapshots(),
      builder: (ctx,chatSnapshots){
        if(chatSnapshots.connectionState==ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty){
          return const Center(
            child: Text("No messages found."),
          );
        }
        if(chatSnapshots.hasError){
          return const Center(
            child: Text("Somthing went wrong...!"),
          );
        }
        final loadedMessages=chatSnapshots.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40,left: 13,right: 13),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx,index){
            final chatMessages= loadedMessages[index].data();
            final nextChatMessages=index+1<loadedMessages.length ?
            loadedMessages[index+1].data()
            : null;
            final currentMesageUserId=chatMessages['userId'];
            final nextMesageUserId=
            nextChatMessages!=null ? nextChatMessages['userId']:null;
            final nextUserIsSame=nextMesageUserId==currentMesageUserId;
            if(nextUserIsSame){
              return MessageBubble.next(
                message: chatMessages['text'], 
                isMe: authenticateUser!.uid == currentMesageUserId,
                );
            }else{
              return MessageBubble.first(
                userImage: chatMessages['userImage'], 
                username: chatMessages['username'], 
                message: chatMessages['text'], 
                isMe: authenticateUser!.uid == currentMesageUserId,
                );
            }
          },
          
          );
      },
      );
  }
}