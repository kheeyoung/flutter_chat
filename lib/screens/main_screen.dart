import 'dart:io';

import 'package:cheatting/add_image/add_image.dart';
import 'package:cheatting/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cheatting/config/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool showSpinner =false;    //로딩 화면 표시용
  bool isSignUpScreen = true;
  final _formKey = GlobalKey<FormState>();
  String userName='';
  String userEmail='';
  String userPassword='';
  final _authentication=FirebaseAuth.instance;

  File? userPickedImage;
  void pickedImage(File image){
    userPickedImage=image;
  }

  void _tryValidation(){  //폼 제출시 검증 하는 메소드
    final isValid = _formKey.currentState!.validate();  //폼 전체 검증 실행 (validation)
    if(isValid){
      _formKey.currentState!.save();    //폼 전체의 상태 저장(onSaved)
    }
  }

  void showAlert(BuildContext context){
    showDialog(
      context: context,
      builder: (context){
          return Dialog(
            backgroundColor: Colors.white,
            child: AddImage(addImageFunc: pickedImage),
          );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: ModalProgressHUD(   //로딩용 위젯
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();   //화면 아무곳이나 터치시 키보드 내려가게 함
          },
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 300.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('image/red.jpg'),
                      fit: BoxFit.fill
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 90, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(       //텍스트나 문단을 모아 구성할 수 있게 함
                            text: 'Welcome',
                            style: TextStyle(
                              letterSpacing: 1.0,
                              fontSize: 25,
                              color: Colors.white
                            ),
                            children: [
                              TextSpan(
                                text: isSignUpScreen ? ' to My Chat!':' back',
                                style: TextStyle(
                                    letterSpacing: 1.0,
                                    fontSize: 25,
                                    color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ]
                          )
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          isSignUpScreen ? '회원 가입으로 계속하기' : '로그인으로 계속하기',
                          style: TextStyle(
                              letterSpacing: 1.0,
                              color: Colors.white
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),    //배경
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: 180,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  padding: EdgeInsets.all(20.0),
                  height: isSignUpScreen ? 280.0:250.0,
                  width: MediaQuery.of(context).size.width-40,    //화면의 좌우 값을 받아와서, 40만큼 뺀다.
                  margin: EdgeInsets.symmetric(horizontal: 20.0), //죄우 여백을 20씩 준다.
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignUpScreen = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    '로그인',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: !isSignUpScreen ? Palette.activeColor:Palette.textColor1   //로그인 창을 선택 했을 경우 액티브 컬러로
                                    ),
                                  ),
                                  if(!isSignUpScreen)   //로그인 상태가 아닌 경우에 밑줄
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  isSignUpScreen=true;
                                });
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '회원가입',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: !isSignUpScreen ? Palette.textColor1:Palette.activeColor
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      if(isSignUpScreen)
                                      GestureDetector(
                                        onTap: (){
                                          showAlert(context);
                                          },
                                        child:Icon(Icons.image,
                                            color: isSignUpScreen ? Colors.cyan:Colors.grey[300],
                                          )
                                      )
                                    ],
                                  ),
                                  if(isSignUpScreen)
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 3, 35, 0),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        if(isSignUpScreen)
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formKey,    //폼 제출시 검증을 위한 키
                            child: Column(
                              children: [
                                TextFormField(
                                  key : ValueKey(1),    //텍스트 폼 필드 구분 용 키 (입력 값 엉키지 않게 해줌)
                                  validator: (value){   //입력 값 검증 하기
                                    if(value!.isEmpty || value.length <4){
                                      return 'User Name에 4글자 이상 입력 해주세요.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){    //사용자 입력 값 저장
                                    userName=value!;
                                  },
                                  onChanged: (value){
                                    userName=value;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(  //입력창 타원 형태로 만들기
                                      borderSide: BorderSide(
                                        color: Palette.textColor1
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(35.0))
                                    ),
                                    focusedBorder: OutlineInputBorder(  //입력창 타원 형태가 클릭시에도 유지되게 만들기
                                        borderSide: BorderSide(
                                            color: Palette.textColor1
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(35.0))
                                    ),
                                    hintText: 'User Name',
                                    hintStyle: TextStyle(
                                      color: Palette.textColor1
                                    ),
                                    contentPadding: EdgeInsets.all(10)
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  key : ValueKey(2),
                                  validator: (value){   //입력 값 검증 하기
                                    if(value!.isEmpty || !value.contains('@')){
                                      return '유효한 이메일 주소를 입력 해주세요.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){    //사용자 입력 값 저장
                                    userEmail=value!;
                                  },
                                  onChanged: (value){
                                    userEmail=value;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.mail,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(  //입력창 타원 형태로 만들기
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      focusedBorder: OutlineInputBorder(  //입력창 타원 형태가 클릭시에도 유지되게 만들기
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      hintText: 'email',
                                      hintStyle: TextStyle(
                                          color: Palette.textColor1
                                      ),
                                      contentPadding: EdgeInsets.all(10)
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  obscureText: true,    //입력하는 갓ㅂ 안보이게 하기
                                  key : ValueKey(3),
                                  validator: (value){   //입력 값 검증 하기
                                    if(value!.isEmpty || value.length <6){
                                      return 'Password에 6글자 이상 입력 해주세요.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){    //사용자 입력 값 저장
                                    userPassword=value!;
                                  },
                                  onChanged: (value){
                                    userPassword=value;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.password,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(  //입력창 타원 형태로 만들기
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      focusedBorder: OutlineInputBorder(  //입력창 타원 형태가 클릭시에도 유지되게 만들기
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      hintText: 'password',
                                      hintStyle: TextStyle(
                                          color: Palette.textColor1
                                      ),
                                      contentPadding: EdgeInsets.all(10)
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        if(!isSignUpScreen)
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  key : ValueKey(4),
                                  validator: (value){   //입력 값 검증 하기
                                    if(value!.isEmpty || value.length <4){
                                      return 'User Email에 4글자 이상 입력 해주세요.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){    //사용자 입력 값 저장
                                    userEmail=value!;
                                  },
                                  onChanged: (value){
                                    userEmail=value;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(  //입력창 타원 형태로 만들기
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      focusedBorder: OutlineInputBorder(  //입력창 타원 형태가 클릭시에도 유지되게 만들기
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      hintText: 'User Email',
                                      hintStyle: TextStyle(
                                          color: Palette.textColor1
                                      ),
                                      contentPadding: EdgeInsets.all(10)
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  obscureText: true,    //입력하는 값 안보이게 하기
                                  key : ValueKey(5),
                                  validator: (value){   //입력 값 검증 하기
                                    if(value!.isEmpty || value.length <6){
                                      return 'Password에 6글자 이상 입력 해주세요.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){    //사용자 입력 값 저장
                                    userPassword=value!;
                                  },
                                  onChanged: (value){
                                    userPassword=value;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.password,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(  //입력창 타원 형태로 만들기
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      focusedBorder: OutlineInputBorder(  //입력창 타원 형태가 클릭시에도 유지되게 만들기
                                          borderSide: BorderSide(
                                              color: Palette.textColor1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(35.0))
                                      ),
                                      hintText: 'password',
                                      hintStyle: TextStyle(
                                          color: Palette.textColor1
                                      ),
                                      contentPadding: EdgeInsets.all(10)
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),    //텍스트 폼 필드
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: isSignUpScreen? 430:390,
                right: 0,
                left: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: GestureDetector(
                      onTap: () async{
                        setState(() {
                          showSpinner=true;   //로딩 보이게 함
                        });
                        if(isSignUpScreen){   //회원가입 창일 경우
                          if(userPickedImage==null){
                            setState(() {
                              showSpinner=false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content:
                              Text('프로필 이미지를 등록해주세요.'),
                                backgroundColor: Colors.blue,
                              )
                            );
                            return;
                          }
                          _tryValidation();
                          try{
                            //새로운 유저를 파이어 베이스에 등록
                            final newUser= await _authentication.createUserWithEmailAndPassword(
                                email: userEmail,
                                password: userPassword
                            );

                            //이미지 처리용 (ref=클라우드 스토리지 버킷(파일 저장소) 경로에 접근하게 함)
                            final refImage=FirebaseStorage.instance.ref().
                            child('pick_image').    //저장할 저장소 명
                            child(newUser.user!.uid+'.png');//파일 명 (전부 달라야 한다. 그래서 유저 uid로 함)
                            
                            await refImage.putFile(userPickedImage!); //파일 넣기 (저장소에)
                            final url = await refImage.getDownloadURL();  //파일의 url을 변수에 가져옴
                            //회원 아이디도 저장하기 위해 인스턴스 생성 -> id(uid) 추가.
                            // user라는 곳에  저장할 때 컬럼이 없으면 자동으로 추가해줌
                            //doc(newUser.user!.uid)는 user 어디에 넣을지 알려주는 식별자
                            //set은 future 타입 반환 -> await 필요
                            await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid).set(
                              { //추가할 정보
                                'username' : userName,
                                'email' : userEmail,
                                'pickedImage' : url,
                              }
                            );
                            if(newUser.user != null){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context){
                                    return ChatScreen();
                                  }
                                )
                              );
                              setState(() {
                                showSpinner=false;    //로딩 안보이게 함
                              });
                            }
                          }
                          catch(e){   //인증 오류시
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content:
                                  Text('이메일과 패스워드를 확인해주세요.'),
                                backgroundColor: Colors.blue,
                              )
                            );
                            setState(() {
                              showSpinner=false;    //로딩 안보이게 함
                            });
                          }
                        }
                        if(!isSignUpScreen){    //로그인 창일 경우
                          try{
                            _tryValidation();   //이상한 값 없나 확인
                            //이메일, 비번으로 로그인
                            final newUser=await _authentication.signInWithEmailAndPassword(
                                email: userEmail,
                                password: userPassword
                            );
                            if(newUser.user != null){
                              setState(() {
                                showSpinner=false;    //로딩 안보이게 함
                              });
                            }
                          }
                          catch(e){
                            print(e);
                            if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content:
                                Text('이메일과 패스워드를 확인해주세요.'),
                                  backgroundColor: Colors.blue,
                                )
                            );
                            setState(() {
                              showSpinner=false;    //로딩 안보이게 함
                            });
                          }}
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange, Colors.red
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0,5)   //그림자가 물체로부터 떨어진 정도
                            )
                          ]
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),    //전송 버튼
              AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                top: isSignUpScreen ? MediaQuery.of(context).size.height-125: MediaQuery.of(context).size.height-165,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      Text(isSignUpScreen ? 'or Signup with': 'or Signed with'),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton.icon(
                        onPressed: (){},
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          minimumSize: Size(155, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          backgroundColor: Palette.googleColor
                        ),
                        icon: Icon(Icons.add),
                        label: Text('Google'),
                      )
                    ],
                  )
              )   //구글 로그인 버튼
            ],
          ),
        ),
      ),
    );
  }
}
