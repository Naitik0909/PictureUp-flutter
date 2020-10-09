import 'package:flutter/material.dart';


class ChatScreen extends StatelessWidget {
//
//  final bool isMe;
//  ChatScreen({this.isMe});
//
  @override
  Widget build(BuildContext context) {

    final Radius radius = Radius.circular(10.0);
    return ListView(
      padding: const EdgeInsets.all(5.0),
      children: [
        MessageBubble(radius: radius, isMe: false, sender: 'Ashish', message: 'Container',),
        SizedBox(height: 5.0,),
        MessageBubble(radius: radius, isMe: false, sender: 'Jayanth', message: 'Bucket',),
        SizedBox(height: 5.0,),
        MessageBubble(radius: radius, isMe: true, sender: 'Naitik', message: 'You guys are wrong!',),
        SizedBox(height: 5.0,),
        MessageBubble(radius: radius, isMe: false, sender: 'Nalin', message: 'Vin Diesel',),
      ],
    );
  }
}

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final Radius radius;
  final String sender;
  final String message;

  MessageBubble({this.radius, this.isMe, this.sender, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(sender,
          style: TextStyle(
              fontSize: 10.0
          ),
        ),
        Material(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(message),
          ),
          elevation: 5.0,
          color: Colors.cyan,
          borderRadius: isMe
              ? BorderRadius.only(
              topLeft: radius,
              bottomLeft: radius,
              bottomRight: radius)
              : BorderRadius.only(
            bottomLeft: radius,
            bottomRight: radius,
            topRight: radius,
          ),
        ),
      ],
    );
  }
}
