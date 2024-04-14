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

  Future<bool> registerNewUser(String emailUser, String passwordUser) async{
    bool create=false;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailUser, password: passwordUser);
      create=true;
      // Hacer algo con userCredential si es necesario
  } catch (e) {
  print(e);
  }
  return create;
}

  Future<bool> loginUser(String emailUser, String passwordUser) async{
    bool create=false;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailUser, password: passwordUser);
      create=true;
      print("Usuario ${userCredential.user?.email} ha iniciado sesión");
    } catch (e) {
      print(e);
    }
    return create;
  }

    //RealTimeDatabase


}



/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try{
    UserCredential usertCredential= await FirebaseAuth.instance.createUserWithEmailAndPassword(email: 'prueba@gmail.com', password:'123456');
  }catch(e){
    print(e);
  }
  runApp(MaterialApp(home: Firebase_Manager(),));
}
 */