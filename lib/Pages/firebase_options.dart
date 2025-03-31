import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default firebase options for web.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have no values for ios, '
              'you can set up .',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB6SKxGQiPamG4wDesSGfHIP6XD4T52Ouc',
    appId: '1:970364248784:android:f189095bf0684f5bb074d5',
    messagingSenderId: '970364248784',
    projectId: 'teamdream-f8a59',
    authDomain: 'teamdream-f8a59.firebaseapp.com',
    storageBucket: 'teamdream-f8a59.firebasestorage.app',
  );
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6SKxGQiPamG4wDesSGfHIP6XD4T52Ouc',
    appId: '1:970364248784:android:f189095bf0684f5bb074d5',
    messagingSenderId: '970364248784',
    projectId: 'teamdream-f8a59',
    storageBucket: 'teamdream-f8a59.firebasestorage.app',
  );
}