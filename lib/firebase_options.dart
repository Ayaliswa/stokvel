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
    apiKey: 'AIzaSyAjV11KbvTh2VRw_TzW3RjWt8GOy87RNqA',
    appId: '1:1067608342106:web:90b3b0ab841fb224a36263',
    messagingSenderId: '1067608342106',
    projectId: 'stokvel-623c9',
    authDomain: 'stokvel-623c9.firebaseapp.com',
    storageBucket: 'stokvel-623c9.appspot.com',
    measurementId: 'G-LLJMYSR5BS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtI4wH8kaaya89hDIOHBOHBUnK5-9mFoI',
    appId: '1:1067608342106:android:e41b6eb5cb4a502aa36263',
    messagingSenderId: '1067608342106',
    projectId: 'stokvel-623c9',
    storageBucket: 'stokvel-623c9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDTqnWqkIK4YBkCruLdrpXKwBspxMEyYBQ',
    appId: '1:1067608342106:ios:30b44f64e9e5181ba36263',
    messagingSenderId: '1067608342106',
    projectId: 'stokvel-623c9',
    storageBucket: 'stokvel-623c9.appspot.com',
    iosBundleId: 'com.example.stokvel',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDTqnWqkIK4YBkCruLdrpXKwBspxMEyYBQ',
    appId: '1:1067608342106:ios:62dac61cbb0de1a8a36263',
    messagingSenderId: '1067608342106',
    projectId: 'stokvel-623c9',
    storageBucket: 'stokvel-623c9.appspot.com',
    iosBundleId: 'com.example.stokvel.RunnerTests',
  );
}
