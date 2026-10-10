// Template file: Salin file ini menjadi lib/firebase_options.dart
// dan masukkan kredensial Firebase project Anda sendiri.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: '1:000000000000:android:000000000000',
    messagingSenderId: '000000000000',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:000000000000:ios:000000000000',
    messagingSenderId: '000000000000',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.firebasestorage.app',
    iosBundleId: 'com.stayjogja.stayjogjaFlutter',
  );
}
