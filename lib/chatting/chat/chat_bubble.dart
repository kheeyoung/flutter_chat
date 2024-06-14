import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {super.key,
      required this.message,
      required this.isMe,
      required this.userName,
      required this.userImage});

  final String message;
  final bool isMe;
  final String userName;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMe)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 45, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(userName),
                  BubbleSpecialOne(
                    text: message,
                    color: Color(0xFF1B97F3),
                    tail: true,
                    textStyle: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          if (!isMe)
            Padding(
              padding: const EdgeInsets.fromLTRB(45,0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName),
                  BubbleSpecialOne(
                    text: message,
                    color: Color(0xFFE8E8EE),
                    tail: true,
                    isSender: false,
                  ),
                ],
              ),
            )
        ],
      ),
      Positioned(
        top: 0,
        right: isMe? 5 : null,
        left: isMe? null :5,
        child: CircleAvatar(
          backgroundImage: NetworkImage(userImage),
        ),
      )

    ]);
  }
}
