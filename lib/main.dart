import 'package:cheatting/screens/chat_screen.dart';
import 'package:cheatting/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized(); //파이어베이스 호출 (비동기 방식 메소드라서 플러터 코어 초기화 필요)
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),//인증자가 바뀔때마다(로그인/아웃)상태 전달
        builder: (context, snapshot){
          if(snapshot.hasData){   //스냅샷이 데이터가 있다면 (=로그인 되어 있다면)
            return ChatScreen();  //대화방 리턴
          }
          return LoginSignupScreen();   //아니면 로그인창 리턴
        },
      ),
    );
  }
}