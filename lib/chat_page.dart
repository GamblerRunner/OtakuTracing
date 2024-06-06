import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfc/community.dart';

import 'Firebase_Manager.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserName;
  final String receiverUserId;

  ChatPage({
    super.key,
    required this.receiverUserName,
    required this.receiverUserId,
  });

  @override
  State<ChatPage> createState() => ChatPageState();
}

FirebaseManager fm = FirebaseManager();
  class ChatPageState extends State<ChatPage>{
    final TextEditingController messageController = TextEditingController();
    final CommunityPage chatService = CommunityPage();

    void sendMessage() async {
      if(messageController.text.isNotEmpty){
        await chatService.sendMessage(widget.receiverUserId, messageController.text);
        //Clear the controller after sending message
        messageController.clear();
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserName)),
      body: Column(
        children: [
          //messages
          Expanded(
            child: buildMessageList(),
          ),

          //userInput
          buildMessageInput(),
        ],
      ),
    );
  }
  //build message list
  Widget buildMessageList(){
      return StreamBuilder(stream: chatService.getMessage(widget.receiverUserId, fm.uid),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting){
         return const Text('Loading...');
        }

        return ListView(
        children: snapshot.data!.docs.map((document) => buildMessageItem(document)).toList(),
        );
    },
   );
  }
    
    
  //build message item
  Widget buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == fm.uid) ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(data['senderName']),
          Text(data['message']),
        ],
      )
    );
  }

  //build message input
  Widget buildMessageInput(){
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
              labelText: 'Enter message',
              ),
              obscureText: false,
            ),
          ),

          IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward, size: 40,))
        ],
      );
  }


  }
