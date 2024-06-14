import 'package:cheatting/chatting/chat/message.dart';
import 'package:cheatting/chatting/chat/new_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _authentication =FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState(){   //실행시
    super.initState();
    getCurrentUser();   //유저정보 가져오기
  }

  void getCurrentUser(){
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user; //로그인된 유저 정보 가져오기
        print(loggedUser!.email);
        print('로그인이 잘 되었습니다.');
      }
    }
    catch(e){
      print('로그인이 실패했습니다. 아래에서 원인을 확인하세요.');
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅 화면'),
        backgroundColor: Colors.blue,

        actions: [
          IconButton(
              onPressed: (){
                _authentication.signOut();  //로그아웃
              },
              icon: Icon(
                Icons.exit_to_app_sharp,
                color: Colors.white,
              )
          )
        ],
      ),
      body: Container(
          child: Column(
              children: [
                Expanded(
                    child: Message()
                ),
                NewMessage(),
              ],
          ),
      ),
    );
  }
}
