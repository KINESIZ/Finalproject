// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyD2NKlRA-AIADoR0z0DTGahMT5VtYUSkXw',
    appId: '1:838176800261:web:6165e4c7ebab98105d666c',
    messagingSenderId: '838176800261',
    projectId: 'miniproject-b3a4e',
    authDomain: 'miniproject-b3a4e.firebaseapp.com',
    storageBucket: 'miniproject-b3a4e.firebasestorage.app',
    measurementId: 'G-NMXEV38X03',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_X1SvdLHnWizELJceCC4Rtn87em365Z4',
    appId: '1:838176800261:android:992e594adfa154335d666c',
    messagingSenderId: '838176800261',
    projectId: 'miniproject-b3a4e',
    storageBucket: 'miniproject-b3a4e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDaJfHb33UYZ1htBUayCtLufIdeAsSUGpA',
    appId: '1:838176800261:ios:ae397c278f479ef95d666c',
    messagingSenderId: '838176800261',
    projectId: 'miniproject-b3a4e',
    storageBucket: 'miniproject-b3a4e.firebasestorage.app',
    iosBundleId: 'com.example.miniproject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDaJfHb33UYZ1htBUayCtLufIdeAsSUGpA',
    appId: '1:838176800261:ios:ae397c278f479ef95d666c',
    messagingSenderId: '838176800261',
    projectId: 'miniproject-b3a4e',
    storageBucket: 'miniproject-b3a4e.firebasestorage.app',
    iosBundleId: 'com.example.miniproject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD2NKlRA-AIADoR0z0DTGahMT5VtYUSkXw',
    appId: '1:838176800261:web:420074d3dff384bf5d666c',
    messagingSenderId: '838176800261',
    projectId: 'miniproject-b3a4e',
    authDomain: 'miniproject-b3a4e.firebaseapp.com',
    storageBucket: 'miniproject-b3a4e.firebasestorage.app',
    measurementId: 'G-PD4Y3SDPHE',
  );
}
