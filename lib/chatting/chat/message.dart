import 'package:cheatting/chatting/chat/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Message extends StatelessWidget {
  const Message({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chat').orderBy('time',descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

          if(snapshot.connectionState==ConnectionState.waiting){    //받아오는 중에는 로딩중 화면
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasData){   //데이터가 있을 경우
            final chatDocs = snapshot.data!.docs;

            return ListView.builder(
              reverse: true,    //메시지 위치를 아래->위로 하기
              itemCount: chatDocs.length,  //가지고 있는 데이터 길이
              itemBuilder: (context, index) {

                return ChatBubble(
                  message: chatDocs[index]['text'],
                  isMe: chatDocs[index]['userID'].toString() ==user!.uid,
                  userName: chatDocs[index]['userName'],
                  userImage: chatDocs[index]['userImage'],
                );
              },
            );
          }
          else{
            print('데이터가 없습니다!');
            return Text('데이터가 없습니다!');
          }
        },
    );
  }
}
