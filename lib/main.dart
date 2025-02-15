import 'dart:async';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:lrl_shopping/app/app.dart';
import 'package:lrl_shopping/app/firebase_options.dart';
import 'package:lrl_shopping/app/flavors.dart';


FutureOr<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await _firebaseInit();
  runApp(const App());
}

Future<void> _firebaseInit() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseCrashlytics.instance.setCustomKey('Environment', Flavors.name);

  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}