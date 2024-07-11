import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String senderId;
  final String senderName;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });
  // Converts the object properties to a map.
  ///
  /// This method is useful for serializing the object to store in a database
  /// or to send over a network.
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId, // ID of the message sender
      'senderName': senderName, // Name of the message sender
      'receiverId': receiverId, // ID of the message receiver
      'message': message, // Content of the message
      'timestamp': timestamp, // Timestamp of when the message was sent
    };
  }

}