import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key, required this.addImageFunc});

  final Function(File pickedImage) addImageFunc;

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {

  File? pickedImage;
  void _pickImage() async{    //이미지 선택하게 하는 함수
    final imagePicker=ImagePicker();
    final pickedImageFile= await imagePicker.pickImage(
        source: ImageSource.camera,   //카메라 이미지 선택
        imageQuality: 50,             //이미지 품질 50
        maxHeight: 150                //최대 높이 150
    );
    setState(() {
      if(pickedImageFile != null) {
        pickedImage = File(pickedImageFile.path);   //선택한 이미지를 임시저장
      }
    });
    widget.addImageFunc(pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 300,
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            backgroundImage: pickedImage != null ? FileImage(pickedImage!) : null,
          ),
          SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: (){
              _pickImage();
            },
            icon: Icon(Icons.image),
            label: Text('아이콘 추가'),
          ),
          SizedBox(height: 80),
          TextButton.icon(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
            label: Text('Close'),
          )
        ],
      ),
    );
  }
}
