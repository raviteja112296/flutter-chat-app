import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/fcm_sender.dart';

class NewMessage extends StatefulWidget {
  final String receiverUserId;
  const NewMessage({super.key,required this.receiverUserId,});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController=TextEditingController();
  
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
  void _submitMessge() async {
  final enteredMessage = _messageController.text;

  if (enteredMessage.trim().isEmpty) {
    return;
  }

  FocusScope.of(context).unfocus();
  _messageController.clear();

  final user = FirebaseAuth.instance.currentUser!;

  // 1️⃣ Get sender data
  final userData = await FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid)
      .get();

  // 2️⃣ Save message to Firestore
  await FirebaseFirestore.instance.collection("chat").add({
    'text': enteredMessage,
    'createdAt': Timestamp.now(),
    'userId': user.uid,
    'receiverId': widget.receiverUserId,
    'username': userData.data()!['username'],
    'userImage': userData.data()!['image_url'],
  });

  // 3️⃣ Get receiver FCM token
  final receiverDoc = await FirebaseFirestore.instance
      .collection("users")
      .doc(widget.receiverUserId)
      .get();

  final receiverToken = receiverDoc.data()?['fcmToken'];

  // 4️⃣ Send push notification
  if (receiverToken != null) {
    await FCMSender.send(
      token: receiverToken,
      title: userData.data()!['username'],
      body: enteredMessage,
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15,right: 1,bottom: 14),
          child: Row(
            children: [
              Expanded(
                child:TextField(
                  controller: _messageController,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  decoration: const InputDecoration(
                    labelText: "Send a message..."
                  ),
                ) ,
              
              ),
              IconButton(
                onPressed: _submitMessge, 
                icon: Icon(Icons.send),
                color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
    );
  }
}