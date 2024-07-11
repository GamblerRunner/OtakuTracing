import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tfc/Firebase/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseManager {
  // Constructor: Initializes Firebase when an instance of FirebaseManager is created.
  FirebaseManager() {
    initializeFirebase();
  }

  // User details
  late String uid = '';
  late String userName = '';
  late String userImg = '';

  /// Initializes Firebase with the platform-specific options.
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  //AUTHFirebase

  /// Registers a new user with the given email, password, and username.
  ///
  /// Returns true if the registration is successful, otherwise false.
  Future<bool> registerNewUser(String emailUser, String passwordUser, String userName) async {
    bool create = false;
    try {
      // Attempts to create a new user with the provided email and password.
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailUser, password: passwordUser);

      // Extracts the user ID (UID) from the user credentials.
      String? uid = userCredential.user?.uid.toString();

      // Calls a function to create a new user record in the Firestore database.
      CrearUsuarioCloud(userName, uid!);
      create = true;

      // Additional handling of userCredential can be done here if necessary.
    } catch (e) {
      print(e);
    }
    return create;
  }

  /// Logs in a user with the given email and password.
  ///
  /// Returns the user ID (UID) if the login is successful, otherwise null.
  Future<String?> loginUser(String emailUser, String passwordUser) async {
    String? uid = '';
    try {
      // Attempts to sign in the user with the provided email and password.
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailUser, password: passwordUser);

      // Extracts the user ID (UID) from the user credentials.
      uid = userCredential.user?.uid.toString();
    } catch (e) {
      print(e);
    }
    return uid;
  }

  //Cloud Storage

  /// Creates a new user record in the Firestore database.
  ///
  /// Takes the username and user ID (UID) as parameters.
  Future<void> CrearUsuarioCloud(String userName, String uid) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    // Data to be stored in the new user document.
    final newUserCloud = {
      "username": userName,
      "userimg": "https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg",
    };

    // Attempts to create a new document in the "users" collection with the given UID.
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
      // Waits to get the data from the document
      DocumentSnapshot doc = await docRef.get();

      // Gets the data from the document
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
    uid = (await preferences.getString("uid"))!;

    final docRef = db.collection("users").doc(uid);

    try {
      DocumentSnapshot doc = await docRef.get();

      final data = doc.data() as Map<String, dynamic>;

      //Sets the new userName and userImg for the user
      userName = data['username'] ?? 'empty';
      userImg = data['userimg'] ?? 'img';

      await preferences.setString("userName", userName);
      await preferences.setString("ImgProfile", userImg);
    } catch (e) {
      print("Error getting document: $e");
    }
  }

  Future<bool> getUserFavourite(int id, bool type) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    //Depending in witch interface you enter, it will give you the list of animes or mangas
    String am = "animes";
    if (type) {
      am = "mangas";
    }
    final docRef = db.collection("users")
        .doc(uidUser)
        .collection("follow")
        .doc("media");
    try {
      DocumentSnapshot doc = await docRef.get();
      List<int> favouriteList = [];
      final data = doc.data() as Map<String, dynamic>;

      if (data.isEmpty) {
        return false;
      }
      // Makes sure that data is a list so that can convert to int
      if (data[am] is List<dynamic>) {
        favouriteList =
            (data[am] as List<dynamic>).map((item) => item as int).toList();
        if (favouriteList.contains(id)) {
          return await true;
        }
      }
    } catch (e) {
      // Manage errors
      print("Error getting document: $e");
    }
    return await false;
  }

  Future<void> changeUserName(String userName, String userImg) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous'; //Gets the uid from the user that is currently using the app

    final data = {"username": userName, "userimg": userImg};

    db.collection("users").doc(uidUser).set(data, SetOptions(merge: true));
  }

  Future<void> addRemoveFavourite(int id, bool type, bool addOrRemove) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    DocumentReference animeInstance = db.collection("users").doc(uidUser).collection("follow").doc("media");

    String typeMedia = "mangas";
    if (type) {
      typeMedia = "animes";
    }
    if (addOrRemove) {
      final data = { //in case the data already exists, then it won`t put it again, if not it will just add it to the list in firebase
        typeMedia: FieldValue.arrayUnion([id])
      };
      await animeInstance.set(data, SetOptions(merge: true));//pushes the changes
      return;
    }
    final data = {////in case the data already exists, then it won`t do anything, if not it will delete from the list in firebase
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
      DocumentSnapshot doc = await docRef.get();
      final data = doc.data() as Map<String, dynamic>;

      if (data[am] is List<dynamic>) {
        userMedia =
            (data[am] as List<dynamic>).map((item) => item as int).toList();
      } else {
        userMedia = [];
      }

    } catch (e) {
      print("Error getting document: $e");
    }
    return await userMedia;
  }

  Future<List<String>> getComunities() async {
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore db = FirebaseFirestore.instance;

    final collectionRef = db.collection("communities");
    try {
      QuerySnapshot querySnapshot = await collectionRef.get();
      // Create a list to save the user names
      List<String> chatRooms = [];
      // // Add the document and extract the names from the firebase
      for (var doc in querySnapshot.docs) {
        chatRooms.add(doc.id);
      }
      return chatRooms;
    } catch (e) {
      print("Error getting documents: $e");
      return [];
    }
  }

  Future<List<String>> getMyComunities() async {
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    final docRef = db.collection("users")
        .doc(uidUser)
        .collection("follow")
        .doc("media");
    try {

    DocumentSnapshot doc = await docRef.get();
    List<String> favouriteList = [];
    final data = doc.data() as Map<String, dynamic>;

    if (data.isEmpty) {
    return [];
    }
    if (data['comunities'] is List<dynamic>) {
    favouriteList =
    (data['comunities'] as List<dynamic>).map((item) => item as String).toList();
    }

    return favouriteList;
    } catch (e) {
      print("Error getting documents: $e");
      return [];
    }
  }

  Future<void> addRemoveFavouriteComunity(String comunityName, bool addOrRemove) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    DocumentReference animeInstance = db.collection("users").doc(uidUser).collection("follow").doc("media");

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
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    final docRef = db.collection("users")
        .doc(uidUser)
        .collection("follow")
        .doc("media");
    try {
      DocumentSnapshot doc = await docRef.get();
      List<String> favouriteList = [];
      final data = doc.data() as Map<String, dynamic>;

      if (data.isEmpty) {
        return false;
      }
      if (data["comunities"] is List<dynamic>) {
        favouriteList = (data["comunities"] as List<dynamic>)
            .map((item) => item as String)
            .toList();
        if (favouriteList.contains(comunityName)) {
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

    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    DocumentReference animeInstance = db.collection("users")
        .doc(uidUser) // Use the actual user's UID
        .collection("follow")
        .doc("watchingAnime")
        .collection("watching")
        .doc(name);

    final data = {//Saves in firebase the second in wich the user left the video, so that if he comes back, it will give the user the moment he left it
      episode.toString(): second
    };

    await animeInstance.set(data, SetOptions(merge: true));
  }



  /// Retrieves a list of watched episodes or chapters for a specific anime or manga.
  ///
  /// If [am] is true, it refers to manga; otherwise, it refers to anime.
  /// Returns a list of integers representing the watched episodes or chapters.
  Future<List<int>> getSeenMedia(String name, bool am) async {
    // Simulates a delay of 1 second.
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    // Set parameters based on whether it's anime or manga.
    String type = 'watchingAnime';
    String bp = 'episodes';
    if (am) {
      type = 'watchingManga';
      bp = 'chapters';
    }

    // Reference to the document in Firestore.
    DocumentReference animeInstance = db.collection("users")
        .doc(uidUser)
        .collection("follow")
        .doc(type)
        .collection("watched")
        .doc(name);

    try {
      // Get the document from Firestore.
      DocumentSnapshot doc = await animeInstance.get();

      // Extract the data and convert it to a list of integers.
      final data = doc.data() as Map<String, dynamic>;
      List<dynamic> dynamicList = data[bp] ?? [];
      List<int> infoEpisodes = dynamicList.cast<int>();
      return infoEpisodes;
    } catch (e) {
      print("Error getting documents: $e");
      return [];
    }
  }

  /// Retrieves a list of episodes that the user is currently watching for a specific anime.
  Future<List<int>> getEpisodeWatching(String name) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    // Reference to the document in Firestore.
    DocumentReference animeInstance = db.collection("users")
        .doc(uidUser)
        .collection("follow")
        .doc("watchingAnime")
        .collection("watching")
        .doc(name);

    DocumentSnapshot documentSnapshot = await animeInstance.get();
    List<int> episodeKeys = [];

    // Check if the document exists and extract the keys.
    if (documentSnapshot.exists) {
      Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        episodeKeys = data.keys.map((key) => int.parse(key)).toList();
      }
    }

    return episodeKeys;
  }

  /// Retrieves a list of chapters that the user is currently reading for a specific manga.
  Future<List<int>> getChapterWatching(String name) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    // Reference to the document in Firestore.
    DocumentReference animeInstance = db.collection("users")
        .doc(uidUser)
        .collection("follow")
        .doc("watchingManga")
        .collection("watching")
        .doc(name);

    DocumentSnapshot documentSnapshot = await animeInstance.get();
    List<int> chapters = [];

    // Check if the document exists and extract the chapters.
    if (!documentSnapshot.exists) {
      return [];
    }
    final data = documentSnapshot.data() as Map<String, dynamic>;
    List<dynamic> dynamicList = data['chapters'] ?? [];
    chapters = dynamicList.cast<int>();

    return chapters;
  }

  /// Retrieves the exact second where the user stopped watching a specific episode of an anime.
  Future<int> getEpisodeSecond(String name, int episode) async {
    // Simulates a delay of 1 second.
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore db = FirebaseFirestore.instance;
    String? uidUser = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    int second = 0;

    // Reference to the document in Firestore.
    DocumentReference animeInstance = db.collection("users")
        .doc(uidUser)
        .collection("follow")
        .doc("watchingAnime")
        .collection("watching")
        .doc(name);

    try {
      // Get the document from Firestore.
      DocumentSnapshot doc = await animeInstance.get();

      // Extract the exact second from the data.
      final data = doc.data() as Map<String, dynamic>;
      second = data[episode.toString()] ?? 0;
    } catch (e) {
      print("Error getting document: $e");
    }
    return second;
  }

  /// Retrieves a list of episodes for a specific anime.
  Future<List<String>> getEpisodes(String name) async {
    // Simulates a delay of 1 second.
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore db = FirebaseFirestore.instance;
    var docRef = db.collection("multimedia")
        .doc("animes")
        .collection(name)
        .doc("Episodes");

    try {
      // Get the document from Firestore.
      DocumentSnapshot doc = await docRef.get();

      List<String> episodesList = [];
      if (!doc.exists) {
        // If it doesn't exist, use a default value.
        docRef = db.collection("multimedia")
            .doc("animes")
            .collection("CalicoElectronico")
            .doc("Episodes");
        doc = await docRef.get();
      }
      final data = doc.data() as Map<String, dynamic>;
      if (data.isEmpty) {
        return [];
      }
      if (data['IDs'] is List<dynamic>) {
        episodesList = (data['IDs'] as List<dynamic>).map((item) => item as String).toList();
      }

      return episodesList;
    } catch (e) {
      print("Error getting documents: $e");
      return [];
    }
  }

  /// Retrieves the number of chapters available for a specific manga.
  Future<int> getChapters(String name, int chapters) async {
    // Simulates a delay of 1 second.
    await Future.delayed(Duration(seconds: 1));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var docRef = db.collection("multimedia")
        .doc("mangas")
        .collection(name);

    try {
      // Get the collection of documents.
      var querySnapshot = await docRef.get();
      if (querySnapshot.docs.isEmpty) {
        // If there are no documents, use a default manga based on the conditions.
        String getName = 'BlackCobra';
        if (chapters % 2 == 0) {
          getName = 'Fantastic';
        } else if (chapters % 3 == 0) {
          getName = 'The Flame';
        }
        await preferences.setString("newNameChapter", getName);
        var defaultCollectionRef = db.collection("multimedia")
            .doc("mangas")
            .collection(getName);
        querySnapshot = await defaultCollectionRef.get();
      }

      return querySnapshot.docs.length;
    } catch (e) {
      print("Error getting documents: $e");
      return 0;
    }
  }

  /// Retrieves a list of pages for a specific chapter of a manga.
  Future<List<String>> getPages(String chapter) async {
    // Simulates a delay of 1 second.
    await Future.delayed(Duration(seconds: 1));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    FirebaseFirestore db = FirebaseFirestore.instance;
    String getName = await preferences.getString("newNameChapter") ?? 'The Flame';
    var docRef = db.collection("multimedia")
        .doc("mangas")
        .collection(getName)
        .doc(chapter);

    try {
      // Get the document from Firestore.
      DocumentSnapshot doc = await docRef.get();

      List<String> pagesList = [];
      final data = doc.data() as Map<String, dynamic>;
      if (data.isEmpty) {
        return [];
      }
      if (data['Pages'] is List<dynamic>) {
        pagesList = (data['Pages'] as List<dynamic>).map((item) => item as String).toList();
      }

      return pagesList;
    } catch (e) {
      print("Error getting documents: $e");
      return [];
    }
  }


  Future<void> sendMessage(String communityId, String message, String senderName, String userImg) async {
    var user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      //With the information of the user and the String that it will send, it will travel to the firebase and the rest of the users could see it in real time
      await db.collection('communities').doc(communityId).collection('messages').add({
        'message': message,
        'senderId': user.uid,
        'senderName': senderName ?? 'Anonymous',
        'senderImg': userImg ?? 'https://cdn.pixabay.com/photo/2022/09/01/14/18/white-background-7425603_1280.jpg',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Retrieves a stream of messages from a specific community.
  ///
  /// This function returns a stream of `QuerySnapshot` objects, which contain
  /// messages from the specified community, ordered by their timestamp in ascending order.
  Stream<QuerySnapshot> getMessages(String communityId) {
    // Initialize Firestore instance.
    FirebaseFirestore db = FirebaseFirestore.instance;

    // Return a stream of snapshots from the 'messages' collection within the specified community,
    // ordered by the 'timestamp' field in ascending order.
    return db
        .collection('communities')
        .doc(communityId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }


}