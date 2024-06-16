import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfc/community.dart';
import 'Firebase_Manager.dart';
import 'animation.dart';

class ChatPage extends StatefulWidget {
  final String community;

  ChatPage({
    super.key,
    required this.community,
  });

  @override
  State<ChatPage> createState() => ChatPageState();
}

FirebaseManager fm = FirebaseManager();

class ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final CommunityPage chatService = CommunityPage();

  String userUID="non";

  String userName="anonimous";
  String userImg="";
  late SharedPreferences preferences ;

  bool following=false;

  @override
  initState() {
    super.initState();
    fetchUserUID();
  }

  Future<void> fetchUserUID() async {
    preferences = await SharedPreferences.getInstance();
    bool following2 = await fm.getUserFavouriteComunity(widget.community);
    String userUIDget = await fm.getUserUID() as String;
    String? userNameGet = await preferences.getString("userName");
    String? userImgGet = await preferences.getString("ImgProfile");
    setState(() {
      userUID = userUIDget;
      userName = userNameGet!;
      userImg = userImgGet!;
      following = following2;
    });
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await fm.sendMessage(widget.community, messageController.text, userName, userImg);
      // Clear the controller after sending message
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.community),
            SizedBox(width: 8.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  following = !following;
                });
                fm.addRemoveFavouriteComunity(widget.community, following);
              },
              child: Icon(
                following ? Icons.favorite : Icons.favorite_border,
                color: following ? Colors.red : Colors.grey,
              ),
            ),// Aquí puedes cambiar el ícono según tus necesidades
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: buildMessageList(),
          ),

          // User Input
          buildMessageInput(),
        ],
      ),
    );
  }

  // Build message list
  Widget buildMessageList() {
    return StreamBuilder(
      stream: fm.getMessages(widget.community),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs.map<Widget>((document) => buildMessageItem(document)).toList(),
        );
      },
    );
  }

  // Build message item
  Widget buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == userUID) ? Alignment.centerRight : Alignment.centerLeft;
    var crossAxisAlignment = (data['senderId'] == userUID) ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    String formattedTime = '';
    if (data['timestamp'] != null) {
      Timestamp timestamp = data['timestamp'];
      DateTime dateTime = timestamp.toDate();
      formattedTime = DateFormat('hh:mm a').format(dateTime);
    }
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data['senderId'] != userUID) CircleAvatar(
            backgroundImage: NetworkImage(data['senderImg'] ?? 'https://cdn.pixabay.com/photo/2022/09/01/14/18/white-background-7425603_1280.jpg'),
            radius: 20.0,
          ),
          if (data['senderId'] != userUID) SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              children: [
                Text(data['senderName'], style: TextStyle(fontWeight: FontWeight.bold)),
                Text(data['message']),
                Text(formattedTime, style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          if (data['senderId'] == userUID) SizedBox(width: 10),
          if (data['senderId'] == userUID) CircleAvatar(
            backgroundImage: NetworkImage(data['senderImg'] ?? 'https://cdn.pixabay.com/photo/2022/09/01/14/18/white-background-7425603_1280.jpg'),
            radius: 20.0,
          ),
        ],
      ),
    );
  }

  // Build message input
  Widget buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [

          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Escriba un mensaje',
                border: OutlineInputBorder(),
              ),
              obscureText: false,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.send, size: 30, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
