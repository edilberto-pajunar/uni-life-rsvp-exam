import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mocks the `firebase_core` platform so `Firebase.initializeApp()` /
/// `FirebaseAuth.instance` work in widget tests without a real Firebase
/// backend.
///
/// Several screens (e.g. the HomePage AppBar) read `authProvider`, which builds
/// an `AuthRepositoryImpl` -> `FirebaseAuth.instance` during widget build. Call
/// [setupFirebaseMocks] in `setUpAll` and `await Firebase.initializeApp()` once
/// so those reads don't throw `[core/no-app]`.
typedef Callback = void Function(MethodCall call);

void setupFirebaseMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  FirebasePlatform.instance = _MockFirebasePlatform();
}

class _MockFirebasePlatform extends FirebasePlatform {
  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return _MockFirebaseApp(name);
  }

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return _MockFirebaseApp(name ?? defaultFirebaseAppName, options);
  }

  @override
  List<FirebaseAppPlatform> get apps => [_MockFirebaseApp()];
}

class _MockFirebaseApp extends FirebaseAppPlatform {
  _MockFirebaseApp([String? name, FirebaseOptions? options])
    : super(
        name ?? defaultFirebaseAppName,
        options ??
            const FirebaseOptions(
              apiKey: 'fake',
              appId: 'fake',
              messagingSenderId: 'fake',
              projectId: 'fake',
            ),
      );
}
