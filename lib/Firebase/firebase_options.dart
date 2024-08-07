// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyASuATM6XesHdfL68ppbeCb6l9AFNR4aJE',
    appId: '1:504187737977:web:acc1e85c08f9102ad281a8',
    messagingSenderId: '504187737977',
    projectId: 'otakutracing',
    authDomain: 'otakutracing.firebaseapp.com',
    storageBucket: 'otakutracing.appspot.com',
    measurementId: 'G-ZVR56SH6VX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCMX2T1QQ3DyJNSJybXTnevYm4PYaPIzDQ',
    appId: '1:504187737977:android:aa43f0d3927ae76dd281a8',
    messagingSenderId: '504187737977',
    projectId: 'otakutracing',
    storageBucket: 'otakutracing.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAT-T2SRsT_4qvDu2G1bBJHuZsfryOGZ5Y',
    appId: '1:504187737977:ios:9b15eaf8b6786d1dd281a8',
    messagingSenderId: '504187737977',
    projectId: 'otakutracing',
    storageBucket: 'otakutracing.appspot.com',
    iosBundleId: 'com.example.tfc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAT-T2SRsT_4qvDu2G1bBJHuZsfryOGZ5Y',
    appId: '1:504187737977:ios:e54495a8261bb3a4d281a8',
    messagingSenderId: '504187737977',
    projectId: 'otakutracing',
    storageBucket: 'otakutracing.appspot.com',
    iosBundleId: 'com.example.tfc.RunnerTests',
  );
}
