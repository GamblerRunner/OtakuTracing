import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfc/main.dart';
import 'package:tfc/login.dart';
import 'register.dart';
//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tfc/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseManager {
  FirebaseManager() {
    initializeFirebase();
  }
  late String uid = '';
  late String userName = '';
  late String userImg = '';

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
    /*await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );*/
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

  Future<List<String>> changeImgProfile() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    List<String> imgData = [];
    final docRef = db.collection("assets").doc("img");

    try {
      // Esperar a que se complete la operación de obtener el documento
      DocumentSnapshot doc = await docRef.get();

      // Obtener los datos del documento
      final data = doc.data() as Map<String, dynamic>;

      data.forEach((key, value) {
        print('jaj $value');
        imgData.add(value.toString());
      });
    } catch (e) {
      print("Error img: $e");
    }

    print('nah nah nah $imgData');
    return imgData;
  }

  Future<void> getUser() async {
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore db = FirebaseFirestore.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = (await preferences.getString("uid"))!;


    final docRef = db.collection("users").doc(uid);

    try {
      // Esperar a que se complete la operación de obtener el documento
      DocumentSnapshot doc = await docRef.get();

      // Obtener los datos del documento
      final data = doc.data() as Map<String, dynamic>;
      print('testeando $data');


      userName = data['username'] ?? 'empty';
      userImg = data['userimg'] ?? 'img';

      await preferences.setString("userName", userName);
      await preferences.setString("ImgProfile", userImg);
    } catch (e) {
      // Manejar errores al obtener el documento
      print("Error getting document: $e");
    }
  }
  Future<bool> getUserFavourite(int id,bool type) async {
    print("holapapapa");
    FirebaseFirestore db = FirebaseFirestore.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = (await preferences.getString("uid"))!;

    String am="animes";
    if(type){
      am="mangas";
    }
    print("holapapapa2");
    final docRef = db.collection("users").doc("BACNUaEwrHNhsd7HV3eDHRt8s6s2").collection("follow").doc("media");
    print("BRUUUUUUUUUUUH");
    try {
      // Esperar a que se complete la operación de obtener el documento
      DocumentSnapshot doc = await docRef.get();
      print("holapapapa3");
      List<int> favouriteList = [];
      final data = doc.data() as Map<String, dynamic>;
      print('testeando $data');

      if(data.isEmpty){
        return false;
      }
      // Asegurarte de que 'animes' sea una lista y convertir los elementos a int
      if (data[am] is List<dynamic>) {
        favouriteList = (data[am] as List<dynamic>).map((item) => item as int).toList();
        print("menos cosas");
        if(favouriteList.contains(id)){
          print("cosas");
          return await true;
        }
      }

    } catch (e) {
      // Manejar errores al obtener el documento
      print("Error getting document: $e");
    }
    return await false;
  }

  Future<void> changeUserName(String userName, String userImg) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = (await preferences.getString("uid"))!;

    final data = {"username": userName, "userimg": userImg};

    db.collection("users").doc(uid).set(data, SetOptions(merge: true));

  }

  Future<void> addRemoveFavourite(int id, bool type, bool addOrRemove) async {
    print("holapapapa");
    FirebaseFirestore db = FirebaseFirestore.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = (await preferences.getString("uid"))!;
    DocumentReference animeInstance = db.collection("users").doc("BACNUaEwrHNhsd7HV3eDHRt8s6s2").collection("follow").doc("media");

    print("BRUUUUUUUUUUUH");

    String typeMedia="mangas";
    if(type){
      typeMedia="animes";
    }
    print(addOrRemove);
    if(addOrRemove) {
      final data = {
        typeMedia: FieldValue.arrayUnion([id])
      };
      await animeInstance.set(data, SetOptions(merge:true));
      return;
      }
      final data = {
        typeMedia: FieldValue.arrayRemove([id])
      };
      await animeInstance.set(data, SetOptions(merge:true));

    }

  Future<List<int>> getMyAnimes(bool mediaAM) async {
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<int> userMedia = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = (await preferences.getString("uid"))!;
    String am='';
    if(!mediaAM){
      am='animes';
    }else{
      am='mangas';
    }

    final docRef = db.collection("users").doc("BACNUaEwrHNhsd7HV3eDHRt8s6s2").collection("follow").doc("media");

    try {
      // Esperar a que se complete la operación de obtener el documento
      DocumentSnapshot doc = await docRef.get();
      final data = doc.data() as Map<String, dynamic>;
      print('testeando $data');

      // Asegurarte de que 'animes' sea una lista y convertir los elementos a int
      if (data[am] is List<dynamic>) {
        userMedia = (data[am] as List<dynamic>).map((item) => item as int).toList();
      } else {
        userMedia = [];
      }

      print(userMedia);
    } catch (e) {
      // Manejar errores al obtener el documento
      print("Error getting document: $e");
    }
    return await userMedia;
  }

}