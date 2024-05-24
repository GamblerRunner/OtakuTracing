import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tfc/main.dart';
import 'package:tfc/login.dart';
import 'register.dart';
//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:tfc/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseManager {
  FirebaseManager() {
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

    //AUTHFirebase

  Future<bool> registerNewUser(String emailUser, String passwordUser, String userName) async{
    bool create=false;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailUser, password: passwordUser);
      String? uid = userCredential.user?.uid.toString();
      CrearUsuarioCloud(userName, uid!);
      create=true;
      // Hacer algo con userCredential si es necesario
  } catch (e) {
  print(e);
  }
  return create;
}

  Future<String?> loginUser(String emailUser, String passwordUser) async{
    String? uid='';
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailUser, password: passwordUser);
      uid = userCredential.user?.uid.toString() ;
      print(uid);
    } catch (e) {
      print(e);
    }
    return uid;
  }

    //Cloud Storage
  Future<void> CrearUsuarioCloud(String userName, String uid) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore db = FirebaseFirestore.instance;

    final newUserCloud = {
      "username": userName,
      "userimg": "https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg",
      "favourites": [],
      "comunitiesFollow": []
    };

    db
        .collection("users")
        .doc(uid)
        .set(newUserCloud)
        .onError((e, _) => print("Error writing document: $e"));

  }

}