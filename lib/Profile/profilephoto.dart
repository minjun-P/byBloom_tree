import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bybloom_tree/auth/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
String? pphotoloc;
User? curuser = authservice.getCurrentUser();
final database= FirebaseFirestore.instance;
final storage= FirebaseStorage.instance;

File? _photo;
String? downloadURL;

Future<String?> AddProfilePhoto() async {
  await getImage(true);
  print("이미지불러오기");//갤러리에서 사진가져오기
  Addphoto s= Addphoto();
  print(_photo);
  String? uploadsuccess= await s.uploadPhoto(_photo); //db에 업로드
  downloadURL= await storage.ref(uploadsuccess).getDownloadURL();
  database.collection('users').doc(authservice
      .getCurrentUser()
      ?.uid).update({'imageUrl':downloadURL});
  print('downloadURL:$downloadURL');
  return downloadURL;

}



Future getImage(bool gallery) async {

  ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  // Let user select photo from gallery
  if (gallery) {
    pickedFile = await picker.pickImage(
        source: ImageSource.gallery);
  }
  // Otherwise open camera to get new photo
  else {
    pickedFile = await picker.pickImage(
      source: ImageSource.camera,);
  }
    if (pickedFile != null) {
      _photo =
          File(pickedFile.path); // Use if you only need a single picture
    } else {
      print('No image selected.');
    }

}


class Addphoto {
  User? curuser = authservice.getCurrentUser();
  String userdir = 'users/${authservice
      .getCurrentUser()
      ?.uid}';

  Future<String?> uploadPhoto(File? s) async {
    try {

      await storage
          .ref('$userdir/profilephoto.png')
          .putFile(s!);
      return '$userdir/profilephoto.png';
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }



}