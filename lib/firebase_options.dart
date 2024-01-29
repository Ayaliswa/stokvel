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
    apiKey: 'AIzaSyCFLCQtywPAXXZF5aB8X25hlLWWRx4jpPk',
    appId: '1:349266216363:web:d56c7cc129af4c90c8feee',
    messagingSenderId: '349266216363',
    projectId: 'stokvel-4e463',
    authDomain: 'stokvel-4e463.firebaseapp.com',
    storageBucket: 'stokvel-4e463.appspot.com',
    measurementId: 'G-QYQ9526GW7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkmkrm3fqsdZjk7vlkNZcojIc5JJc8dkU',
    appId: '1:349266216363:android:b464511934c75b15c8feee',
    messagingSenderId: '349266216363',
    projectId: 'stokvel-4e463',
    storageBucket: 'stokvel-4e463.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA-Z0mgXvlNw94-ENg_nT5eHsUC41QdkAE',
    appId: '1:349266216363:ios:e96f4482fb6468e3c8feee',
    messagingSenderId: '349266216363',
    projectId: 'stokvel-4e463',
    storageBucket: 'stokvel-4e463.appspot.com',
    iosBundleId: 'com.example.stokvel',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA-Z0mgXvlNw94-ENg_nT5eHsUC41QdkAE',
    appId: '1:349266216363:ios:1bd1054d64aab521c8feee',
    messagingSenderId: '349266216363',
    projectId: 'stokvel-4e463',
    storageBucket: 'stokvel-4e463.appspot.com',
    iosBundleId: 'com.example.stokvel.RunnerTests',
  );
}
