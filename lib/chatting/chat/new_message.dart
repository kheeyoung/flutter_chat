import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  final _controller=TextEditingController();
  var _userEnterMessage='';   //사용자가 메시지를 보내는가
  void _sendMessage() async{
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData=await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text' : _userEnterMessage,
      'time' : Timestamp.now(),
      'userID' : user.uid,
      'userName' : userData.data()!['username'],
      'userImage' : userData['pickedImage']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          //공간 차지 막기 위해 Expanded
          Expanded(
            child: TextField(
              maxLines:null,
              controller: _controller,
              decoration: InputDecoration(labelText: '메시지를 보내주세요.'),
              onChanged: (value) {//입력값이 생길 경우 보내기 버튼 활성화
                setState((){
                  _userEnterMessage=value;
                });
              },
            ),
          ),
          IconButton(
              onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,  //문자열의 양끝을 제거 했을때 비었으면=메시지 없음! (메시지 있으면 전송버튼 활성화)
              icon: Icon(Icons.send),
              color: Colors.blue,
          )
        ],
      ),
    );
  }
}
