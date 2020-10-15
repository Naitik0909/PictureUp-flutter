import 'package:flutter/material.dart';

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
          color: isMe ? Colors.lightBlueAccent : Colors.white60,
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
