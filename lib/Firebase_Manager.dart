import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<bool> registerNewUser(String emailUser, String passwordUser,
      String userName) async {
    bool create = false;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailUser, password: passwordUser);
      String? uid = userCredential.user?.uid.toString();
      CrearUsuarioCloud(userName, uid!);
      create = true;
      // Hacer algo con userCredential si es necesario
    } catch (e) {
      print(e);
    }
    return create;
  }

  Future<String?> loginUser(String emailUser, String passwordUser) async {
    String? uid = '';
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailUser, password: passwordUser);
      uid = userCredential.user?.uid.toString();
      print(uid);
    } catch (e) {
      print(e);
    }
    return uid;
  }

  //Cloud Storage

  Future<void> CrearUsuarioCloud(String userName, String uid) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final newUserCloud = {
      "username": userName,
      "userimg": "https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg",
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
        imgData.add(value.toString());
      });
    } catch (e) {
      print("Error img: $e");
    }

    return imgData;
  }

  Future<void> getUser() async {
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore db = FirebaseFirestore.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    final docRef = db.collection("users").doc(uidUser);

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

  Future<bool> getUserFavourite(int id, bool type) async {
    print("holapapapa");
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    String am = "animes";
    if (type) {
      am = "mangas";
    }
    print("holapapapa2");
    final docRef = db.collection("users")
        .doc(uidUser)
        .collection("follow")
        .doc("media");
    print("BRUUUUUUUUUUUH");
    try {
      // Esperar a que se complete la operación de obtener el documento
      DocumentSnapshot doc = await docRef.get();
      print("holapapapa3");
      List<int> favouriteList = [];
      final data = doc.data() as Map<String, dynamic>;
      print('testeando $data');

      if (data.isEmpty) {
        return false;
      }
      // Asegurarte de que 'animes' sea una lista y convertir los elementos a int
      if (data[am] is List<dynamic>) {
        favouriteList =
            (data[am] as List<dynamic>).map((item) => item as int).toList();
        print("menos cosas $favouriteList");
        if (favouriteList.contains(id)) {
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
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    final data = {"username": userName, "userimg": userImg};

    db.collection("users").doc(uidUser).set(data, SetOptions(merge: true));
  }

  Future<void> addRemoveFavourite(int id, bool type, bool addOrRemove) async {
    print("holapapapa");
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    DocumentReference animeInstance = db.collection("users").doc(uidUser).collection("follow").doc("media");

    print("BRUUUUUUUUUUUH");

    String typeMedia = "mangas";
    if (type) {
      typeMedia = "animes";
    }
    print(addOrRemove);
    if (addOrRemove) {
      final data = {
        typeMedia: FieldValue.arrayUnion([id])
      };
      await animeInstance.set(data, SetOptions(merge: true));
      return;
    }
    final data = {
      typeMedia: FieldValue.arrayRemove([id])
    };
    await animeInstance.set(data, SetOptions(merge: true));
  }

  Future<List<int>> getMyAnimes(bool mediaAM) async {
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<int> userMedia = [];
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    String am = 'mangas';
    if (!mediaAM) {
      am = 'animes';
    }

    final docRef = db.collection("users")
        .doc(uidUser)
        .collection("follow")
        .doc("media");

    try {
      // Esperar a que se complete la operación de obtener el documento
      DocumentSnapshot doc = await docRef.get();
      final data = doc.data() as Map<String, dynamic>;
      print('testeando $data');

      // Asegurarte de que 'animes' sea una lista y convertir los elementos a int
      if (data[am] is List<dynamic>) {
        userMedia =
            (data[am] as List<dynamic>).map((item) => item as int).toList();
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

  Future<List<String>> getComunities() async {
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore db = FirebaseFirestore.instance;
    print("Hola1");

    final collectionRef = db.collection("communities");
    print("Hola2");
    try {
      // Obtener todos los documentos en la colección
      QuerySnapshot querySnapshot = await collectionRef.get();
      print("Hola3");
      // Crear una lista para almacenar los nombres de usuario
      List<String> chatRooms = [];
      print("Hola4");
      // Iterar sobre los documentos y extraer los nombres de usuario
      print(querySnapshot.docs);
      for (var doc in querySnapshot.docs) {
        //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print("jajajaj");
        chatRooms.add(doc.id);
        print('jaja $doc');
      }
      print("Hola5");
      print(chatRooms);
      return chatRooms;
    } catch (e) {
      // Manejar errores al obtener los documentos
      print("Error getting documents: $e");
      return [];
    }
  }

  Future<List<String>> getMyComunities() async {
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    print(uidUser);
    final docRef = db.collection("users")
        .doc(uidUser)
        .collection("follow")
        .doc("media");
    print("Hola2");
    try {

    // Esperar a que se complete la operación de obtener el documento
    DocumentSnapshot doc = await docRef.get();
    print("holapapapa3");
    List<String> favouriteList = [];
    final data = doc.data() as Map<String, dynamic>;
    print('testeando $data');

    if (data.isEmpty) {
    return [];
    }
    // Asegurarte de que 'animes' sea una lista y convertir los elementos a int
    if (data['comunities'] is List<dynamic>) {
    favouriteList =
    (data['comunities'] as List<dynamic>).map((item) => item as String).toList();
    print("menos cosas $favouriteList");
    }

    return favouriteList;
    } catch (e) {
      // Manejar errores al obtener los documentos
      print("Error getting documents: $e");
      return [];
    }
  }

  Future<void> addRemoveFavouriteComunity(String comunityName, bool addOrRemove) async {
    print("holapapapa");
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    DocumentReference animeInstance = db.collection("users").doc(uidUser).collection("follow").doc("media");

    print(addOrRemove);
    if (addOrRemove) {
      final data = {
        "comunities": FieldValue.arrayUnion([comunityName])
      };
      await animeInstance.set(data, SetOptions(merge: true));
      return;
    }
    final data = {
      "comunities": FieldValue.arrayRemove([comunityName])
    };
    await animeInstance.set(data, SetOptions(merge: true));
  }

  Future<bool> getUserFavouriteComunity(String comunityName) async {
    print("holapapapa");
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    final docRef = db.collection("users")
        .doc(uidUser)
        .collection("follow")
        .doc("media");
    print("BRUUUUUUUUUUUH");
    try {
      // Esperar a que se complete la operación de obtener el documento
      DocumentSnapshot doc = await docRef.get();
      print("holapapapa3");
      List<String> favouriteList = [];
      final data = doc.data() as Map<String, dynamic>;
      print('testeando $data');

      if (data.isEmpty) {
        return false;
      }
      // Asegurarte de que 'animes' sea una lista y convertir los elementos a int
      if (data["comunities"] is List<dynamic>) {
        favouriteList = (data["comunities"] as List<dynamic>)
            .map((item) => item as String)
            .toList();
        print("menos cosas $favouriteList");
        if (favouriteList.contains(comunityName)) {
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

  Future<String?> getUserUID() async {
    print("durisimo ppa");
    var user = await FirebaseAuth.instance.currentUser;
    print("durisimo ppa ${user?.uid}");
    return await user?.uid;
  }

  Future<void> saveEndDuration(String name, int episode, bool am) async {
    print("holapapapa");
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    print(uid);
    print("aqui paso un puto");
    String type = 'watchingAnime';
    String bp = 'episodes';
    if(am){
      type = 'watchingManga';
      bp = 'chapters';
    }
    DocumentReference animeInstance = db.collection("users").doc(uidUser).collection("follow").doc(
        type).collection("watched").doc(name);
    print('CACAAAAAAAAAAAAAAAAAAAAAAAA');
    final data = {
      bp.toString(): FieldValue.arrayUnion([episode])
    };
    print(data);
    await animeInstance.set(data, SetOptions(merge: true));
  }

  Future<void> saveWatchingManga(String MangaName, int episode) async {
    print("holapapapa");
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    print("aqui paso un puto");
    String type = 'watchingManga';
    DocumentReference animeInstance = db.collection("users").doc(uidUser).collection("follow").doc(
        type).collection("watching").doc(MangaName);

    final data = {
      'chapters': FieldValue.arrayUnion([episode])
    };
    await animeInstance.set(data, SetOptions(merge: true));
    return;
  }

  Future<void> saveDuration(String name, int episode, int second) async {
    print("Guardando duración final del episodio");

    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    print(uidUser);

    DocumentReference animeInstance = db.collection("users")
        .doc(uidUser) // Use the actual user's UID instead of a hardcoded value
        .collection("follow")
        .doc("watchingAnime")
        .collection("watching")
        .doc(name);

    final data = {
      episode.toString(): second
    };

    await animeInstance.set(data, SetOptions(merge: true));
  }



  Future<List<int>> getSeenMedia(String name, bool am) async {
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    print("Hola1");

    String type= 'watchingAnime';
    String bp = 'episodes';
    if(am){
      type = 'watchingManga';
      bp = 'chapters';
    }
    DocumentReference animeInstance = db.collection("users").doc(uidUser).collection("follow").doc(
        type).collection("watched").doc(name);
    print("Hola2");
    try {
      DocumentSnapshot doc = await animeInstance.get();

      final data = doc.data() as Map<String, dynamic>;
      print('testeando $data');

      List<dynamic> dynamicList = data[bp] ?? [];
      List<int> infoEpisodes = dynamicList.cast<int>();
      print("Hola3");
      // Crear una lista para almacenar los nombres de usuario
      print("Hola5");
      print(infoEpisodes);
      return infoEpisodes;
    } catch (e) {
      // Manejar errores al obtener los documentos
      print("Error getting documents: $e");
      return [];
    }
  }

  Future<List<int>> getEpisodeWatching(String name) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    print(uidUser);

    DocumentReference animeInstance = db.collection("users")
        .doc(uidUser) // Use the actual user's UID instead of a hardcoded value
        .collection("follow")
        .doc("watchingAnime")
        .collection("watching")
        .doc(name);

    DocumentSnapshot documentSnapshot = await animeInstance.get();

    List<int> episodeKeys = [];

    if (documentSnapshot.exists) {
      Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        episodeKeys = data.keys.map((key) => int.parse(key)).toList();
      }
    }

    return episodeKeys;
  }

  Future<List<int>> getChapterWatching(String name) async {
    print('caca');
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    print(uidUser);

    DocumentReference animeInstance = db.collection("users")
        .doc(uidUser) // Use the actual user's UID instead of a hardcoded value
        .collection("follow")
        .doc("watchingManga")
        .collection("watching")
        .doc(name);

    print('maricarmen estuvo aqui');
    DocumentSnapshot documentSnapshot = await animeInstance.get();
    print('maricarmen estuvo aqui');
    List<int> chapters = [];

    if(!documentSnapshot.exists){
      return [];
    }
    final data = documentSnapshot.data() as Map<String, dynamic>;
    print('testeando $data');

    List<dynamic> dynamicList = data['chapters'] ?? [];
    chapters = dynamicList.cast<int>();

    print('testeando $data');

    print(chapters);
    return chapters;
  }

  Future<int> getEpiodeSecond(String name, int episode) async {
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    int second =0;

    DocumentReference animeInstance = db.collection("users")
        .doc(uidUser) // Use the actual user's UID instead of a hardcoded value
        .collection("follow")
        .doc("watchingAnime")
        .collection("watching")
        .doc(name);

    try {
      // Esperar a que se complete la operación de obtener el documento
      DocumentSnapshot doc = await animeInstance.get();

      // Obtener los datos del documento
      final data = doc.data() as Map<String, dynamic>;
      print('testeando $data');


      second = data[episode.toString()] ?? 0;
    } catch (e) {
      // Manejar errores al obtener el documento
      print("Error getting document: $e");
    }
    return second;
  }

  Future<List<String>> getEpisodes(String name) async {
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore db = FirebaseFirestore.instance;
    var docRef = db.collection("multimedia")
        .doc("animes")
        .collection(name)
        .doc("Episodes");
    print("Hola2");
    try {

      // Esperar a que se complete la operación de obtener el documento
      DocumentSnapshot doc = await docRef.get();

      print("holapapapa3");
      List<String> episodesList = [];
      if(!doc.exists){
        docRef = db.collection("multimedia")
            .doc("animes")
            .collection("CalicoElectronico")
            .doc("Episodes");
        doc = await docRef.get();
      }
      final data = doc.data() as Map<String, dynamic>;
      if (data.isEmpty) {
        if (data.isEmpty) {
          return [];
        }
      }
      // Asegurarte de que 'animes' sea una lista y convertir los elementos a int
      if (data['IDs'] is List<dynamic>) {
        episodesList =
            (data['IDs'] as List<dynamic>).map((item) => item as String).toList();
        print("menos cosas $episodesList");
      }

      return episodesList;
    } catch (e) {
      // Manejar errores al obtener los documentos
      print("Error getting documents: $e");
      return [];
    }
  }

  Future<int> getChapters(String name, int chapters) async {
    await Future.delayed(Duration(seconds: 1));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var docRef = db.collection("multimedia")
        .doc("mangas")
        .collection(name);
    print("Hola2");
    try {
      var querySnapshot = await docRef.get();
      if (querySnapshot.docs.isEmpty) {
        String getName = 'BlackCobra';
        if(chapters % 2 ==0){
          getName = 'Fantastic';
        }else if(chapters % 3 ==0){
          getName = 'The Flame';
        }
        await preferences.setString("newNameChapter", getName);
        var defaultCollectionRef = db.collection("multimedia")
            .doc("mangas")
            .collection(getName);
        querySnapshot = await defaultCollectionRef.get();
        await preferences.setString("newNameChapter", getName);
      }

      return querySnapshot.docs.length;
    } catch (e) {
      print("Error getting documents: $e");
      return 0;
    }
  }

  Future<List<String>> getPages(String chapter) async {
    await Future.delayed(Duration(seconds: 1));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    FirebaseFirestore db = FirebaseFirestore.instance;
    String getName = await preferences.getString("newNameChapter") ?? 'The Flame';
    print(getName);
    print(chapter);
    var docRef = db.collection("multimedia")
        .doc("mangas")
        .collection(getName)
        .doc(chapter);
    print("Hola209");
    try {

      // Esperar a que se complete la operación de obtener el documento
      DocumentSnapshot doc = await docRef.get();

      print("holapapapa3");
      List<String> pagesList = [];
      final data = doc.data() as Map<String, dynamic>;
      if (data.isEmpty) {
        return [];
      }
      // Asegurarte de que 'animes' sea una lista y convertir los elementos a int
      if (data['Pages'] is List<dynamic>) {
        pagesList =
            (data['Pages'] as List<dynamic>).map((item) => item as String).toList();
        print("menos cosas $pagesList");
      }

      return pagesList;
    } catch (e) {
      // Manejar errores al obtener los documentos
      print("Error getting documents: $e");
      return [];
    }
  }

  Future<void> sendMessage(String communityId, String message, String senderName, String userImg) async {
    var user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection('communities').doc(communityId).collection('messages').add({
        'message': message,
        'senderId': user.uid,
        'senderName': senderName ?? 'Anonymous',
        'senderImg': userImg ?? 'https://cdn.pixabay.com/photo/2022/09/01/14/18/white-background-7425603_1280.jpg',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<QuerySnapshot> getMessages(String communityId) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db.collection('communities').doc(communityId).collection('messages').orderBy('timestamp', descending: false).snapshots();
  }

}